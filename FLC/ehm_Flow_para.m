function [para,result]=ehm_Flow_para(input,q0,ns,warmup,Case,time_scale)
if time_scale==1
    L=[-3,0,0,0,0,0.3,1,0,0.05,0.01,0.05,0,1];
    U=[3,20,1,0.8,7,1,2000,100,2,1,0.1,100,6];
elseif time_scale==2
    L=[-3,0,0,0,0,0.3,1,0,0.05,0.01/80,0.05/80,0,1];
    U=[3,20,1,0.8,7,1,2000,100/80,2,1/80,0.1/80,100,6*8];
end
prec=input(:,4);
temp=input(:,5);
ept=input(:,6);
flow=q0(:,2);
cor=-2;
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
    [f0,Q_sim0,STATES0,FLUXES0]=hbv_snow_objfun(param,prec,temp,ept,flow,warmup,Case,time_scale);
    if i>1
        if f0(7)>cor
            cor=f0(7);nse=f0(2);
            f=f0;Q_sim=Q_sim0;STATES=STATES0;FLUXES=FLUXES0;param0=param;
        end
    end
    if mod(i,400)==0
        disp(['------ | ',num2str(i),'/',num2str(ns),' (',num2str(i/ns*100),'%) --- Best R->',num2str(cor),...
            ' NSE->',num2str(nse),' | ------']);
    end
end
result.f=f;
result.Q_sim=Q_sim;
result.STATES=STATES;
result.FLUXES=FLUXES;
para=param0;