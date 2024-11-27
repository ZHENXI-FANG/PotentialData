function [Value] = Line_sfunc(diff,m,E,u)   %diff=p-q
   
    %D=sum(diff,2);
    % A= pinv(E) * diff'; %这里是距离差与带宽矩阵相乘，下一步处理U/2,目前缺少这一环节，明天处理。
    % B=diff.*A';
    % temp=sum(B,2);   %行数相加
    % Value=m./power(temp,0.8);
   
   
    % E_pinv=pinv(E);
    % temp=diff*E_pinv;
    % dist = sqrt(sum(temp.^2, 2));
    % Value=m./(power(10,-12)+power(dist,0.8));
        % 计算折线对象的强度 m
    % 输入:
    % p - 待估点 (1x2 向量)，表示点 p 的坐标 (x_p, y_p)
    % polyline - N+1 x 2 的矩阵，表示折线上的节点， 每行是一个点的坐标 (x, y)
    % 输出:
    % m - 数据势场的强度
    


end