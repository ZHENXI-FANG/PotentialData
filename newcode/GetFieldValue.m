function [FieldValue,total_P] = GetFieldValue( gridPoints, fileData, u, FuncType, FusionFunc)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


    %�����ƺ���ֵ������ֵ
    [P, F] = GetPFData(gridPoints, fileData, u, FuncType); 

    % P=exp(P);
    % total_P=sum(P,2);
    % C=horzcat(gridPoints,total_P);
    % x=C(:,1);
    % y=C(:,2);
    % colorData=C(:,3);
    % scatter(x,y,50,colorData,'filled');
    % colormap(jet);
    % colorbar;
    % xlabel('X');
    % ylabel('Y');
    % title('Ea/Eb=50,Eab/Eba=40,The value of potential');
    % hold on;
    % linex=[50.3298377650605,40.2712424725111,30.7756589957772,20.6175091431276];
    % liney=[16.0748038493699,25.8222608101183,29.4387799197674,29.6781699888896];
    % plot(linex,liney,'r-','LineWidth',2);
    % hold off;

    % Before_P=table(P);
    % filename3='D:\PotentialData\data\2Dtest\1224test\E_PotentialValue.xlsx';
    % writetable(Before_P,filename3);

    fig=waitbar(0,'��ֵ��...');                    %��������ʾ

    if FusionFunc=="Add"                       %����ֱ������ں�
        total_P=sum(P,2);
        W=P./total_P;
        W(isnan(W))=1;
        FieldValue=sum(F.*W,2);
        
    elseif FusionFunc=="ExpAdd"  
        %����ָ������ں�
        P=exp(P);
        total_P=sum(P,2);
        W=P./total_P;


        % A=horzcat(gridPoints,W);
        % % ��ȡ��������
        % x = A(:, 1);      % ��һ����Ϊ X ��
        % y = A(:, 2);      % �ڶ�����Ϊ Y ��
        % color1 = A(:, 3); % ������������ɫӳ�䣨ͼ1��
        % color2 = A(:, 4); % ������������ɫӳ�䣨ͼ2��
        % % ����һ���µ�ͼ�δ���
        % figure;
        % % ������һ����ͼ�����ݵ����е�ֵ������ɫӳ��
        % subplot(1, 2, 1);  % 1 �� 2 �е���ͼ����ǰ�����1��
        % scatter(x, y, 50, color1, 'filled');  % 50 �ǵ�Ĵ�С��'filled' ��ʾʵ�ĵ�
        % colormap(jet);                       % ������ɫӳ��Ϊ 'jet'���ɸ�����Ҫѡ������ colormap
        % colorbar;                            % ��ʾ��ɫ��
        % title('Scatter Plot - Color by W');
        % xlabel('X Axis');
        % ylabel('Y Axis');
        % % �����ڶ�����ͼ�����ݵ����е�ֵ������ɫӳ��
        % subplot(1, 2, 2);  % ��ǰ�����2����ͼ
        % scatter(x, y, 50, color2, 'filled');  % 50 �ǵ�Ĵ�С��'filled' ��ʾʵ�ĵ�
        % colormap(hot);                       % ������ɫӳ��Ϊ 'hot'���ɸ�����Ҫѡ������ colormap
        % colorbar;                            % ��ʾ��ɫ��
        % title('Scatter Plot - Color by W');
        % xlabel('X Axis');
        % ylabel('Y Axis');

        W(isnan(W))=1;

        % C=horzcat(gridPoints,W);
        % x=C(:,1);
        % y=C(:,2);
        % colorData=C(:,3);
        % scatter(x,y,50,colorData,'filled');
        % colormap(jet);
        % colorbar;
        % xlabel('X');
        % ylabel('Y');
        % title('Scatter plot with color mapping based on value of potential');
        
        FieldValue=sum(F.*W,2);
        max_value=max(FieldValue);
        min_value=min(FieldValue);
        disp(['���ֵ:',num2str(max_value)]);
        disp(['��Сֵ:',num2str(min_value)]);

    end

    
    waitbar(1,fig,'��ֵ���');                      %��ֵ������������ʾ
    close(fig)


    % V=table(P);
    % f=table(F);
    % C=table(FieldValue);
    % T_W=table(W);
    % filename='D:\PotentialData\data\2Dtest\1224test\E_exp_PotentialValue.xlsx';
    % filename1='D:\PotentialData\data\2Dtest\1128test\F.xlsx';
    % filename2='D:\PotentialData\data\2Dtest\1128test\FieldValue.xlsx';
    % filename4='D:\PotentialData\data\2Dtest\1128test\W.xlsx';
    % writetable(V,filename);
    % writetable(f,filename1);
    % writetable(C,filename2);
    % writetable(T_W,filename4);
    % disp(['�����Ѿ����浽',filename1]);
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
        fileID = fopen(filename,'rt');
        line='';
        for i = 1:1
            line = fgetl(fileID);  % ��ȡ��ǰ��
            if line == -1
                error('�ļ�����������');
            end
        end
        % firstLine = textscan(fileID,'%s',1);            % ��ȡһ��
        fclose(fileID); 
        firstLine = str2double(regexp(line, '\d+(\.\d+)?', 'match'));
        % eval(firstLine{1}{1});                             %ִ�е�һ��
        data=readtable(filename);                      %������ȡ�ļ�

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
            E=[1,0;0,1];
            P= PointsPotential(gridPoints,data, m, u, E, FuncType);
            f=data.F;
            F=repmat(f',N,1); 

    elseif tag==1
            %eval(firstLine{1}{1});                             %����һ�е�������ִ�У���E����ֵ����f��ֵ
            E=[0.8,0;0,0.8];
            data=table2array(data);
            num=size(data,1);
            if num==1                                  %�������ļ�ֻ��һ������ʱ��������� 
                P = PointsPotential(gridPoints,data, m, u, E, FuncType);
            elseif num>1                              %����һ��ʱ�����߼���
                P= LinePotential(gridPoints, data, u,FuncType, E);
            end 
            
            F=repmat(firstLine, N,1);
           
    elseif tag==2
            % eval(firstLine{1}{1});                             %����һ�е�������ִ�У���f��ֵ
            E=[1,0;0,1];
            P =LinePotential(gridPoints, data, u, FuncType, E);               
            F=repmat(firstLine,N,1);
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