% 准备示例数据
filename = "D:\PotentialData\data\2Ddata\Points\Points_201.txt";
data=readtable(filename);
x=data.X;
y=data.Y;
z=data.F;
xi = linspace(-10, 12, 400);
yi = linspace(-10,12, 400);
zq=interp2(x,y,z,xi,yi,'cubic'); % 样条插值
% 可视化结果
figure;
mesh(xi, yi, zq);
colorbar;
title('Contour plot');

