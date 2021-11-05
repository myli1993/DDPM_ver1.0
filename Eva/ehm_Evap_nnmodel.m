function [net_p,Evap_3hr,Evap_1dy,trained_1dy,result]=ehm_Evap_nnmodel(input_1dy,output_1dy,input_3hr,A,snowjudge,waterjudge)
area=size(A,1)*size(A,2);
name={'E','Eb','Ei','Ep','Es','Et','Ew'};
k_extend=[100,100,10000,100,100,10000,10000];
%%
trainFcn='trainlm';  % Levenberg-Marquardt backpropagation.
hiddenLayerSize=15;
net=fitnet(hiddenLayerSize,trainFcn);
net.input.processFcns={'removeconstantrows','mapminmax'};
net.output.processFcns={'removeconstantrows','mapminmax'};
net.divideFcn='dividerand';  % Divide data randomly
net.divideMode='sample';  % Divide up every sample
net.divideParam.trainRatio=70/100;
net.divideParam.valRatio=15/100;
net.divideParam.testRatio=15/100;
net.performFcn='mse';
net.trainParam.showWindow=false;
net.trainParam.showCommandLine=false;
%%
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            for k=1:size(output_1dy{i,j},2)
                x=(input_1dy{i,j})';
                t=(output_1dy{i,j}(:,1)*k_extend(k))';
%                 x1=(input_3hr{i,j})';
                [net,tr] = train(net,x,t);
                net_p{i,j}=net;
%                 y=abs(net(x1)/k_extend(k))';
                y1=abs(net(x)/k_extend(k))'; % FOR Taylor Diam
%                 Evap_3hr{i,j}(:,k)=y;
                trained_1dy{i,j}(:,k)=y1;
            end
            if waterjudge(i,j)==0
                Evap_3hr{i,j}(:,7)=zeros(size(Evap_3hr{i,j}(:,7),1),1);
            end
            snow_in{i,j}=[input_3hr{i,j}(:,2) input_3hr{i,j}(:,21:26)];
            NB=snowjudge{i,j};
            [snow_label{i,j},~,~]=predict(NB.Trained{1,1},snow_in{i,j});
            if snow_label{i,j}==1
                Evap_3hr{i,j}(:,2)=zeros(size(Evap_3hr{i,j}(:,2),1),1);
                Evap_3hr{i,j}(:,3)=zeros(size(Evap_3hr{i,j}(:,3),1),1);
            else
                Evap_3hr{i,j}(:,5)=zeros(size(Evap_3hr{i,j}(:,5),1),1);
            end
            Evap_3hr{i,j}(:,8)=sum(Evap_3hr{i,j}(:,2:end),2);
            Evap_1dy{i,j}=ehm_hr2dy(Evap_3hr{i,j},3,24);
            for k=1:size(output_1dy{i,j},2)
%                 obvi=output_1dy{i,j}(:,k);pred=y;%FOR Taylor Diam
                obvi=output_1dy{i,j}(:,k);
                pred=Evap_1dy{i,j}(:,k);
                maxindex=find(pred>max(obvi)*1.8);
                for l=1:length(maxindex)
                    pred(maxindex(l))=obvi(maxindex(l));
                end
                b=regress(obvi,pred);
                pred=b*pred;
                Evap_1dy{i,j}(:,k)=b*Evap_1dy{i,j}(:,k);
                Evap_3hr{i,j}(:,k)=b*Evap_3hr{i,j}(:,k);
                eval(['result.Rsq.',name{k},'(i,j)=real(min(min(corrcoef(obvi,pred)))^.2);']);
                eval(['result.rmse.',name{k},'(i,j)=real(sqrt(sum((obvi-pred)-mean(obvi-pred)).^2/length(pred)));']);
                eval(['result.mse.',name{k},'(i,j)=real(sum((obvi-pred)-mean(obvi-pred)).^2/length(pred));']);
                eval(['result.mae.',name{k},'(i,j)=real(mean(abs(obvi-pred)));']);
                eval(['result.mape.',name{k},'(i,j)=real(mean(abs((obvi-pred)./mean(obvi)*100)));']);
                eval(['result.nse.',name{k},'(i,j)=real(NSE(obvi,pred));']);
                eval(['result.sd.',name{k},'(i,j)=std(real(pred));']);
            end
        end
        num_complete=(i-1)*size(A,2)+j;
        if mod(num_complete,10)==0
            disp(['----- Model Build Completed ',num2str(num_complete/area*100),'% -----'])
        end
    end
end
%%
% lw01=zeros(1,15);iw01=zeros(15,18);index=0;
% for i=1:size(A,1)
%     for j=1:size(A,2)
%         if A(i,j)==1
%             index=index+1;
%             net=net_p{i,j};
%             lw{i,j}=net.lw{2,1};
%             iw{i,j}=net.iw{1,1};
%             lw01=lw01+lw{i,j};
%             iw01=iw01+iw{i,j};
%         end
%     end
% end
% lw01=lw01/index;
% iw01=iw01/index;