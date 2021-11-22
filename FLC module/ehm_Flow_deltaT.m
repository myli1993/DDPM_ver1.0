function [Q_deltaT01,Qs_deltaT01,Q_deltaT02,Qs_deltaT02]=ehm_Flow_deltaT(para,A,in_3hr_2020,Flow_acc,Flow_dir,station,river_length,river_round,river_width,river_break,DEM,Qs)
[q_sim,~,~,~]=ehm_river_gridded(A,in_3hr_2020,para,100,1);
[Q_deltaT01,Qs_deltaT01,Q_deltaT02,Qs_deltaT02]=...
    ehm_river_accu_deltaT(q_sim,Flow_acc,Flow_dir,station,river_length,river_round,river_width,river_break,DEM);
% [Q_deltaT01,Qs_deltaT01,Q_deltaT02,Qs_deltaT02]=...
%     ehm_river_accu_deltaT01(q_sim,Flow_acc,Flow_dir,station,river_length,river_round,river_width,river_break,DEM);
% f(1)=mean(abs(Qs_deltaT-Qs)); %MAE
% f(2)=1-sum((Qs_deltaT-Qs).^2)/sum((mean(Qs)-Qs).^2); %NSE
% f(3)=abs(mean(Qs_deltaT-Qs)); %BIAS
% f(4)=sqrt(mean((Qs_deltaT-Qs).^2));%RMSE
% f(5)=min(min(corrcoef(Qs_deltaT,Qs)));%R
% f(6)=sqrt(real((1-min(min(corrcoef(Qs,Qs_deltaT)))).^2+(1-std(Qs)/std(Qs_deltaT)).^2+(1-mean(Qs)/mean(Qs_deltaT)).^2));%KGE
% disp(['----- Rsq = ',num2str(f(5)^2),' -- NSE = ',num2str(f(2)),' -- KGE = ',num2str(f(6)),' -----']);









