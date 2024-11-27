function [dmin, q, t, ind] = MinDistance(points, polyline)
    % 计算点集points中每个点到折线上所有点的最短距离和最短距离点
    
    [nP,D]=size(points);
    [n,d]=size(polyline);
    if D~=d
        return
    end

    %转换维度并扩展
    Points(:,1,:)=points;
    Points=repmat(Points,1,n-1,1);

    seg_Start(1,:,:) = polyline(1:end-1, :);
    seg_End (1,:,:)= polyline(2:end, :);
    seg_Start=repmat(seg_Start,nP,1,1);
    seg_End=repmat(seg_End,nP,1,1);

    % 计算点集与线段起点之间的向量
    pa = Points - seg_Start ;  
    seg = seg_End - seg_Start ;  % 计算线段的向量
    T = dot(pa, seg, 3) ./ dot(seg, seg, 3);  % 计算点集到线段的最短距离位置比例
    T(T < 0) = 0;  % 将小于0的位置比例设置为0
    T(find(T > 1)) = 1;  % 将大于1的位置比例设置为1

    Q = seg_Start + T.*seg;  % 计算点集每个点到线段的最短距离点
    distance = vecnorm(Points - Q, 2, 3);  % 计算点集每个点到对应最短距离点的欧氏距离
    [dmin, I ] = min(distance,[],2);
    ind=sub2ind(size(Q), (1:size(Q,1))', I);
    t=T(ind);
    q=zeros(nP,d);
    for i=1:d
        q(:,i)=Q(ind+nP*(n-1)*(i-1));
    end


    % %新代码，计算点到线段的最近距离
    % Line_start=polyline(1,:)
    % Line_end=polyline(end,:)
    % % 计算每个点 P_i到线段 Line 的距离(假设线段为AB)
    % % 输入:
    % % Points - n x 2 的矩阵，每行是一个点 (x0, y0)
    % % Line_start - 线段端点  (x1, y1)
    % % Line_end - 线段端点 (x2, y2)
    % 
    % n = size(Points, 1);  % Ponits 的行数，表示点的数量
    % dist = zeros(n, 1);  % 初始化距离的结果向量
    % 
    % % 计算线段向量Line
    % Line = Line_end-Line_start;
    % 
    % for i = 1:n
    %     % 计算每个点 P_i 到线段 AB 的距离
    %     Line_start_Points = Points(i, :) - Line_start;  % 计算 A 到 P_i 的向量
    %     Line_mag = norm(Line);  % 计算 AB 向量的模长
    % 
    %     % 计算点 P_i 在 Line 向量上的投影系数 t
    %     t = dot(Line_start_Points,Line) / Line_mag^2;
    % 
    %     % 判断投影点是否在线段内
    %     if t < 0
    %         % 投影点在 A 端点外，返回 P_i 到 A 的距离
    %         dist(i) = norm( Line_start_Points);
    %     elseif t > 1
    %         % 投影点在 B 端点外，返回 P_i 到 B 的距离
    %         Line_end_Points = Points(i, :) -Line_end;
    %         dist(i) = norm( Line_end_Points);
    %     else
    %         % 投影点在线段内，返回 P_i 到投影点的距离
    %         proj = Line_start+ t * Line;  % 计算投影点的坐标
    %         dist(i) = norm(Points(i, :) - proj);  % 计算 P_i 到投影点的距离
    %     end
    % end
end
    
    
    
    
    
    