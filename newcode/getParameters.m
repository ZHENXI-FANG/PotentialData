function [m,q,t,ind] = getParameters(points, polyline)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    

    [nP,D]=size(points);
    [n,d]=size(polyline);
    if D~=d
        errordlg('����ά�Ȳ�һ��','error');   %��������
        return
    end
    
    [dmin, q, t, ind] = MinDistance(points, polyline);
    
    Points(:,1,:)=points;
    Points=repmat(Points,1,n,1);
    Polyline(1,:,:) = polyline;
    Polyline=repmat(Polyline,nP,1,1);
    
    Distance = vecnorm(Points - Polyline, 2, 3);  % ����㼯ÿ���㵽�۵��ŷ�Ͼ���
    m=dmin.*sum(1./Distance,2);  
    % if m(find(isnan(m))) == n
    %     %�����۵��غϵ������DistanceΪ0��mΪNaN
    %     m=1;
    % end
    %---------------------m----------------------------

end



function [dmin, q, t, ind] = MinDistance(points, polyline)
    % ����㼯points��ÿ���㵽���������е����̾������̾����
    
    [nP,D]=size(points);
    [n,d]=size(polyline);

    %ת��ά�Ȳ���չ
    Points(:,1,:)=points;
    Points=repmat(Points,1,n-1,1);

    seg_Start(1,:,:) = polyline(1:end-1, :);
    seg_End (1,:,:)= polyline(2:end, :);
    seg_Start=repmat(seg_Start,nP,1,1);
    seg_End=repmat(seg_End,nP,1,1);

    % ����㼯���߶����֮�������
    pa = Points - seg_Start ;  
    seg = seg_End - seg_Start ;  % �����߶ε�����
    T = dot(pa, seg, 3) ./ dot(seg, seg, 3);  % ����㼯���߶ε���̾���λ�ñ���
    T(T < 0) = 0;  % ��С��0��λ�ñ�������Ϊ0
    T(find(T > 1)) = 1;  % ������1��λ�ñ�������Ϊ1

    Q = seg_Start + T.*seg;  % ����㼯ÿ���㵽�߶ε���̾����
    distance = vecnorm(Points - Q, 2, 3);  % ����㼯ÿ���㵽��Ӧ��̾�����ŷ�Ͼ���
    [dmin, I ] = min(distance,[],2);
    ind=sub2ind(size(Q), (1:size(Q,1))', I);
    t=T(ind);
    q=zeros(nP,D);
    for i=1:D
        q(:,i)=Q(ind+nP*(n-1)*(i-1));
    end

    %--------------------����---------------------------------------------------
    % ����ÿ���� P ������ (�ɶ���߶����) ����̾��롢���ͶӰ�㡢ͶӰ����λ�úͶ�Ӧ���߶�����
    % ����:P - n x 2 �ľ���ÿ����һ���� (x0, y0)
    % polyline - m x 2 �ľ��󣬱�ʾ�����ϵĵ㣬ÿ�б�ʾһ�������ϵĵ� (x, y)
    
    % n = size(points, 1);  % �������
    % m = size(polyline, 1);  % �����ϵĵ������
    % dmin = zeros(n, 1);  % ��ʼ������Ľ������
    % q = zeros(n, 2);  % ��ʼ�����ͶӰ��ľ���
    % t = zeros(n, 1);  % ��ʼ��ͶӰ������λ��
    % ind = zeros(n, 1);  % ��ʼ��ͶӰ�������
    % 
    % % ����ÿ���� points_i
    % for i = 1:n
    %     min_dist = inf;  % ��ʼ����С����Ϊ�����
    %     closest_proj = NaN(1, 2);  % �洢�����ͶӰ��
    %     best_t = NaN;  % �洢��õ�ͶӰ����
    %     best_ind = NaN;  % �洢��õ��߶�����
    % 
    %     % ����ÿ���߶�
    %     for j = 1:m-1
    %         A = polyline(j, :);  % ��ǰ�߶ε����
    %         B = polyline(j+1, :);  % ��ǰ�߶ε��յ�
    % 
    %         % �����߶� AB ������
    %         AB = B - A;
    %         AB_mag_sq = dot(AB, AB);  % ���� AB ������ƽ��
    % 
    %         % ����� P_i ���߶� AB ������
    %         AP = points(i, :) - A;  % ���� A �� P_i ������
    % 
    %         % ����ͶӰϵ�� t
    %         t_val = dot(AP, AB) / AB_mag_sq;  % ���� t
    % 
    %         % �ж�ͶӰ���Ƿ����߶���
    %         if t_val < 0
    %             % ͶӰ���� A �˵��⣬���� P_i �� A �ľ���
    %             dist_val = norm(AP);
    %             proj = A;
    %             t_proj = 0;
    %             ind_proj = j;  % ��Ӧ�߶ε�����
    %         elseif t_val > 1
    %             % ͶӰ���� B �˵��⣬���� P_i �� B �ľ���
    %             BP = points(i, :) - B;
    %             dist_val = norm(BP);
    %             proj = B;
    %             t_proj = 1;
    %             ind_proj = j + 1;  % ��Ӧ�߶ε�����
    %         else
    %             % ͶӰ�����߶��ڣ����� P_i ��ͶӰ��ľ���
    %             proj = A + t_val * AB;  % ����ͶӰ�������
    %             dist_val = norm(points(i, :) - proj);  % ���� P_i ��ͶӰ��ľ���
    %             t_proj = t_val;  % ͶӰ����
    %             ind_proj = j;  % ��Ӧ�߶ε�����
    %         end
    % 
    %         % �������õ��ľ����С��������̾����ͶӰ��
    %         if dist_val < min_dist
    %             min_dist = dist_val;
    %             closest_proj = proj;
    %             best_t = t_proj;
    %             best_ind = ind_proj;
    %         end
    %     end
    % 
    %     % �洢���
    %     dmin(i) = min_dist;  % ��̾���
    %     q(i, :) = closest_proj;  % ���ͶӰ��
    %     t(i) = best_t;  % ͶӰ����
    %     ind(i) = best_ind;  % ���ͶӰ�������߶ε�����
    % end
    %--------------------����---------------------------------------------------
end
    