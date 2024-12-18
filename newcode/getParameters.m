function [m,q,t,ind] = getParameters(points, polyline)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
    

    [nP,D]=size(points);
    [n,d]=size(polyline);
    if D~=d
        errordlg('数据维度不一致','error');   %弹窗警告
        return
    end
    
    [dmin, q, t, ind] = MinDistance(points, polyline);
    
    Points(:,1,:)=points;
    Points=repmat(Points,1,n,1);
    Polyline(1,:,:) = polyline;
    Polyline=repmat(Polyline,nP,1,1);
    
    Distance = vecnorm(Points - Polyline, 2, 3);  % 计算点集每个点到折点的欧氏距离
    m=dmin.*sum(1./Distance,2); 

    % if m(find(isnan(m))) == n
    %     %点与折点重合的情况，Distance为0，m为NaN
    %     m=1;
    % end
    %---------------------m----------------------------

end



function [dmin, q, t, ind] = MinDistance(points, polyline)
    % 计算点集points中每个点到折线上所有点的最短距离和最短距离点

    [nP,D]=size(points);
    [n,d]=size(polyline);

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
    q=zeros(nP,D);
    for i=1:D
        q(:,i)=Q(ind+nP*(n-1)*(i-1));
    end

    %--------------------折线---------------------------------------------------
    % 计算每个点 P 到折线 (由多个线段组成) 的最短距离、最近投影点、投影比例位置和对应的线段索引
    % 输入:P - n x 2 的矩阵，每行是一个点 (x0, y0)
    % polyline - m x 2 的矩阵，表示折线上的点，每行表示一个折线上的点 (x, y)
    % 
    % n = size(points, 1);  % 点的数量
    % m = size(polyline, 1);  % 折线上的点的数量
    % dmin = zeros(n, 1);  % 初始化距离的结果向量
    % q = zeros(n, 2);  % 初始化最近投影点的矩阵
    % t = zeros(n, 1);  % 初始化投影比例的位置
    % ind = zeros(n, 1);  % 初始化投影点的索引
    % 
    % % 遍历每个点 points_i
    % for i = 1:n
    %     min_dist = inf;  % 初始化最小距离为无穷大
    %     closest_proj = NaN(1, 2);  % 存储最近的投影点
    %     best_t = NaN;  % 存储最好的投影比例
    %     best_ind = NaN;  % 存储最好的线段索引
    % 
    %     % 遍历每个线段
    %     for j = 1:m-1
    %         A = polyline(j, :);  % 当前线段的起点
    %         B = polyline(j+1, :);  % 当前线段的终点
    % 
    %         % 计算线段 AB 的向量
    %         AB = B - A;
    %         AB_mag_sq = dot(AB, AB);  % 计算 AB 向量的平方
    % 
    %         % 计算点 P_i 到线段 AB 的向量
    %         AP = points(i, :) - A;  % 计算 A 到 P_i 的向量
    % 
    %         % 计算投影系数 t
    %         t_val = dot(AP, AB) / AB_mag_sq;  % 计算 t
    % 
    %         % 判断投影点是否在线段内
    %         if t_val < 0
    %             % 投影点在 A 端点外，返回 P_i 到 A 的距离
    %             dist_val = norm(AP);
    %             proj = A;
    %             t_proj = 0;
    %             ind_proj = j;  % 对应线段的索引
    %         elseif t_val > 1
    %             % 投影点在 B 端点外，返回 P_i 到 B 的距离
    %             BP = points(i, :) - B;
    %             dist_val = norm(BP);
    %             proj = B;
    %             t_proj = 1;
    %             ind_proj = j + 1;  % 对应线段的索引
    %         else
    %             % 投影点在线段内，返回 P_i 到投影点的距离
    %             proj = A + t_val * AB;  % 计算投影点的坐标
    %             dist_val = norm(points(i, :) - proj);  % 计算 P_i 到投影点的距离
    %             t_proj = t_val;  % 投影比例
    %             ind_proj = j;  % 对应线段的索引
    %         end
    % 
    %         % 如果计算得到的距离更小，更新最短距离和投影点
    %         if dist_val < min_dist
    %             min_dist = dist_val;
    %             closest_proj = proj;
    %             best_t = t_proj;
    %             best_ind = ind_proj;
    %         end
    %     end
    % 
    %     % 存储结果
    %     dmin(i) = min_dist;  % 最短距离
    %     q(i, :) = closest_proj;  % 最近投影点
    %     t(i) = best_t;  % 投影比例
    %     ind(i) = best_ind;  % 最近投影点所在线段的索引
    % end
    %--------------------折线---------------------------------------------------
end
    