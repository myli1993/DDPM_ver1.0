function ehm_Evap_talor(result,veg_type)
load('F:\文章\水文模型\data\1.3regroup\shape.mat');
E_label={'E','Eb','Ei','Es','Et','Ew'};
result_label={'result.Rsq','result.sd'};
A_num=find(A==1);
veg=veg_type(A_num);
m=tabulate(veg(:));
veg_size=max(m(:,2));
for i=1:length(E_label)
    a=[result_label{1},'.',E_label{i}];
    b=[result_label{2},'.',E_label{i}];
    eval(['r01(:,',num2str(i),')=',a,'(A_num);']);
    eval(['s01(:,',num2str(i),')=',b,'(A_num);']);
    for j=1:10
       v_index=find(veg==j); 
       c=zeros(veg_size,1)*nan;
       c(1:length(v_index),1)=sqrt(r01(v_index,i));
       cm=max(max(c))+1;
       c(c>1)=c(c>1)/cm;
       r02{i}(:,j)=c;
       c(1:length(v_index),1)=s01(v_index,i);
       cm=max(max(c))+1;
       c(c>1)=c(c>1)/cm;
       s02{i}(:,j)=c;
    end
end
color=[1,197,255;170,255,1;56,167,0;38,115,0;254,190,190;254,255,115;132,1,169;115,76,0;255,1,196;230,152,0];
for i=1:length(E_label)/3
    %    STD=s02{i};COR=r02{i};
    s03{1}=s02{(i-1)*3+1};s03{2}=s02{(i-1)*3+2};s03{3}=s02{(i-1)*3+3};
    r03{1}=r02{(i-1)*3+1};r03{2}=r02{(i-1)*3+2};r03{3}=r02{(i-1)*3+3};
    taylordiag(s03,color,r03,i);
    close all
end
%%
% hold on
% for ii=1:10
%     pp(ii)=scatter(ii,1,150,color(ii,:)/255,'filled','diamond','MarkerFaceAlpha',.9);
% end
% hi=legend({'SBG','LCG','SKG','SGG','ASG','CMG','AFG','PAG','FSG','WCG'},'Location','northoutside');
% % legendmarkeradjust(15);
% legend('boxoff');
% % hi.NumColumns = 5;
% set(hi,'Orientation','horizon','Fontname', 'Times New Roman','FontWeight','bold','FontSize',24);
% set(gcf,'Color','w','Position',[0,0,1650,400],'units','normalized')
% export_fig(gcf,'-tif','-r300','-painters',['F:/文章/水文模型/pic/pic5/l1.tif']);


