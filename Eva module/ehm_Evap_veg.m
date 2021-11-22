function [fvc04,lai04,vis04,nir04,sw04,alb,res03]=ehm_Evap_veg(output_1dy,A,veg_type,input_1dy,res)
E_label={'E','Eb','Ei','Ep','Es','Et'};
result_label={'result.Rsq','result.nse','result.rmse','result.mae'};
%%
if res==1
    for l2=1:length(result_label)
        for l1=1:length(E_label)
            a=[result_label{l2},'.',E_label{l1}];
            for v=1:length(unique(veg_type))-1
                x=find(veg_type==v);res01=[];
                for v1=1:size(x,1)
                    eval(['res01(end+1,1)=abs(',a,'(x(',num2str(v1),')));']);
                end
                res02(v,1)=mean(res01);
            end
            res03(:,(l2-1)*length(E_label)+l1)=mean(res02,2);
        end
    end
else
    res03=[];
end
%%
load('F:\ÎÄÕÂ\Ë®ÎÄÄ£ÐÍ\data\1.3regroup\shape.mat');
daily_format='yyyy-mm-dd';
for i=1:length(t_daily)
   date=datestr(t_daily(i),daily_format); 
   month(i,1)=str2double(date(6:7));  
end
% ------
for v=1:length(unique(veg_type))-1
    x=find(veg_type==v);
    for l=1:length(x)
        fvc01{v}(:,l)=input_1dy{x(l)}(:,18);
        lai01{v}(:,l)=input_1dy{x(l)}(:,20);
        vis01{v}(:,l)=mean(input_1dy{x(l)}(:,21:22),2);
        nir01{v}(:,l)=mean(input_1dy{x(l)}(:,23:24),2);
        sw01{v}(:,l)=mean(input_1dy{x(l)}(:,25:26),2);
    end
    fvc02(:,v)=mean(fvc01{v},2);
    lai02(:,v)=mean(lai01{v},2);
    vis02(:,v)=mean(vis01{v},2);
    nir02(:,v)=mean(nir01{v},2);
    sw02(:,v)=mean(sw01{v},2);
    for m=1:12
        fvc02_1=fvc02(month==m,v);
        lai02_1=lai02(month==m,v);
        vis02_1=vis02(month==m,v);
        nir02_1=nir02(month==m,v);
        sw02_1=sw02(month==m,v);
        if length(lai02_1)<length(fvc02(month==1))
           fvc02_1(length(fvc02_1)+1:length(fvc02(month==1)),1)=NaN;
           lai02_1(length(lai02_1)+1:length(lai02(month==1)),1)=NaN;
           vis02_1(length(vis02_1)+1:length(vis02(month==1)),1)=NaN;
           nir02_1(length(nir02_1)+1:length(nir02(month==1)),1)=NaN;
           sw02_1(length(sw02_1)+1:length(sw02(month==1)),1)=NaN;
        end
        fvc03(:,(v-1)*12+m)=fvc02_1;
        lai03(:,(v-1)*12+m)=lai02_1;
        vis03(:,(v-1)*12+m)=vis02_1;
        nir03(:,(v-1)*12+m)=nir02_1;
        sw03(:,(v-1)*12+m)=sw02_1;
    end
end
for m=1:12
    for v=1:length(unique(veg_type))-1
        fvc04(:,(m-1)*10+v)=fvc03(:,(v-1)*12+m);
        lai04(:,(m-1)*10+v)=lai03(:,(v-1)*12+m);
        vis04(:,(m-1)*10+v)=vis03(:,(v-1)*12+m);
        nir04(:,(m-1)*10+v)=nir03(:,(v-1)*12+m);
        sw04(:,(m-1)*10+v)=sw03(:,(v-1)*12+m);
    end
end
for i=1:12
    alb(:,(i-1)*3+1)=mean(vis04(:,(i-1)*10+1:(i-1)*10+10),2);
    alb(:,(i-1)*3+2)=mean(nir04(:,(i-1)*10+1:(i-1)*10+10),2);
    alb(:,(i-1)*3+3)=mean(sw04(:,(i-1)*10+1:(i-1)*10+10),2);
end


