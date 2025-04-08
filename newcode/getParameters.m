function [m,q,t,ind] = getParameters(points, polyline)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    
    [nP,D]=size(points);
    [n,d]=size(polyline);
    if D~=d
        errordlg('����ά�Ȳ�һ��','error');   %��������
        return
    end
    
    [dmin, q, t, ind] = MinDistance3D_HorizVertical(points, polyline);
    Points(:,1,:)=points;
    Points=repmat(Points,1,n,1);
    Polyline(1,:,:) = polyline;
    Polyline=repmat(Polyline,nP,1,1);
    
    % Distance = vecnorm(Points - Polyline, 2, 3);  % ����㼯ÿ���㵽�۵��ŷ�Ͼ���
    % m=dmin.*sum(1./Distance,2);
    m=5;

    % if m(find(isnan(m))) == n
    %     %�����۵��غϵ������DistanceΪ0��mΪNaN
    %     m=1;
    % end
    %---------------------m----------------------------

end


% function [dmin, q, t, ind] = MinDistance(points, polyline)
%     % ����㼯points��ÿ���㵽���������е����̾������̾����
% 
%     [nP,D]=size(points);
%     [n,d]=size(polyline);
% 
%     %ת��ά�Ȳ���չ
%     Points(:,1,:)=points;
%     Points=repmat(Points,1,n-1,1);
%     seg_Start(1,:,:) = polyline(1:end-1, :);
%     seg_End (1,:,:)= polyline(2:end, :);
%     seg_Start=repmat(seg_Start,nP,1,1);
%     seg_End=repmat(seg_End,nP,1,1);
% 
%     % ����㼯���߶����֮�������
%     pa = Points - seg_Start ;  
%     seg = seg_End - seg_Start ;  % �����߶ε�����
%     T = dot(pa, seg, 3) ./ dot(seg, seg, 3);  % ����㼯���߶ε���̾���λ�ñ���
%     T(T < 0) = 0;  % ��С��0��λ�ñ�������Ϊ0
%     T(find(T > 1)) = 1;  % ������1��λ�ñ�������Ϊ1
%     Q = seg_Start + T.*seg;  % ����㼯ÿ���㵽�߶ε���̾����
%     distance = vecnorm(Points - Q, 2, 3);  % ����㼯ÿ���㵽��Ӧ��̾�����ŷ�Ͼ���
%     [dmin, I ] = min(distance,[],2);
%     ind=sub2ind(size(Q), (1:size(Q,1))', I);
%     t=T(ind);
%     q=zeros(nP,D);
%     for i=1:D
%         q(:,i)=Q(ind+nP*(n-1)*(i-1));
%     end
% end




function [dmin, q, t, ind] = MinDistance2D(points, polyline)
% MinDistance2D �����ά�㼯��ÿ���㵽��ά���ߵ���̾���
%
% ���룺
%   points   - nP x 2 ����ÿ�б�ʾһ����ά�� [x, y]
%   polyline - n x 2 ���󣬱�ʾ��ά���ߵĶ�������
%
% �����
%   dmin     - nP x 1��ÿ���㵽���ߵ���̾���
%   q        - nP x 2��ÿ�����Ӧ������������㣨ͶӰ�㣩
%   t        - nP x 1��ÿ�����ڶ�Ӧ�߶��ϵ�ͶӰ��������Χ [0,1]��
%   ind      - nP x 1����Ӧ��С������߶�����

    [nP, D] = size(points);
    [n, d] = size(polyline);
    if D ~= 2 || d ~= 2
        error('����� points �� polyline ����Ϊ��ά���ꡣ');
    end
    
    % ���� points Ϊ nP x 1 x 2 ����
    Points = reshape(points, [nP, 1, D]);
    Points = repmat(Points, [1, n-1, 1]);
    
    % �����߶������յ�
    seg_Start = polyline(1:end-1, :); % (n-1) x 2
    seg_End = polyline(2:end, :);       % (n-1) x 2
    seg_Start = reshape(seg_Start, [1, n-1, d]);
    seg_End = reshape(seg_End, [1, n-1, d]);
    seg_Start = repmat(seg_Start, [nP, 1, 1]);
    seg_End = repmat(seg_End, [nP, 1, 1]);
    
    % �������㵽ÿ�����������
    pa = Points - seg_Start;
    seg = seg_End - seg_Start;
    
    % ����ͶӰ���� T
    T = dot(pa, seg, 3) ./ dot(seg, seg, 3);
    T(T < 0) = 0;
    T(T > 1) = 1;
    
    % ����ͶӰ�� Q
    T_expanded = repmat(T, [1, 1, d]);
    Q = seg_Start + T_expanded .* seg;
    
    % ����ŷ�Ͼ���
    distance = sqrt(sum((Points - Q).^2, 3));
    
    % �ҵ���С���뼰��Ӧ����
    [dmin, I] = min(distance, [], 2);
    ind = sub2ind(size(Q), (1:nP)', I);
    t = T(ind);
    
    % ��ȡ��Ӧ��ά���������
    q = zeros(nP, d);
    for i = 1:d
        q(:, i) = Q(ind + nP*(n-1)*(i-1));
    end
end


function [dmin, q, t, ind] = MinDistance3D_HorizVertical(points, polyline)
    % points: nP x 3 ��������� [x,y,z]
    % polyline: n x 3 �������꣬�������� z ֵ��ͬ������ z = z0��
    
    % ����ˮƽ (x,y) �ʹ�ֱ (z) ����
    points_xy = points(:, 1:2);
    polyline_xy = polyline(:, 1:2);
    
    % ���ö�ά��̾�����㺯��
    [dmin_xy, q_xy, t, ind] = MinDistance2D(points_xy, polyline_xy);
    
    % ���� z ֵ���������е� z ����ͬ��
    z0 = polyline(1, 3);
    
    % ���㴹ֱ����
    d_vertical = abs(points(:, 3) - z0);
    
    % �ϳ�ȫ 3D ����
    dmin = sqrt(dmin_xy.^2 + d_vertical.^2);
    
    % ����ȫ 3D ���������
    q = [q_xy, repmat(z0, size(points,1), 1)];
    
end




