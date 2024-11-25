clear
data=readtable('E:\RZ_matlab\data\3Ddata\Boundary.txt');
X=data.X;Y=data.Y;
filename="E:\RZ_matlab\data\3Ddata\test.txt";
% 设置阈值
threshold = 13; % 阈值

% 打开文件
fileID = fopen(filename, 'r'); % 替换为您的文件名

% 读取文件内容并提取大于阈值的行
lines = {};
tline = fgetl(fileID);
while ischar(tline)
    if numel(tline) > threshold
        lines{end+1} = tline;
    end
    tline = fgetl(fileID);
end

% 关闭文件
fclose(fileID);

% 将提取出的行写入新的文件
newFileID = fopen("E:\RZ_matlab\data\3Ddata\demtest.txt", 'w'); % 替换为您的新文件名
for i = 1:length(lines)
    fprintf(newFileID, '%s\n', lines{i});
end

