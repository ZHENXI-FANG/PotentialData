f = uifigure;
t = uitree(f);
PointsNode = uitreenode(t,'Text','Points');
LinesNode = uitreenode(t,'Text','Lines');

filepath="E:\软著_matlab\data\yizu\属性值表.xlsx";
folderpath="E:\软著_matlab\data\yizu\yizu";
Data=readtable(filepath);
[~, folderName, ~] = fileparts(folderpath);
line_node = uitreenode(LinesNode, 'Text', folderName,'Tag','L','NodeData',Data, 'Icon', '');
files = dir(fullfile(folderpath, '*.txt'));  % 获取文件夹中的所有文件
for i = 1:length(files)
    filename = files(i).name;  % 获取文件名
    fileFullPath = fullfile(folderpath, filename);
    data = readtable(fileFullPath);   %读取文件
    new_node = uitreenode(line_node, 'Text', filename, 'Tag','l', 'Icon', '','NodeData', data);
end

fullpath = "E:\软著_matlab\data\test_resource_points.txt";
[~, name] = fileparts(fullpath);
data = readtable(fullpath);  % 读取文件数据
new_node = uitreenode(PointsNode, 'Text', name,'Tag','p','NodeData',data);

PointsData=struct();
LinesData=struct();
[PointsData,LinesData]=test(t,PointsData,LinesData);
PointsData(1)=[];
LinesData(1)=[];
limit = GetDataLimit(PointsData, LinesData);
D=3;
gridPoints = GetGridPoints(limit,D);
fieldValue=GetFieldValue(PointsData, LinesData, [1000,1000,5],2,D,'s','Add'); 


