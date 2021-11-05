function [input_1dy,output_1dy,input_3hr]=ehm_Evap_prepare()
addpath('D:\文章\水文模型\m');
%% Load 1dy
load('D:\文章\水文模型\data\1.3regroup\shape.mat')
element_name={'prec','temp','lrad','srad','shum','wind','pres'};
for l=1:max(size(element_name))
    dataread=load(strcat('D:\文章\水文模型\data\1.3regroup\1dy\',element_name{l},'.mat'));
    eval([element_name{l},'=','dataread.data2',';']);
end
element_name={'E','Eb','Ei','Ep','Es','Et','Ew','SMroot','SMsurf','S'};
for l=1:max(size(element_name))
    dataread=load(strcat('D:\文章\水文模型\data\1.3regroup\',element_name{l},'.mat'));
    eval([element_name{l},'=','dataread.data2',';']);
end
soil=ehm_soilread(A,t,t_daily,1);%1:dy;2:3hr;
load('D:\文章\水文模型\data\1.1cut\veg\veg5.mat','veg01');
%% Merge 1dy
name_input={'prec','temp','lrad','srad','shum','wind','pres','SMroot','SMsurf'};
name_output={'E','Eb','Ei','Ep','Es','Et','Ew'};
soilpara=8;
vegpara=9;
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            for k=1:max(size(name_input))
                if k>7
                    eval(['input_1dy{i,j}(:,k)','=',name_input{k},'{i,j}(:,1);']);
                else
                    eval(['input_1dy{i,j}(:,k)','=',name_input{k},'{i,j}(end-14244:end,1);']);
                end
            end
            input_1dy{i,j}(:,max(size(name_input))+1:max(size(name_input))+soilpara)=soil{i,j}(:,1:soilpara);
            input_1dy{i,j}(:,max(size(name_input))+soilpara+1:max(size(name_input))+soilpara+vegpara)=veg01{i,j}(:,1:vegpara);
            for k=1:max(size(name_output))
                eval(['output_1dy{i,j}(:,k)','=',name_output{k},'{i,j}(:,1);']);
            end
        end
    end
end
%% Load 3hr
element_name={'prec','temp','lrad','srad','shum','wind','pres'};
for l=1:max(size(element_name))
    dataread=load(strcat('D:\文章\水文模型\data\1.3regroup\3hr\',element_name{l},'.mat'));
    eval([element_name{l},'=','dataread.data2',';']);
end
soil=ehm_soilread(A,t,t_daily,2);%1:dy;2:3hr;
veg=ehm_vegdyto3hr(A,t,t_daily,veg01);
%% Merge 3hr
name_input={'prec','temp','lrad','srad','shum','wind','pres','SMroot','SMsurf'};
soilpara=8;
vegpara=9;
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            for k=1:max(size(name_input))
                if k>7
                    eval([name_input{k},'_3hr{i,j}=ehm_dy2hr(',name_input{k},'{i,j},24,3);']);
                    eval(['input_3hr{i,j}(:,k)','=',name_input{k},'_3hr{i,j}(:,1);']);
                else
                    eval(['input_3hr{i,j}(:,k)','=',name_input{k},'{i,j}(end-113959:end,1);']);
                end
            end
            input_3hr{i,j}(:,max(size(name_input))+1:max(size(name_input))+soilpara)=soil{i,j}(:,1:soilpara);
            input_3hr{i,j}(:,max(size(name_input))+soilpara+1:max(size(name_input))+soilpara+vegpara)=veg{i,j}(:,1:vegpara);
        end
    end
end





