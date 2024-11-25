function [Limit,dataMax,dataMin] = GetDataLimit(fileData, D)
%计算所有数据坐标的最值
%输入数据fileData为两列，第二列为数据存储路径
    
    n=size(fileData,1);
    
    % if D==3
    %     dataMax=zeros(n,3);%初始化矩阵n*3
    %     dataMin=zeros(n,3);
    %     for i =1:n
    %         filename=fileData{i,2};
    %         T=readtable(filename);              %读取文件数据
    %         XYZdata=[T.X,T.Y,T.Z];
    %         dataMax(i,:)=max(XYZdata,[],1); %取列的最值
    %         dataMin(i,:)=min(XYZdata,[],1);
    %     end
    % 
    % elseif D==2
    %     dataMax=zeros(n,2);%初始化矩阵n*2
    %     dataMin=zeros(n,2);
    %     for i =1:n
    %         filename=fileData{i,2};
    %         T=readtable(filename);   %读取文件数据
    %         XYdata=[T.X,T.Y];
    %         dataMax(i,:)=max(XYdata,[],1); %取列的最值
    %         dataMin(i,:)=min(XYdata,[],1);
    %     end 
    % 
    % end   2024/11/25修改（7-29）

    parfor i = 1:n
    filename = fileData{i,2};
    T = readtable(filename);
        if D == 3
            XYZdata = [T.X, T.Y, T.Z];
            dataMax(i,:) = max(XYZdata,[],1);
            dataMin(i,:) = min(XYZdata,[],1);
        elseif D == 2
            XYdata = [T.X, T.Y];
            dataMax(i,:) = max(XYdata,[],1);
            dataMin(i,:) = min(XYdata,[],1);
        end
    end

    dataMax=max(dataMax,[],1);
    dataMin=min(dataMin,[],1);
    Limit=[dataMin;dataMax];

    % B=(dataMax-dataMin).*0.2;               %将边界外扩20%
    % Limit = [dataMin-B;dataMax+B];      
end

