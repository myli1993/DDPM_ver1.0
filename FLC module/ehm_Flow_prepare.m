function [in_flow_1dy,in_flow_3hr,in_tot_1dy,in_tot_3hr,q0,P]=ehm_Flow_prepare()
load('F:\文章\水文模型\I-Eva module\data\2.1evap\eva_result.mat');
load('F:\文章\水文模型\I-Eva module\data\1.3regroup\shape.mat');
%% Data
formatIn = 'yyyy-mm-dd';
%------ 1dy -----%
for i=1:length(t_daily)
    date=datestr(t_daily(i), formatIn);
    time_1dy(i,1)=str2double(date(1:4));
    time_1dy(i,2)=str2double(date(6:7));
    time_1dy(i,3)=str2double(date(9:10));
end

for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            snow_out_1dy01=output_1dy{i,j}(:,5);            
            snow_out_1dy{i,j}(snow_out_1dy01==0,1)=0;
            snow_out_1dy{i,j}(snow_out_1dy01>0,1)=1;
        end
    end
end

for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            in_flow_1dy{i,j}(:,1:3)=time_1dy(:,:);%time
            in_flow_1dy{i,j}(:,4)=(input_1dy{i,j}(:,1)/0.0025);%prec (mmdy-1)
            in_flow_1dy{i,j}(:,5)=input_1dy{i,j}(:,2)-273.15;%temp (C)
            in_flow_1dy{i,j}(:,6)=Evap_1dy{i,j}(:,1);%Ea (mmdy-1)
            in_flow_1dy{i,j}(:,7)=Evap_1dy{i,j}(:,4);%Ep (mmdy-1)
            in_flow_1dy{i,j}(:,8)=snow_out_1dy{i,j}(:,1);%snow judge
            in_flow_1dy{i,j}(:,9)=input_1dy{i,j}(:,9);%SM_surf
            in_flow_1dy{i,j}(:,10)=input_1dy{i,j}(:,8);%SM_root
            
            for k=1:size(t_daily,1)
                if in_flow_1dy{i,j}(k,4)<1
                    in_flow_1dy{i,j}(k,4)=0;
                else
                    in_flow_1dy{i,j}(k,4)=floor(in_flow_1dy{i,j}(k,4))*0.2;
                end
            end
        end
    end
end
%------ 3hr ------%
for i=1:length(t)
    date=datestr(t(i), formatIn);
    time_3hr(i,1)=str2double(date(1:4));
    time_3hr(i,2)=str2double(date(6:7));
    time_3hr(i,3)=str2double(date(9:10));
end

for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            snow_out_3hr01=Evap_3hr{i,j}(:,5);
            snow_out_3hr{i,j}(snow_out_3hr01==0,1)=0;
            snow_out_3hr{i,j}(snow_out_3hr01>0,1)=1;
        end
    end
end

for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            in_flow_3hr{i,j}(:,1:3)=time_3hr;%time
            in_flow_3hr{i,j}(:,4)=input_3hr{i,j}(:,1)/0.0025;%prec (mm 3hr-1)
            in_flow_3hr{i,j}(:,5)=input_3hr{i,j}(:,2)-273.15;%temp (C)
            in_flow_3hr{i,j}(:,6)=Evap_3hr{i,j}(:,1)/8;%Ea (mm 3hr-1)
            in_flow_3hr{i,j}(:,7)=Evap_3hr{i,j}(:,4)/8;%Ep (mm 3hr-1)
            in_flow_3hr{i,j}(:,8)=snow_out_3hr{i,j}(:,1);%snow judge
            in_flow_3hr{i,j}(:,9)=input_3hr{i,j}(:,9);%SM_surf
            in_flow_3hr{i,j}(:,10)=input_3hr{i,j}(:,8);%SM_root
            
            for k=1:size(t_daily,1)
                if in_flow_3hr{i,j}(k,4)<1
                    in_flow_3hr{i,j}(k,4)=0;
                else
                    in_flow_3hr{i,j}(k,4)=floor(in_flow_3hr{i,j}(k,4))*0.2*3;%prec (mm 3hr-1)
                end
            end
            
        end
    end
end

%%
m=[];n=[];
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            m(end+1)=i;
            n(end+1)=j;
        end
    end
end
for i=1:size(m,2)
    d1(:,i)=in_flow_1dy{m(i),n(i)}(:,4);
    d2(:,i)=in_flow_1dy{m(i),n(i)}(:,5);
    d3(:,i)=in_flow_1dy{m(i),n(i)}(:,6);
    d4(:,i)=in_flow_1dy{m(i),n(i)}(:,7);
    d5(:,i)=in_flow_1dy{m(i),n(i)}(:,8);
    d6(:,i)=in_flow_1dy{m(i),n(i)}(:,9);
    d7(:,i)=in_flow_1dy{m(i),n(i)}(:,10);
end
in_tot_1dy(:,1:3)=time_1dy;%time
in_tot_1dy(:,4)=mean(d1,2);
in_tot_1dy(:,5)=mean(d2,2);
in_tot_1dy(:,6)=mean(d3,2);
in_tot_1dy(:,7)=mean(d4,2);
in_tot_1dy(:,8)=mode(d5,2);
in_tot_1dy(:,9)=mean(d6,2);
in_tot_1dy(:,10)=mean(d7,2);
%%
m=[];n=[];
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            m(end+1)=i;
            n(end+1)=j;
        end
    end
end
for i=1:size(m,2)
    dd1(:,i)=in_flow_3hr{m(i),n(i)}(:,4);
    dd2(:,i)=in_flow_3hr{m(i),n(i)}(:,5);
    dd3(:,i)=in_flow_3hr{m(i),n(i)}(:,6);
    dd4(:,i)=in_flow_3hr{m(i),n(i)}(:,7);
    dd5(:,i)=in_flow_3hr{m(i),n(i)}(:,8);
    dd6(:,i)=in_flow_3hr{m(i),n(i)}(:,9);
    dd7(:,i)=in_flow_3hr{m(i),n(i)}(:,10);
end
in_tot_3hr(:,1:3)=time_3hr;%time
in_tot_3hr(:,4)=mean(dd1,2);
in_tot_3hr(:,5)=mean(dd2,2);
in_tot_3hr(:,6)=mean(dd3,2);
in_tot_3hr(:,7)=mean(dd4,2);
in_tot_3hr(:,8)=mode(dd5,2);
in_tot_3hr(:,9)=mean(dd6,2);
in_tot_3hr(:,10)=mean(dd7,2);
%%
qdata0=xlsread('F:\文章\黑子\data\ori\径流数据整理 1963~2012年.xlsx','Sheet2');
q0(:,1:3)=time_1dy;
for i=1:size(time_1dy)
    yy=time_1dy(i,1);
    mm=time_1dy(i,2);
    dd=time_1dy(i,3);
    m=find(qdata0(:,1)==yy);
    q0(i,4)=qdata0(m+dd,1+mm);
end
for i=1:size(q0,1)
    if isnan(q0(i,4))
        q0(i,4)=q0(i-1,4);
    end
end
%%
num=1;
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            time(:,1:3)=time_1dy(:,:);%time
            prec(:,num)=floor((input_1dy{i,j}(:,1)/0.0025))*0.2;%prec (mm dy-1)
            num=num+1;
        end
    end
end
P(:,1:3)=time;
P(:,4)=mean(prec,2);
