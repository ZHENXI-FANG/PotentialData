function [Eq] = EqCalculate(t, Ea, Eb, Eab, Eba)
%Éú³É´ø¿í¾ØÕóEq

    W=[Ea, Eab; Eba, Eb];
    [m,n] = size(W);
    E1 = zeros(n/2 , m/2);
    E2 = zeros(n/2 , m/2);
    Number_t=size(t,1);
    Eq=cell(Number_t,1);
    for j=1:Number_t
        q=t(j,1);
        for i=1:n/2
            E1(i,i) = 1-q;
            E2(i,i) = q;
        end
        E=[E1,E2];
        EQ=E* W* E.';
        Eq{j}=EQ;
    end
                
end