function [E] =ParseMatrix(Estr)
% Estr 是一个包含多行以分号分隔的字符串
% 例如Estr = "1.0,2.0,0;0,5.0,0;0,1,9.0";
% 将其转化为矩阵形式  

    % 将每行按分号分隔
    rows = split(Estr, ';');
    % 初始化 E 数组
    E = [];
    % 遍历每行数据
    for i = 1:numel(rows)
        % 将每行按逗号分隔，并转换为浮点数
        values = strsplit(rows{i}, ',');
        row_values = cellfun(@str2double, values);
        % 添加当前行数据到 E 数组
        E = [E; row_values];
   end

% 将 E 转换为数组
E=double(E);

end

