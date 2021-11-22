function [Q_acc,q_station]=ehm_river_accu(q_sim,Flow_acc,Flow_dir,station,river_length,river_round,river_width,river_break,DEM)
%%
%Width:1,3,5,10m;
%g=9.80665m/s^2;
%m_water=1000kg/m3;
%r0=1000m;
%Re=500;lamda=24/Re;
%% Constant
g=9.80665;
r0=1000;
lamda=24/500;
n_roughness=0.0055;
%% q0
max_acc=max(max(Flow_acc));
num=1;send_index=zeros(1,4);
for i=max_acc:-1:0
    [m,n]=find(Flow_acc==i);
    for j=1:size(m,1)
        %% dh
        [m_next,n_next]=grid_next(m(j),n(j),Flow_dir);
        dh=abs(double(DEM(m(j),n(j))-DEM(m_next,n_next)));
        %% Water height
        if num==1
            disp(['WITHOUT UPSTREAM GRID{',num2str(m(j)),',',num2str(n(j)),'}'])
            qq_sim=q_sim{m(j),n(j)};
            Q_acc{m(j),n(j)}=qq_sim;
        else
            m_before=find(send_index(:,1)==m(j) & send_index(:,2)==n(j));
            if isempty(m_before)
                disp(['WITHOUT UPSTREAM GRID{',num2str(m(j)),',',num2str(n(j)),'}'])
                qq_sim=q_sim{m(j),n(j)};
                Q_acc{m(j),n(j)}=qq_sim;
            else
                disp(['WITH UPSTREAM GRID{',num2str(m(j)),',',num2str(n(j)),'} --- upstream num:',num2str(length(m_before))]);
                qq_sim=0;
                for ll=1:length(m_before)
%                     disp(num2str(ll));
%                     disp([num2str(i),'-',num2str(j),'-',num2str(m(j)),'-',num2str(n(j)),'-',num2str(m_before)]);
%                     disp(num2str(send_index));
                    qq_sim=q_sim{m(j),n(j)}+qo{send_index(m_before(ll),3),send_index(m_before(ll),4)}+qq_sim;
                    Q_acc{m(j),n(j)}=qq_sim;
                end
            end
        end
        h=Q_acc{m(j),n(j)};
        %% R
        R=(h*river_width(m(j),n(j)))./(2*h+river_width(m(j),n(j)));
        %% C
        C=1/n_roughness*R.^(1/6);
        %% v1
        J=dh/4000;
        v1=C.*sqrt(R*J);
        %%
        for t=1:size(qq_sim,1)
            if h(t,1)<=river_break(m(j),n(j))
                Rlength(t,1)=river_length(m(j),n(j));
                Rround(t,1)=river_round(m(j),n(j));
            else
                %h{m(j),n(j)}(t,1)=river_break(m(j),n(j));
                if t+8*365*3<=size(qq_sim,1)
%                     Rbreak{i,j}(t,1)=1;
                    Rlength(t:t+8*365*1,1)=4.2+0*(river_length(m(j),n(j))-4.2)/3;
                    Rlength(t+8*365*1:t+8*365*2,1)=4.2+1*(river_length(m(j),n(j))-4.2)/3;
                    Rlength(t+8*365*2:t+8*365*3,1)=4.2+2*(river_length(m(j),n(j))-4.2)/3;
                    Rround(t:t+8*365*3,1)=0*river_round(m(j),n(j))/3;
                    Rround(t+8*365*1:t+8*365*2,1)=1*river_round(m(j),n(j))/3;
                    Rround(t+8*365*2:t+8*365*3,1)=2*river_round(m(j),n(j))/3;
                    t=t+8*365*3;
                else
                    dt=size(qq_sim,1)-t;
                    if dt<=8*365*1
                        Rlength(t:size(qq_sim,1),1)=4.2+0*(river_length(m(j),n(j))-4.2)/3;
                        Rround(t:size(qq_sim,1),1)=0*river_round(m(j),n(j))/3;
                    elseif dt<=8*365*2 && dt>8*365*1
                        Rlength(t:t+8*365*1,1)=4.2+0*(river_length(m(j),n(j))-4.2)/3;
                        Rround(t:t+8*365*1,1)=0*river_round(m(j),n(j))/3;
                        Rlength(t+8*365*1:size(qq_sim,1),1)=4.2+1*(river_length(m(j),n(j))-4.2)/3;
                        Rround(t+8*365*1:size(qq_sim,1),1)=1*river_round(m(j),n(j))/3;
                    elseif dt<=8*365*3 && dt>8*365*2
                        Rlength(t:t+8*365*1,1)=4.2+0*(river_length(m(j),n(j))-4.2)/3;
                        Rround(t:t+8*365*1,1)=0*river_round(m(j),n(j))/3;
                        Rlength(t+8*365*1:t+8*365*2,1)=4.2+1*(river_length(m(j),n(j))-4.2)/3;
                        Rround(t+8*365*1:t+8*365*2,1)=1*river_round(m(j),n(j))/3;
                        Rlength(t+8*365*2:size(qq_sim,1),1)=4.2+2*(river_length(m(j),n(j))-4.2)/3;
                        Rround(t+8*365*2:size(qq_sim,1),1)=2*river_round(m(j),n(j))/3;
                    end
                    t=size(qq_sim,1);
                end
            end
        end
        %% hf
        X=sqrt(dh^2+4000^2)/1000/4;
        hf=lamda*Rlength*X/4./(R).*(v1.^2)/(2*g);
        hf(isnan(hf))=0;
        %% hj
        s=2*g*r0*river_round(m(j),n(j))/360./(R.*C)*(1+3/4*sqrt(river_width(m(j),n(j))/r0));
        hj=s.*(v1.^2)/(2*g);
        hj(isnan(hj))=0;
        %% v2
        v2=real(sqrt(((v1.^2)/(2*g)-(hf+hj)+dh)));
        %% q0
        time_run=Rlength./(0.5*v1+0.5*v2);
        time_run(isinf(time_run))=0;
        time_run(time_run>24)=0;
        time_run1=floor(time_run);
        qo1=zeros(size(qq_sim,1),1);
        qq_index=1;
        for t=1:size(qq_sim,1)
            if time_run1(t)~=0
                if t==1
                    qo1(t+time_run1(t),1)=qq_sim(t,1)*(time_run1(t)/time_run(t));
                    qo1(t+time_run1(t)+1,1)=qq_sim(t,1)*(1-time_run1(t)/time_run(t));
                    qq_index=t+time_run1(t)+1;
                elseif t>1
                    if t+time_run1(t)==qq_index && t+time_run1(t)<=size(qq_sim,1)
                        qo1(t+time_run1(t),1)=qq_sim(t,1)*(time_run1(t)/time_run(t))+qo1(qq_index,1);
                        qq_index=t+time_run1(t)+1;
                    elseif t+time_run1(t)~=qq_index && t+time_run1(t)<=size(qq_sim,1)
                        qo1(t+time_run1(t),1)=qq_sim(t,1)*(time_run1(t)/time_run(t));
                        qq_index=t+time_run1(t)+1;
                    end
                end
            else
                qo1(t,1)=0;
            end
        end
        qo{m(j),n(j)}(1:size(qq_sim,1),1)=qo1(1:size(qq_sim,1),1);
        send_index(num,:)=[m_next,n_next,m(j),n(j)];
        num=num+1;
    end
    %     disp(num2str(i));
end
% q_station=Q_acc{station(1),station(2)};
for i=1:size(qq_sim,1)/8
    q_station(i,1)=mean(Q_acc{station(1),station(2)}(1+(i-1)*8:8+(i-1)*8));
end


