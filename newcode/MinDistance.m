function [dmin, q, t, ind] = MinDistance(points, polyline)
    % ����㼯points��ÿ���㵽���������е����̾������̾����
    
    [nP,D]=size(points);
    [n,d]=size(polyline);
    if D~=d
        return
    end

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
    q=zeros(nP,d);
    for i=1:d
        q(:,i)=Q(ind+nP*(n-1)*(i-1));
    end


    % %�´��룬����㵽�߶ε��������
    % Line_start=polyline(1,:)
    % Line_end=polyline(end,:)
    % % ����ÿ���� P_i���߶� Line �ľ���(�����߶�ΪAB)
    % % ����:
    % % Points - n x 2 �ľ���ÿ����һ���� (x0, y0)
    % % Line_start - �߶ζ˵�  (x1, y1)
    % % Line_end - �߶ζ˵� (x2, y2)
    % 
    % n = size(Points, 1);  % Ponits ����������ʾ�������
    % dist = zeros(n, 1);  % ��ʼ������Ľ������
    % 
    % % �����߶�����Line
    % Line = Line_end-Line_start;
    % 
    % for i = 1:n
    %     % ����ÿ���� P_i ���߶� AB �ľ���
    %     Line_start_Points = Points(i, :) - Line_start;  % ���� A �� P_i ������
    %     Line_mag = norm(Line);  % ���� AB ������ģ��
    % 
    %     % ����� P_i �� Line �����ϵ�ͶӰϵ�� t
    %     t = dot(Line_start_Points,Line) / Line_mag^2;
    % 
    %     % �ж�ͶӰ���Ƿ����߶���
    %     if t < 0
    %         % ͶӰ���� A �˵��⣬���� P_i �� A �ľ���
    %         dist(i) = norm( Line_start_Points);
    %     elseif t > 1
    %         % ͶӰ���� B �˵��⣬���� P_i �� B �ľ���
    %         Line_end_Points = Points(i, :) -Line_end;
    %         dist(i) = norm( Line_end_Points);
    %     else
    %         % ͶӰ�����߶��ڣ����� P_i ��ͶӰ��ľ���
    %         proj = Line_start+ t * Line;  % ����ͶӰ�������
    %         dist(i) = norm(Points(i, :) - proj);  % ���� P_i ��ͶӰ��ľ���
    %     end
    % end
end
    
    
    
    
    
    