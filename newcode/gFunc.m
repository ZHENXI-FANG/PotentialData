function [Value] = gFunc(diff,m,E,u,num)

    if num==1  %点
        D=size(diff,2);
        if D==2
            E=[1,0;0,1];
        elseif D==3
            E=[1,0,0;0,1,0;0,0,1];
        end
        A= pinv(E) * diff';
        B=diff.*A';
        temp=sum(B,2);
        Value=m./exp(power(temp,1));
    elseif num>1   %线
        D=size(diff,1);
        Value=zeros(D,1);
        for i=1:D
            dimn=diff(i,:);
            Cell_E=E{i};
            A=dimn*pinv(Cell_E);
            temp=A*dimn';
            Value_i=m/exp(power(temp,0.1));
            Value(i,1)=Value_i;
        end
    end
end


 