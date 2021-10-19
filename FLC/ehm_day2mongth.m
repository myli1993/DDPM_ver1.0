function t5=ehm_day2mongth(Qo,Qs_CMFD,Qs_deltaT_CMFD,Qs_Noah,Qs_deltaT_Noah,in_3hr_2020)
% for i=1:length(Qo)
%     prec(i,1)=sum(in_3hr_2020{4,9}(1+(i-1)*8:8+(i-1)*8,4));
% end
DateString='19800101';
formatIn='yyyymmdd';
t1=datenum(DateString,formatIn);
DateString='20201231';
formatIn='yyyymmdd';
t2=datenum(DateString,formatIn);
t=t1:t2;
for i=1:length(t)
    dt=datestr(t(i),formatIn);
    t3(i,1)=str2double(dt(1:6));
end
% t3_index=unique(t3);
% for i=1:length(t3_index)
%     t4(i,1)=mean(Qo(t3==t3_index(i)));
%     t4(i,2)=mean(Qs_CMFD(t3==t3_index(i)));
%     t4(i,3)=mean(Qs_deltaT_CMFD(t3==t3_index(i)));
%     t4(i,4)=mean(Qs_Noah(t3==t3_index(i)));
%     t4(i,5)=mean(Qs_deltaT_Noah(t3==t3_index(i)));
%     t4(i,6)=mean(prec(t3==t3_index(i)));
% end
index=find(Qo>0.1 & Qs_CMFD>0.1 & Qs_deltaT_CMFD>0.1 & Qs_Noah>0.1 & Qs_deltaT_Noah>0.1);
t5(:,1)=t3(index);t5(:,2)=Qo(index);t5(:,3)=Qs_CMFD(index);
t5(:,4)=Qs_deltaT_CMFD(index);t5(:,5)=Qs_Noah(index);t5(:,6)=Qs_deltaT_Noah(index);
index=unique(t5(:,1));
for i=1:length(index)
    t6(i,1)=index(i);
    t6(i,2)=mean(t5(t5(:,1)==index(i),2));
    t6(i,3)=mean(t5(t5(:,1)==index(i),3));
    t6(i,4)=mean(t5(t5(:,1)==index(i),4));
    t6(i,5)=mean(t5(t5(:,1)==index(i),5));
    t6(i,6)=mean(t5(t5(:,1)==index(i),6));
end
t7=log(t6(:,2:end));
t8=[Qo Qs_CMFD Qs_deltaT_CMFD Qs_Noah Qs_deltaT_Noah];

