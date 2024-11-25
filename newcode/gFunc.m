function [Value] = gFunc(diff,m,E,u)
%高斯函数

    A= pinv(E) * diff';
    B=diff.*A';
    temp=sum(B,2);
    Value=m.*exp(-5*temp.^(u/2));

end