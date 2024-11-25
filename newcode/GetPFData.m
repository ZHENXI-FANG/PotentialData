function [P, F] = GetPFData(gridPoints, u, FuncType, PointsData, LinesData)
%得到包括势函数值和对应属性值两列的数据
% gridPoints为待插值点；
% PointsData为结构数据，包括name，data（坐标，F），E；
% LinesData为结构数据，包括name，data（坐标），E, Fdata（linesName,F）
        P=[];     
        F=[];
        N=size(gridPoints,1);
        nL=length(LinesData);
        nP=0;
        fig=waitbar(0,'开始计算');
        for i =1:length(PointsData)
            T= PointsData(i).data;   
            n=size(T,1);
            nP=nP+n;
            f=T.F;
            E = PointsData(i).E;
            m=1;
            T=table2array(T);
            points_Potential = PointsPotential(gridPoints,T, m, u, E, FuncType);
            P=[P,points_Potential]; %水平拼接
            F=[F,repmat(f',N,1)]; 
            waitbar(i/length(PointsData),fig,'点计算中...')
        end
        
        L_P=zeros(N,nL);
        L_F=zeros(N,nL);
       for i=1:nL
            name=LinesData(i).name;
            Data=LinesData(i).Fdata;
            linesName=Data.linesName;
            ind=find(ismember(linesName,name)) ;              
            f=Data(ind,:).F; 
            data=LinesData(i).data;
            [~,n]=size(data);
            if n==2||n==3         
                E = LinesData(i).E;
                num=size(data,1);
                if num==1
                    data=table2array(data);
                    L_Potential = PointsPotential(gridPoints,data, 1, u, E, FuncType);
                elseif num>1
                    L_Potential = LinePotential(gridPoints, data, u,FuncType, E);
                end  
                
            elseif n==5||n==6                                                  
                L_Potential =LinePotential(gridPoints, data, u, E);    
                
            end            
            L_P(:,i)=L_Potential; 
            f=repmat(f,N,1);
            L_F(:,i)=f;
            waitbar(i/nL,fig,'线计算中...')
        end
        P=[P,L_P];                     
        F=[F,L_F];
        waitbar(1,fig,'计算完毕');
        close(fig);
end
