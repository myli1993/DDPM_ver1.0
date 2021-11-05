function [snow_Mdl,waterjudge,output_1dy_formodel]=ehm_Evap_judge(input_1dy,output_1dy,A)
% load('F:\文章\水文模型\data\2.1evap\eva_prepare.mat');
% input_element={'prec','temp','lrad','srad','shum','wind','pres','SMroot','SMsurf','BD','SAND','SILT','CLAY','VMC1','VMC2','VMC3','OC',...
%     'FVC','NPP','LAI','BSA_VIS','WSA_VIS','BSA_NIR','WSA_NIR','BSA_SW','WSA_SW'};
% output_element={'E','Eb','Ei','Ep','Es','Et','Ew'};
output_1dy_formodel=output_1dy;
waterjudge=zeros(size(A,1),size(A,2));
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            if sum(output_1dy{i,j}(:,7))>0
                waterjudge(i,j)=1;
            end
%             output_1dy_formodel{i,j}(:,2)=output_1dy{i,j}(:,2)./(1-input_1dy{i,j}(:,18)/100);
%             output_1dy_formodel{i,j}(:,3)=output_1dy{i,j}(:,3)./(input_1dy{i,j}(:,18)/100);
%             output_1dy_formodel{i,j}(:,6)=output_1dy{i,j}(:,6)./(input_1dy{i,j}(:,18)/100);
            snow_in{i,j}=[input_1dy{i,j}(:,2) input_1dy{i,j}(:,21:26)];
            snow_out01=output_1dy{i,j}(:,5);
            snow_out{i,j}(snow_out01>0,1)=1;
            snow_out{i,j}(snow_out01==0,1)=-1;
            snow_Mdl{i,j}=fitcnb(snow_in{i,j},snow_out{i,j},'CrossVal','on');
%             [label,Posterior,Cost] = predict(Mdl,X)
        end
    end
end

%%
snow=[snow_in{13,19} snow_out{13,19}];
snow(snow(:,8)==0,8)=1;
snow1(:,1)=snow(:,1)-273.15;
snow1(:,2)=mean(snow(:,2:3),2);
snow1(:,3)=mean(snow(:,4:5),2);
snow1(:,4)=mean(snow(:,6:7),2);
snow1(:,5)=snow(:,8);
for i=1:length(snow1(:,1))
    if snow1(i,1)<-50 || snow1(i,1)>50
        snow1(i,1)=snow1(i-1,1);
    end
end
snow01=[snow1(:,1) snow1(:,5)];
ai=0;bi=0;
for i=1:length(snow1(:,1))/8
    snow02(i,:)=snow1((i-1)*8+1,1:end);
    if snow02(i,end)==-1
        a=snow02(i,1:end-1);
        ai=ai+1;
        snow03(ai,:)=a;
    else
        b=snow02(i,1:end-1);
        bi=bi+1;
        snow04(bi,:)=b;
    end
end


