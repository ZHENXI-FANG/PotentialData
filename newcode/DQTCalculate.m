function [d, q, t] = DQTCalculate(points, segmentStart, segmentEnd)
    % 计算点集points到线段上所有点的最短距离d及最短距离点q
    %参数为点集、线段两端点
    pa = points - segmentStart;  % 计算点集与线段起点之间的向量
    seg = repmat(segmentEnd - segmentStart, size(pa,1), 1);  % 计算线段的向量，扩展为与pa相同维度的矩阵
    t = dot(pa, seg, 2) ./ dot(seg, seg, 2);  % 计算点集到线段的最短距离位置比例
    t(t < 0) = 0;  % 将小于0的位置比例设置为0
    t(t > 1) = 1;  % 将大于1的位置比例设置为1
    q = segmentStart + t.*seg;  % 计算点集每个点到线段的最短距离点
    d = vecnorm(points - q, 2, 2);  % 计算点集每个点到对应最短距离点的欧氏距离
end
