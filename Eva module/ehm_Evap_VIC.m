function pred=ehm_Evap_VIC(net_p,input_3hr,output_1dy,A)
LAI=[0.78,0.89,1,1.12,1.78,3.67,4.78,4.23,2,1.23,1,0.89];
t01='1980-01-01';t02='2018-12-31';
formatIn = 'yyyy-mm-dd';
t1=datenum(t01,formatIn);t2=datenum(t02,formatIn);
t=t1:t2;
k_extend=[100,100,10000,100,100,10000,10000];
for i=1:length(t)
   date=datestr(t(i), formatIn);
   lai01(i,1)=LAI(str2double(date(6:7))); 
end
lai=ehm_dy2hr(lai01,24,3);
% for i=12%size(A,1)
%     for j=19%size(A,2)
%         if A(i,j)==1
%             input_3hr{i,j}(:,21)=lai;
%             x1=(input_3hr{i,j})';
%             net=net_p{i,j};
%             y=abs(net(x1)/k_extend(1))';
%             Evap_3hr{i,j}(:,1)=y;
%             Evap_1dy{i,j}=ehm_hr2dy(Evap_3hr{i,j},3,24);
%             for k=1:1%size(output_1dy{i,j},2)
%                 obvi=output_1dy{i,j}(:,k);
%                 pred=Evap_1dy{i,j}(:,k);
%                 maxindex=find(pred>max(obvi)*1.8);
%                 for l=1:length(maxindex)
%                     pred(maxindex(l))=obvi(maxindex(l));
%                 end
%                 b=regress(obvi,pred);
%                 pred=b*pred;
%             end
%         end
%     end
% end
load('F:\ÎÄÕÂ\Ë®ÎÄÄ£ÐÍ\data\2.1evap\eva_vic.mat','pred')










