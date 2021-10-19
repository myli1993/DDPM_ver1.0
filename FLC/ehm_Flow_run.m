function [para,result,Q_acc,Qs,STATES,FLUXES,Rbreak]=...
    ehm_Flow_run(A,in_3hr_2020,Flow_acc,Flow_dir,station,river_length,river_round,river_width,river_break,DEM,Qo,ns)
L=[-3,  0,   0,  0,    0,  0.3,  1,     0,      0.05,  0.01*8,  0.05*8,  0,    1,   0,   0];
U=[3,   20,  1,  0.8,  7,  1,    2000,  100,    2,     1*8,     0.1*8,   100,  6,   0.005, 0.005];
% L=[-3,  0,   0,  0,    0,  0.3,  1,     0,      0.05,  0.01*8,  0.05*8,  0,    1];
% U=[3,   20,  1,  0.8,  7,  1,    2000,  100*8,  2,     1*8,     0.1*8,   100,  6*8];
% Qo=q0(:,4);
% load('F:\文章\水文模型\II-Flow module\data\Qo.mat');
cor=-2;
%%
disp('************************* MODEL START *************************');
%%
for i=1:ns
    param(1,:)=(rand()*(U(1)-L(1)))+L(1);
    param(2,:)=round((rand()*(U(2)-L(2)))+L(2));
    param(3,:)=(rand()*(U(3)-L(3)))+L(3);
    param(4,:)=(rand()*(U(4)-L(4)))+L(4);
    param(5,:)=round((rand()*(U(5)-L(5)))+L(5));
    param(6,:)=(rand()*(U(6)-L(6)))+L(6);
    param(7,:)=(rand()*(U(7)-L(7)))+L(7);
    param(8,:)=(rand()*(U(8)-L(8)))+L(8);
    param(9,:)=(rand()*(U(9)-L(9)))+L(9);
    param(10,:)=(rand()*(U(10)-L(10)))+L(10);
    param(11,:)=(rand()*(U(11)-L(11)))+L(11);
    param(12,:)=(rand()*(U(12)-L(12)))+L(12);
    param(13,:)=round((rand()*(U(13)-L(13)))+L(13));
    param(14,:)=(rand()*(U(14)-L(14)))+L(14);
    param(15,:)=(rand()*(U(15)-L(15)))+L(15);
    
    [q_sim,STATES,FLUXES,P]=ehm_river_gridded(A,in_3hr_2020,param,100,2);
%     [~,Qo1]=ehm_river_accu(q_sim,Flow_acc,Flow_dir,station,river_length,river_round,river_width,river_break,DEM);
%     r2=(min(min(corrcoef(Qo(365*5:end),Qo1(365*5:length(Qo),1))))).^2;
%     hold on
%     plot(Qo1,'-b');plot(Qo,'.r');
%     hold off
    [Q_acc,Qs,Rbreak]=ehm_river_accu(q_sim,Flow_acc,Flow_dir,station,river_length,river_round,river_width,river_break,DEM);
    f(1)=mean(abs(Qs-Qo)); %MAE
    f(2)=1-sum((Qs-Qo).^2)/sum((mean(Qo)-Qo).^2); %NSE
    f(3)=abs(mean(Qs-Qo)); %BIAS
    f(4)=sqrt(mean((Qs-Qo).^2));%RMSE
    f(5)=min(min(corrcoef(Qs,Qo)));%R
    f(6)=sqrt(real((1-min(min(corrcoef(Qs,Qo)))).^2+(1-std(Qs)/std(Qo)).^2+(1-mean(Qs)/mean(Qo)).^2));%KGE
    if f(2)>cor
        result.MAE=f(1);
        result.NSE=f(2);
        result.BIAS=f(3);
        result.RMSE=f(4);
        result.R=f(5);
        result.Rsq=f(5)^2;
        result.KGE=f(6);
        para=param;
        disp(['***** BEST Rsq = ',num2str(result.Rsq),' ** NSE = ',num2str(result.NSE),' ** KGE = ',num2str(result.KGE),'; RESULTS SAVED *****']);
        cor=f(2);
    else
        disp(['----- Rsq = ',num2str(f(5)^2),' -- NSE = ',num2str(f(2)),' -- KGE = ',num2str(f(6)),'; RESULTS ABANDONED -----']);
    end
    if f(2)>0.905
       break; 
    end
    if mod(i,20)==0
        disp(['------ | ',num2str(i),'/',num2str(ns),' (',num2str(i/ns*100),'%) | ------']);
    end
end
disp('************************ SIMULATION END *************************');
disp('%%%%%%%%%%%%%%%%%%%% BEST RESULT %%%%%%%%%%%%%%%%%%%%');
disp(['***** BEST Rsq=',num2str(result.Rsq),' *****']);
disp(['***** BEST NSE=',num2str(result.NSE),' *****']);
disp(['***** BEST KGE=',num2str(result.KGE),' *****']);
%%
% close();
% figure;
% subplot(2,1,2)
% hold on
% plot(Qs(Qo>0.1),'-r');
% plot(Qo(Qo>0.1),'.b');
% hold off
% set(gca,'YDir','reverse');
 