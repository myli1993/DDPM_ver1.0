function Rbreak1=ehm_Flow_Rbreak(para,A,in_3hr_2020,Flow_acc,Flow_dir,river_length,river_round,river_width,river_break,DEM,Q_acc)
[q_sim,~,~,~]=ehm_river_gridded(A,in_3hr_2020,para,100,1);
[v1,v2]=ehm_river_accu_break(q_sim,Flow_acc,Flow_dir,river_length,river_round,river_width,river_break,DEM);
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            v{i,j}=0.5*(v1{i,j}+v2{i,j});
            height{i,j}=(Q_acc{i,j}/river_width(i,j))./v{i,j};
            for t=1:length(Q_acc{i,j})
                if height{i,j}(t,1)>river_break(i,j)*0.5
                    Rbreak{i,j}(t,1)=1;
                else
                    Rbreak{i,j}(t,1)=0;
                end
            end
            Rbreak1{i,j}=[in_3hr_2020{i,j}(:,1:3) Rbreak{i,j}(:,1)];
        end
    end
end
