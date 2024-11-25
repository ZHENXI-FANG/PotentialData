path1="E:\ÈíÖø_matlab\data\yizu\yizu\lines_1";
path2 = "E:\ÈíÖø_matlab\data\test_resource_points.txt";
data1=readtable(path1);
data2=readtable(path2);
% data1=table2array(data1);
% data2=table2array(data2);


% for i=1:length(data1)
%     p=data1(i,:);    
%     [Potential,~]=pointsPotential(data2, 2, p, 3, 's');
% end
E=[1,0,0;0,1,0;0,0,1];
[Values] = PointsPotential(data1,data2, E, 2);

