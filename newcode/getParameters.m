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
    % m=dmin.*sum(1./Distance,2);  
    % m(find(isnan(m))) = n;  %点与折点重合的情况，Distance为0，m为NaN
    m=1;
end



function [dmin, q, t, ind] = MinDistance(points, polyline)
    % 计算点集points中每个点到折线上所有点的最短距离和最短距离点
    
    [nP,D]=size(points);
    [n,d]=size(polyline);
    % if D~=d
    %     return
    % end
    
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
end
    