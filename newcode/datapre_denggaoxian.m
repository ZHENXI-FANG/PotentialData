filename="E:\RZ_matlab\data\3Ddata\disixidiban";
T=readtable(filename);
j=1;k=1;n=1;
P=[T.Var3,T.Var4,T.Var5];
i=1;
while i<size(P,1) 
    if any(isnan(P(i+1,:)))     
        X=P(j:i,1);
        Y=P(j:i,2);
        Z=P(j:i,3);
        data=table(X,Y,Z);       
        m=size(data,1);
        n=n+2*m;
        filename = sprintf( 'E:\RZ_matlab\data\3Ddata\等高线\yizu\lines_yizu/lines_%d' , k);
        writetable(data,filename,'WriteRowNames',true);
        k=k+1;
        i=n;
        j=n;
    else 
        i=i+1;
        
    end
end