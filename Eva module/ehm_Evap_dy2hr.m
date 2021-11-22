function [output_3hr,output_3hrto1dy,output_1dy_total]=ehm_Evap_dy2hr(pred_Evap,input_3hr,A,net_snowjudge,waterjudge)
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            output_3hr{i,j}(:,2)=pred_Evap{i,j}(:,2).*(1-input_3hr{i,j}(:,18)/100);
            output_3hr{i,j}(:,3)=pred_Evap{i,j}(:,3).*(input_3hr{i,j}(:,18)/100);
            output_3hr{i,j}(:,6)=pred_Evap{i,j}(:,6).*(input_3hr{i,j}(:,18)/100);
            if waterjudge(i,j)==0
                output_3hr{i,j}(:,7)=zeros(size(output_3hr{i,j}(:,7),1),1);
            end
            snow_in{i,j}=[input_3hr{i,j}(:,2) input_3hr{i,j}(:,21:26)];
            [snow_label{i,j},~,~]=predict(net_snowjudge{i,j},snow_in{i,j});
            output_3hr{i,j}(snow_label{i,j}==-1,5)=0;
            output_3hr{i,j}(snow_label{i,j}==1,2)=0;
            output_3hr{i,j}(snow_label{i,j}==1,3)=0;
            output_3hr{i,j}(snow_label{i,j}==1,6)=0;
            output_3hr_total{i,j}=sum(output_3hr{i,j}(:,2:end));
            output_3hrto1dy{i,j}=ehm_hr2dy(output_3hr{i,j},3,24);
            output_1dy_total{i,j}=ehm_hr2dy(output_3hr_total{i,j},3,24);
        end
    end
end
%%
