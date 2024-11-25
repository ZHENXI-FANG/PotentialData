%批量加表头

% 定义文件路径和新的表头
folder = 'E:\KY\xhly\LayerLines'; % 文件夹路径
 
% 获取文件夹内所有文件
files = dir(fullfile(folder, '*.txt'));
files = {files.name};
 
for k = 1:length(files)
    filePath = fullfile(folder, files{k});
    fileData = readtable(filePath); % 读取数据
    fileData.Properties.VariableNames(1) = "X";
    fileData.Properties.VariableNames(2) = "Y";
    fileData.Properties.VariableNames(3) = "Z";

    writetable(fileData, filePath, 'WriteRowNames',true); %  写入数据

end