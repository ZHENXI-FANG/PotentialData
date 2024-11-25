
function [gridPoints] = GetGridPoints(PointsData, LinesData,solution,D)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[limit] = GetDataLimit(PointsData, LinesData, D);

if D==3
    [X,Y,Z] = meshgrid(limit(1,1):solution(1,1):limit(2,1),limit(1,2):solution(1,2):limit(2,2),limit(1,3):solution(1,3):limit(2,3));
    gridPoints=[X(:), Y(:), Z(:)]; 
elseif D==2
    [X,Y] = meshgrid(limit(1,1):solution(1,1):limit(2,1),limit(1,2):solution(1,2):limit(2,2));
    gridPoints=[X(:), Y(:)]; 
end

end


function [Limit] = GetDataLimit(PointsData, LinesData, D)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    nP=length(PointsData);
    nL=length(LinesData);
    
    if D==3
        dataMin=zeros(nP+nL,3);
        dataMax=zeros(nP+nL,3);
        for i =1:length(PointsData)
            T=PointsData(i).data;
            XYZdata=[T.X,T.Y,T.Z];
            dataMax(i,:)=max(XYZdata,[],1); %取列的最值
            dataMin(i,:)=min(XYZdata,[],1);
        end
        n=length(PointsData);
        for i =1:length(LinesData)
            T=LinesData(i).data;
            XYZdata=[T.X,T.Y,T.Z];
            dataMax(n+i,:)=max(XYZdata,[],1);
            dataMin(n+i,:)=min(XYZdata,[],1);
        end
    elseif D==2
        dataMin=zeros(nP+nL,2);
        dataMax=zeros(nP+nL,2);
        for i =1:length(PointsData)
            T=PointsData(i).data;
            XYdata=[T.X,T.Y];
            dataMax(i,:)=max(XYdata,[],1); %取列的最值
            dataMin(i,:)=min(XYdata,[],1);
        end
  
        for i =1:length(LinesData)
            T=LinesData(i).data;
            XYdata=[T.X,T.Y];
            dataMax(nP+i,:)=max(XYdata,[],1);
            dataMin(nP+i,:)=min(XYdata,[],1);
        end
    end
    dataMax=max(dataMax,[],1);
    dataMin=min(dataMin,[],1);
    B=(dataMax-dataMin).*0.2;
    Limit = [dataMin-B;dataMax+B];      
end