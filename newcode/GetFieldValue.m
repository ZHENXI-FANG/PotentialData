function [FieldValue,total_P] = GetFieldValue( gridPoints, fileData, u, FuncType, FusionFunc)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明


    %计算势函数值及属性值
    [P, F] = GetPFData(gridPoints, fileData, u, FuncType); 

    Before_P=table(P);
    
    % filename3='D:\PotentialData\data\2Dtest\1128test\before_V.xlsx';
    % writetable(Before_P,filename3);


    fig=waitbar(0,'插值中...');                    %进度条提示

    if FusionFunc=="Add"                       %数据直接相加融合
        total_P=sum(P,2);
        W=P./total_P;
        W(isnan(W))=1;
        % New_W=W*0.85;
        FieldValue=sum(F.*W,2);
        
    elseif FusionFunc=="ExpAdd"           %数据指数相加融合
        P=exp(P);
        total_P=sum(P,2);
        W=P./total_P;
        W(isnan(W))=1;
        FieldValue=sum(F.*W,2);
    end

    
    waitbar(1,fig,'插值完成');                      %插值结束进度条提示
    close(fig)


    % V=table(P);
    % f=table(F);
    % C=table(FieldValue);
    % T_W=table(W);
    % % filename='D:\PotentialData\data\2Dtest\1128test\V.xlsx';
    % filename1='D:\PotentialData\data\2Dtest\1128test\F.xlsx';
    % filename2='D:\PotentialData\data\2Dtest\1128test\c.xlsx';
    % filename4='D:\PotentialData\data\2Dtest\1128test\t_w.xlsx';
    % % writetable(V,filename);
    % writetable(f,filename1);
    % writetable(C,filename2);
    % writetable(T_W,filename4);
    % disp(['数据已经保存到',filename1]);


end


function [P, F] = GetPFData(gridPoints,fileData, u, FuncType)
%得到包括势函数值和对应属性值两列的数据
% gridPoints为待插值点；
% fileData 为数据存储路径文件，有两列，第一列为类型标签，0表示点数据；
% 1表示线数据；2表示线数据m2模型；第二列为文件路径
% u为距离指数，FuncType为势函数类型
    [~,D]=size(gridPoints);
    [Limit,dataMax,dataMin] = GetDataLimit(fileData, D);
    h=(dataMax(D)-dataMin(D)).*0.1;
    n=size(fileData, 1);
    j=0;
    r=1;
    P=[];F=[];

    folderName="C:\dataAdjust";
    if ~exist(folderName, 'dir')                   % 判断该文件夹是否已经存在
        mkdir(folderName);                          % 若不存在则创建新的文件夹
        existFolder=0;                                   % 若不存在标记为0，后续删除
    else
        existFolder=1;
    end

    fig=waitbar(0,'开始计算');
    for i =1:n
        tag=fileData{i,1};
        filename = fileData{i,2};
        fileID = fopen(filename,'rt');
        line='';
        for i = 1:1
            line = fgetl(fileID);  % 读取当前行
            if line == -1
                error('文件中行数不足');
            end
        end
        % firstLine = textscan(fileID,'%s',1);            % 读取一行
        fclose(fileID); 
        firstLine = str2double(regexp(line, '\d+(\.\d+)?', 'match'));
        % eval(firstLine{1}{1});                             %执行第一行
        data=readtable(filename);                      %按表格读取文件

        [newP, newF]=PFCalculate(gridPoints, tag,firstLine, data,u,FuncType);  
        %计算data产生的势函数P和对应的F
        [P]=horzcat(P,newP);    
        [F]=horzcat(F,newF);                %合并存储入P,F
        waitbar(i/n,fig,'计算中...')
    end

    waitbar(1,fig,'计算完毕');
    close(fig);
end

function [P, F]=PFCalculate(gridPoints, tag,firstLine, data,u,FuncType)
    P=[];F=[];
    N=size(gridPoints,1);
    m=1;
    if tag==0 
            % eval(firstLine{1}{1});                           %将第一行当作命令执行，给E矩阵赋值
            E=[1,0;0,1];
            P= PointsPotential(gridPoints,data, m, u, E, FuncType);
            f=data.F;
            F=repmat(f',N,1); 

    elseif tag==1
            %eval(firstLine{1}{1});                             %将第一行当作命令执行，给E矩阵赋值，给f赋值
            E=[1,0;0,1];
            data=table2array(data);
            num=size(data,1);
            if num==1                                  %线数据文件只有一行数据时，按点计算 
                P = PointsPotential(gridPoints,data, m, u, E, FuncType);
            elseif num>1                              %多于一行时，按线计算
                P= LinePotential(gridPoints, data, u,FuncType, E);
            end 
            
            F=repmat(firstLine, N,1);
           
    elseif tag==2
            % eval(firstLine{1}{1});                             %将第一行当作命令执行，给f赋值
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
    fwrite(fid_w, content, '*char');                    %写入新内容
    fclose(fid_w);
end