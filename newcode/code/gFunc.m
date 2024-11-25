function [Value] = gFunc(diff,m,E,u)
%高斯函数
% diff=p-q，大小为n×D，n为待插点个数，D为维度；
% p为待插点集，n×D；q为场源点，1×D
% m为场源强度，E为带宽矩阵，u为距离指数

    A= pinv(E) * diff';
    B=diff.*A';
    temp=sum(B,2);
    Value=m.*exp(-5*temp.^(u/2));

end