%% ----- Ew_1dy ----- %%
clc;clear;
addpath('F:\文章\水文模型\m');
load('F:\文章\水文模型\data\1.3regroup\shape.mat')
element_Ew={'pres','wind','temp'};
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\1dy\',element_Ew{1},'.mat'),'data2');
pres=dataread.data2;
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\1dy\',element_Ew{2},'.mat'),'data2');
wind=dataread.data2;
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\1dy\',element_Ew{3},'.mat'),'data2');
temp=dataread.data2;
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\Ew.mat'),'data2');
Ew_val=dataread.data2;
a=8.10765;b=1750.286;c=235;
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            if sum(Ew_val{i,j})>0
                T{i,j}=temp{i,j}-273.15;%(temp{i,j}-32).*5/9;
                Pm{i,j}=exp(a-b./(T{i,j}+c))*133.32236842105*1000;
                Ew{i,j}=52.*(Pm{i,j}-pres{i,j}).*(1+0.135*wind{i,j})/10000000000;
            else
                Ew{i,j}=zeros(14245,1);
            end
        else
            Ew{i,j}=[];
        end
        if A(i,j)==1 && sum(Ew_val{i,j})>0
            A_water(i,j)=1;
            r_sq(i,j)=min(min(corrcoef(Ew{i,j}(end-14244:end,1),Ew_val{i,j}(:,1))))^.2;
            Nash(i,j)=NSE(Ew{i,j}(end-14244:end,1),Ew_val{i,j}(:,1));
            mae(i,j)=mean(abs(Ew{i,j}(end-14244:end,1)-Ew_val{i,j}(:,1)));
        end
    end
end
save('F:\文章\水文模型\data\2.1evap\Ew\Ew_1dy.mat','Ew');

%% ----- Ew_3hr ----- %%
clc;clear;
addpath('F:\文章\水文模型\m');
load('F:\文章\水文模型\data\1.3regroup\shape.mat')
element_Ew={'pres','wind','temp'};
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\3hr\',element_Ew{1},'.mat'),'data2');
pres=dataread.data2;
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\3hr\',element_Ew{2},'.mat'),'data2');
wind=dataread.data2;
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\3hr\',element_Ew{3},'.mat'),'data2');
temp=dataread.data2;
dataread=load(strcat('F:\文章\水文模型\data\1.3regroup\Ew.mat'),'data2');
Ew_val=dataread.data2;
a=8.10765;b=1750.286;c=235;
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            if sum(Ew_val{i,j})>0
                T{i,j}=temp{i,j}-273.15;%(temp{i,j}-32).*5/9;
                Pm{i,j}=exp(a-b./(T{i,j}+c))*133.32236842105*1000;
                Ew{i,j}=52.*(Pm{i,j}-pres{i,j}).*(1+0.135*wind{i,j})/10000000000;
            else
                Ew{i,j}=zeros(14245,1);
            end
        else
            Ew{i,j}=[];
        end
        if A(i,j)==1 && sum(Ew_val{i,j})>0
            A_water(i,j)=1;
            Ew_dy{i,j}=ehm_hr2dy(Ew{i,j},3,24);
            r_sq(i,j)=min(min(corrcoef(Ew_dy{i,j}(end-14244:end,1),Ew_val{i,j}(:,1))))^.2;
            Nash(i,j)=NSE(Ew_dy{i,j}(end-14244:end,1),Ew_val{i,j}(:,1));
            mae(i,j)=mean(abs(Ew_dy{i,j}(end-14244:end,1)-Ew_val{i,j}(:,1)));
        end
    end
end
save('F:\文章\水文模型\data\2.1evap\Ew\Ew_3hr.mat','Ew');
