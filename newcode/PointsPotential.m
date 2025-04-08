function [Values] = PointsPotential(gridPoints,resoucePoints, m, u, E, FuncType,num)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%  gridPointsֻ�������У�������������
%  resourcePoints������
% ��ͷ����Ҫ��
%Values(i,j)��ʾ��Դ��j��i���������ƺ���ֵ
    X=gridPoints;
    [nX,p] = size(X);  %�С���
    Y =resoucePoints(:,1:p);
    % Y=table2array(Y);
    [nY,~] = size(Y);
    Values=zeros(nX, nY);
    if FuncType=='s'    
        % ���� (p-q) * pinv(E) * (p-q)' ����
         for i = 1:nY
                diff = zeros(nX,p);
                diff = diff + (X - Y(i,:));
                dsq=sFunc(diff,m,E,u,num);
                Values(:,i) = dsq;
         end
    elseif FuncType=='g'
         for i = 1:nY
                diff = zeros(nX,p);
                diff = diff + (X - Y(i,:));
                dsq=gFunc(diff,m,E,u,num);
                Values(:,i) = dsq;
         end
    end
end

