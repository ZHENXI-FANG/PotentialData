function [Values] = PointsPotential(gridPoints,resoucePoints, m, u, E, FuncType)
%UNTITLED2 此处显示有关此函数的摘要
%  gridPoints只有坐标列，无索引和其他
%  resourcePoints无索引
% 表头不做要求
%Values(i,j)表示场源点j在i处产生的势函数值

X=gridPoints;
[nX,p] = size(X);  %行、列
Y =resoucePoints(:,1:p);
Y=table2array(Y);
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

