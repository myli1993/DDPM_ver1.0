function [Rbreak_fig7,Rbreak_month,Rbreak_basin,Rbreak_main]=ehm_Flow_break_view(A,Rbreak,river_width,in_3hr_2020)
%%
break01=[];break02=[];
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            if river_width(i,j)>1 && river_width(i,j)<10 %Tributary
                break01=[break01 Rbreak{i,j}(:,4)];
            elseif river_width(i,j)>5 %Main
                break02=[break02 Rbreak{i,j}(:,4)];
            end
        end
    end
end
Rbreak01=[sum(break01,2) sum(break02,2)];
for t=1:length(Rbreak01)
   if Rbreak01(t,1)==0 && Rbreak01(t,2)==0
    Rbreak_fig7(t,4)=0;
   elseif Rbreak01(t,1)>0 && Rbreak01(t,2)==0
           Rbreak_fig7(t,4)=1;
   elseif Rbreak01(t,1)==0 && Rbreak01(t,2)>0
           Rbreak_fig7(t,4)=2;
   elseif Rbreak01(t,1)>0 && Rbreak01(t,2)>0
           Rbreak_fig7(t,4)=3;
   end
end
Rbreak_fig7(:,1:3)=in_3hr_2020{4,9}(:,1:3);
unique(Rbreak_fig7(:,4))
%% For time: 3hr to 1month
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1 
            year=unique(Rbreak{i,j}(:,1));
            for yy=1:length(year)-1
                for mm=1:12
                    index=find(Rbreak{i,j}(:,1)==year(yy) & Rbreak{i,j}(:,2)==mm);
                    Rbreak_month{i,j}((yy-1)*12+mm,1)=year(yy);
                    Rbreak_month{i,j}((yy-1)*12+mm,2)=mm;
                    Rbreak_month{i,j}((yy-1)*12+mm,3)=sum(Rbreak{i,j}(index,4));
                end
            end
        end
    end
end
%% Grid to basin
r1=[];r2=[];
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            r1=[r1 Rbreak_month{i,j}(:,3)];
        end
        if A(i,j)==1 && river_width(i,j)>5
            r2=[r2 Rbreak_month{i,j}(:,3)];
        end
    end
end
Rbreak_basin=[Rbreak_month{4,9}(:,1:2) sum(r1,2)];
Rbreak_main=[Rbreak_month{4,9}(:,1:2) sum(r2,2)];