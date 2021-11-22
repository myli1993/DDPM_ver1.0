function Q_station=ehm_station_Qsim(Q)
q_station=[7,10;12,18;11,29;11,17;12,18;13,20;7,18;11,25;10,31;9,13];%N;A1-A3;M1-M7;
for j=1:size(q_station,1)
    for i=1:size(Q{4,9},1)/8
        Q_station01(i,j)=sum(Q{q_station(j,1),q_station(j,2)}(1+(i-1)*8:8+(i-1)*8))/100;
    end
end
%% ALL
datestring1='19800101';datestring2='20201231';
dateformat='yyyymmdd';
t1=datenum(datestring1,dateformat);t2=datenum(datestring2,dateformat);
t_all=t1:t2;
%% AU
datestring1='20180715';datestring2='20201231';
dateformat='yyyymmdd';
t1=datenum(datestring1,dateformat);t2=datenum(datestring2,dateformat);
t_au=t1:t2;
%% MA
datestring1='20170401';datestring2='20171031';
dateformat='yyyymmdd';
t1=datenum(datestring1,dateformat);t2=datenum(datestring2,dateformat);
tday01=t1:7:t2;
datestring1='20180401';datestring2='20181031';
t1=datenum(datestring1,dateformat);t2=datenum(datestring2,dateformat);
tday02=t1:7:t2;
datestring1='20190401';datestring2='20191031';
t1=datenum(datestring1,dateformat);t2=datenum(datestring2,dateformat);
tday03=t1:7:t2;
datestring1='20200401';datestring2='20201031';
t1=datenum(datestring1,dateformat);t2=datenum(datestring2,dateformat);
tday04=t1:7:t2;
%%
for i=1:length(t_au)
    num_au(i,1)=find(t_all==t_au(i));
end
for i=1:length(tday01)
    num_ma1(i,1)=find(t_all==tday01(i));
end
for i=1:length(tday02)
    num_ma2(i,1)=find(t_all==tday02(i));
end
for i=1:length(tday03)
    num_ma3(i,1)=find(t_all==tday03(i));
end
for i=1:length(tday04)
    num_ma4(i,1)=find(t_all==tday04(i));
end
num_ma=[num_ma1;num_ma2;num_ma3;num_ma4];
%%
for j=1:size(q_station,1)
    if j<=3
        Q_station{j}=Q_station01(num_au,j);
    else
        Q_station{j}=Q_station01(num_ma,j);
    end
end


