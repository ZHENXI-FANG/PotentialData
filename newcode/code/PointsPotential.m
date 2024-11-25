function [Values] = PointsPotential(gridPoints,resoucePoints, m, u, E, FuncType)
    %UNTITLED2 此处显示有关此函数的摘要
    %  gridPoints 为待插点，大小n×D，n为待插点个数，D为维度；
    %  resourcePoints 为场源点矩阵
    % Values(i,j)表示场源点j在待插i处产生的势函数值
    
    % X = table2array(gridPoints);
    X=gridPoints;
    [nX,p] = size(X);
    Y =resoucePoints(:,1:p);
    [nY,~] = size(Y);
    Values=zeros(nX, nY);
    
    if FuncType=='s'    
        % 计算 (p-q) * pinv(E) * (p-q)' 部分
         for i = 1:nY
                diff = zeros(nX,p);
                diff = diff + (X - Y(i,:));
                dsq=sFunc(diff,m,E,u);
                Values(:,i) = dsq;
         end
         
    elseif FuncType=='g'
        for i = 1:nY
                diff = zeros(nX,p);
                diff = diff + (X - Y(i,:));
                dsq=gFunc(diff,m,E,u);
                Values(:,i) = dsq;
        end
    end

end

