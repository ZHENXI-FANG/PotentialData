function [Potential] = LinePotential(points, polyline, u,FuncType, E)
%计算一条线poline在p出产生的势函数值
%   此处显示详细说明    
    [R,D]=size(points);
    n=size(polyline,2);  %返回polyline列数
    if n<4
       % polyline=table2array(polylinedata);      
       [m,q,t,~]= getParameters(points, polyline);

        % FF=size(t,1);    
        % figure;
        % scatter(1:FF,t,'filled');
        % hold on;
        % [max_value,max_idx]=max(t);
        % [min_value,min_idx]=min(t);
        % scatter(max_idx,max_value,100,'red','filled');
        % scatter(min_idx,min_value,100,'blue','filled');
        % text(max_idx, max_value, ['  Max: ', num2str(max_value)], 'Color', 'r', 'VerticalAlignment', 'bottom');
        % text(min_idx, min_value, ['  Min: ', num2str(min_value)], 'Color', 'b', 'VerticalAlignment', 'top');
        % title('Value of Potential');
        % xlabel('Index');
        % ylabel('Value');
        % legend('Data', 'Max Value', 'Min Value');
        % hold off;

       if D==2
           Ea=[50,0;0,50];
           Eb=[50,0;0,50];
           Eab=[30,0;0,30];
           Eba=[30,0;0,30];
           E=EqCalculate(t,Ea,Eb,Eab,Eba);

       % elseif D==3
       %     E=;
       end

       if FuncType=='s'    
           diff=points-q;
           [Potential]= sFunc(diff,m,E,u);
       elseif FuncType=='g'    
           diff=points-q;
           [Potential]= gFunc(diff,m,E,u);
       end
                
    elseif n>=4
        if D==2
            polyline=polylinedata(:,1:2);
        elseif D==3
            polyline=polylinedata(:,1:3);
        end
        polyline=table2array(polyline);
        [m,q,t,ind]= getParameters(points, polyline); 
        diff=points-q;
        i=ceil(ind./R);
        Eastr=cell2mat(polylinedata(i,:).E);   
        Ebstr=cell2mat(polylinedata(i+1,:).E); 
        Eabstr=cell2mat(polylinedata(i,:).Eab);
        Ebastr=cell2mat(polylinedata(i,:).Eba);   
        Ea=cell(R,1);
        Eb=cell(R,1);
        Eab=cell(R,1);
        Eba=cell(R,1);
        Eq=cell(R,1);
        Potential=zeros(R,1);
        for j=1:R            %改并行            
            Ea{j}=ParseMatrix(Eastr(j,:)); 
            Eb{j}=ParseMatrix(Ebstr(j,:));
            Eab{j}=ParseMatrix(Eabstr(j,:));
            Eba{j}=ParseMatrix(Ebastr(j,:));      
            Eq{j}=EqCalculate(t(j), Ea{j}, Eb{j}, Eab{j}, Eba{j});         
            if FuncType=='s'    
                p= sFunc(diff(j,:),m(j),Eq{j},u);
            elseif FuncType=='g'
                p=gFunc(diff(j,:),m(j),Eq{j},u);
            end
            Potential(j)=p;
        end
    end
end