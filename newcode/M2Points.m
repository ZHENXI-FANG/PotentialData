function [Points] = M2Points(M)
%M为contour函数输出的顶点矩阵
%将M转化为x，y两列坐标
Points=[];
i=1;
while size(M,2)~=0
    m=M(2,1);
    Points(i:i+m-1,:)=M(:,2:m+1)';
    M(:,1:m+1)=[];
    i=i+m;
end

end