function [FieldValue,total_P] = GetFieldValue( gridPoints, fileData, u, FuncType, FusionFunc)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


    %�����ƺ���ֵ������ֵ
    [P, F] = GetPFData(gridPoints, fileData, u, FuncType); 
    
    fig=waitbar(0,'��ֵ��...');                    %��������ʾ

    if FusionFunc=="Add"                       %����ֱ������ں�
        total_P=sum(P,2);
        W=P./total_P;
        W(isnan(W))=1;
        FieldValue=sum(F.*W,2);
        
    elseif FusionFunc=="ExpAdd"           %����ָ������ں�
        P=exp(P);
        total_P=sum(P,2);
        W=P./total_P;
        W(isnan(W))=1;
        FieldValue=sum(F.*W,2);
    end

    
    waitbar(1,fig,'��ֵ���');                      %��ֵ������������ʾ
    close(fig)

end


function [P, F] = GetPFData(gridPoints,fileData, u, FuncType)
%�õ������ƺ���ֵ�Ͷ�Ӧ����ֵ���е�����
% gridPointsΪ����ֵ�㣻
% fileData Ϊ���ݴ洢·���ļ��������У���һ��Ϊ���ͱ�ǩ��0��ʾ�����ݣ�
% 1��ʾ�����ݣ�2��ʾ������m2ģ�ͣ��ڶ���Ϊ�ļ�·��
% uΪ����ָ����FuncTypeΪ�ƺ�������
    [~,D]=size(gridPoints);
    [Limit,dataMax,dataMin] = GetDataLimit(fileData, D);
    h=(dataMax(D)-dataMin(D)).*0.1;
    n=size(fileData, 1);
    j=0;
    r=1;
    P=[];F=[];

    folderName="C:\dataAdjust";
    if ~exist(folderName, 'dir')                   % �жϸ��ļ����Ƿ��Ѿ�����
        mkdir(folderName);                          % ���������򴴽��µ��ļ���
        existFolder=0;                                   % �������ڱ��Ϊ0������ɾ��
    else
        existFolder=1;
    end

    fig=waitbar(0,'��ʼ����');
    for i =1:n
        tag=fileData{i,1};
        filename = fileData{i,2};
        fileID = fopen(filename,'r');
        firstLine = textscan(fileID,'%s',1);            % ��ȡһ��
        fclose(fileID);    
        % eval(firstLine{1}{1});                             %ִ�е�һ��
        data=readtable(filename);                      %�������ȡ�ļ�

        [newP, newF]=PFCalculate(gridPoints, tag,firstLine, data,u,FuncType);  
        %����data�������ƺ���P�Ͷ�Ӧ��F
        [P]=horzcat(P,newP);    
        [F]=horzcat(F,newF);                %�ϲ��洢��P,F
        waitbar(i/n,fig,'������...')
    end

    waitbar(1,fig,'�������');
    close(fig);
end

function [P, F]=PFCalculate(gridPoints, tag,firstLine, data,u,FuncType)
    P=[];F=[];
    N=size(gridPoints,1);
    m=1;
    if tag==0 
            % eval(firstLine{1}{1});                           %����һ�е�������ִ�У���E����ֵ
            E=[1,16;0,1];
            P= PointsPotential(gridPoints,data, m, u, E, FuncType);
            f=data.F;
            F=repmat(f',N,1); 

        elseif tag==1
            eval(firstLine{1}{1});                             %����һ�е�������ִ�У���E����ֵ����f��ֵ
            E=[4,1;2,4];
            
            data=table2array(data);
            num=size(data,1);
            if num==1                                  %�������ļ�ֻ��һ������ʱ��������� 
                P = PointsPotential(gridPoints,data, m, u, E, FuncType);
            elseif num>1                              %����һ��ʱ�����߼���
                P= LinePotential(gridPoints, data, u,FuncType, E);
            end   
            F=repmat(f, N,1);
           
        elseif tag==2
            E=[1,0;0,1];
            % eval(firstLine{1}{1});                             %����һ�е�������ִ�У���f��ֵ
            P =LinePotential(gridPoints, data, u, FuncType, E);               
            F=repmat(f,N,1);
    end
end


function writeFirstline(firstLine, data, fileFullPath)
    writetable(data,fileFullPath)
    fid = fopen(fileFullPath, 'rt+');
    fseek(fid, 0, 'bof');
    dataStr = fread(fid, '*char')';
    fclose(fid);
    fid_w=fopen(fileFullPath,'w');        
    content=[firstLine,newline,dataStr];
    fwrite(fid_w, content, '*char');                    %д��������
    fclose(fid_w);
end