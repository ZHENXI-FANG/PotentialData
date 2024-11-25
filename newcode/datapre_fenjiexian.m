
T=readtable("E:\RZ_matlab\data\3Ddata\分界线\xlsx\dem.xlsx");
T = removevars(T, ["FID","Shape","ID","x__","DataSource","Strat","StratNo"]);
T = removevars(T, "POINT_M");
T.Properties.VariableNames(2) = "X";
T.Properties.VariableNames(3) = "Y";
T.Properties.VariableNames(4) = "Z";
T.Properties.VariableNames(1) = "L_ID";

f=sum(T.Z)/size(T,1);

n=T{end,"L_ID"};
for i=1:n+1
    data=T(T.L_ID==i-1,["X","Y","Z"]);
    filename = sprintf('E:/RZ_matlab/data/3Ddata/分界线/底界/lines_%d', i);
    writetable(data,filename,'WriteRowNames',true);

end