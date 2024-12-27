function [Value] = gFunc(diff,m,E,u)
%高斯函数

    % A= pinv(E) * diff';
    % B=diff.*A';
    % temp=sum(B,2);
    % Value=m./exp(power(temp,0.8));

    % table_m=table(m);
    % filename4='D:\PotentialData\data\2Dtest\1218test\m.xlsx';
    % writetable(table_m,filename4);
    table_E=table(E);
    filename5='D:\PotentialData\data\2Dtest\1224test\E.xlsx';
    writetable(table_E,filename5);

    
    D=size(diff,1);
    Value=zeros(D,1);
    for i=1:D
        dimn=diff(i,:);
        Cell_E=E{i};
        A=pinv(Cell_E)*dimn';
        B=dimn.*A';
        temp=sum(B,2);
        % M=m(i,:);
        Value_i=m/exp(power(temp,0.7));
        Value(i,1)=Value_i;
       
    end

end


 