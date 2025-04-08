function [m,q,t,ind] = getParameters(points, polyline)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
    
    [nP,D]=size(points);
    [n,d]=size(polyline);
    if D~=d
        errordlg('数据维度不一致','error');   %弹窗警告
        return
    end
    
    [dmin, q, t, ind] = MinDistance3D_HorizVertical(points, polyline);
    Points(:,1,:)=points;
    Points=repmat(Points,1,n,1);
    Polyline(1,:,:) = polyline;
    Polyline=repmat(Polyline,nP,1,1);
    
    % Distance = vecnorm(Points - Polyline, 2, 3);  % 计算点集每个点到折点的欧氏距离
    % m=dmin.*sum(1./Distance,2);
    m=5;

    % if m(find(isnan(m))) == n
    %     %点与折点重合的情况，Distance为0，m为NaN
    %     m=1;
    % end
    %---------------------m----------------------------

end


% function [dmin, q, t, ind] = MinDistance(points, polyline)
%     % 计算点集points中每个点到折线上所有点的最短距离和最短距离点
% 
%     [nP,D]=size(points);
%     [n,d]=size(polyline);
% 
%     %转换维度并扩展
%     Points(:,1,:)=points;
%     Points=repmat(Points,1,n-1,1);
%     seg_Start(1,:,:) = polyline(1:end-1, :);
%     seg_End (1,:,:)= polyline(2:end, :);
%     seg_Start=repmat(seg_Start,nP,1,1);
%     seg_End=repmat(seg_End,nP,1,1);
% 
%     % 计算点集与线段起点之间的向量
%     pa = Points - seg_Start ;  
%     seg = seg_End - seg_Start ;  % 计算线段的向量
%     T = dot(pa, seg, 3) ./ dot(seg, seg, 3);  % 计算点集到线段的最短距离位置比例
%     T(T < 0) = 0;  % 将小于0的位置比例设置为0
%     T(find(T > 1)) = 1;  % 将大于1的位置比例设置为1
%     Q = seg_Start + T.*seg;  % 计算点集每个点到线段的最短距离点
%     distance = vecnorm(Points - Q, 2, 3);  % 计算点集每个点到对应最短距离点的欧氏距离
%     [dmin, I ] = min(distance,[],2);
%     ind=sub2ind(size(Q), (1:size(Q,1))', I);
%     t=T(ind);
%     q=zeros(nP,D);
%     for i=1:D
%         q(:,i)=Q(ind+nP*(n-1)*(i-1));
%     end
% end




function [dmin, q, t, ind] = MinDistance2D(points, polyline)
% MinDistance2D 计算二维点集中每个点到二维折线的最短距离
%
% 输入：
%   points   - nP x 2 矩阵，每行表示一个二维点 [x, y]
%   polyline - n x 2 矩阵，表示二维折线的顶点序列
%
% 输出：
%   dmin     - nP x 1，每个点到折线的最短距离
%   q        - nP x 2，每个点对应的折线上最近点（投影点）
%   t        - nP x 1，每个点在对应线段上的投影参数（范围 [0,1]）
%   ind      - nP x 1，对应最小距离的线段索引

    [nP, D] = size(points);
    [n, d] = size(polyline);
    if D ~= 2 || d ~= 2
        error('输入的 points 和 polyline 必须为二维坐标。');
    end
    
    % 重塑 points 为 nP x 1 x 2 数组
    Points = reshape(points, [nP, 1, D]);
    Points = repmat(Points, [1, n-1, 1]);
    
    % 构造线段起点和终点
    seg_Start = polyline(1:end-1, :); % (n-1) x 2
    seg_End = polyline(2:end, :);       % (n-1) x 2
    seg_Start = reshape(seg_Start, [1, n-1, d]);
    seg_End = reshape(seg_End, [1, n-1, d]);
    seg_Start = repmat(seg_Start, [nP, 1, 1]);
    seg_End = repmat(seg_End, [nP, 1, 1]);
    
    % 计算从起点到每个点的向量差
    pa = Points - seg_Start;
    seg = seg_End - seg_Start;
    
    % 计算投影参数 T
    T = dot(pa, seg, 3) ./ dot(seg, seg, 3);
    T(T < 0) = 0;
    T(T > 1) = 1;
    
    % 计算投影点 Q
    T_expanded = repmat(T, [1, 1, d]);
    Q = seg_Start + T_expanded .* seg;
    
    % 计算欧氏距离
    distance = sqrt(sum((Points - Q).^2, 3));
    
    % 找到最小距离及对应索引
    [dmin, I] = min(distance, [], 2);
    ind = sub2ind(size(Q), (1:nP)', I);
    t = T(ind);
    
    % 提取对应二维最近点坐标
    q = zeros(nP, d);
    for i = 1:d
        q(:, i) = Q(ind + nP*(n-1)*(i-1));
    end
end


function [dmin, q, t, ind] = MinDistance3D_HorizVertical(points, polyline)
    % points: nP x 3 网格点坐标 [x,y,z]
    % polyline: n x 3 曲线坐标，其中所有 z 值相同（例如 z = z0）
    
    % 分离水平 (x,y) 和垂直 (z) 分量
    points_xy = points(:, 1:2);
    polyline_xy = polyline(:, 1:2);
    
    % 调用二维最短距离计算函数
    [dmin_xy, q_xy, t, ind] = MinDistance2D(points_xy, polyline_xy);
    
    % 曲线 z 值（假设所有点 z 均相同）
    z0 = polyline(1, 3);
    
    % 计算垂直距离
    d_vertical = abs(points(:, 3) - z0);
    
    % 合成全 3D 距离
    dmin = sqrt(dmin_xy.^2 + d_vertical.^2);
    
    % 构造全 3D 最近点坐标
    q = [q_xy, repmat(z0, size(points,1), 1)];
    
end




