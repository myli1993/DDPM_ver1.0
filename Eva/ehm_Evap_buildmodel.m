function [net,pred_Evap,rspuare,rmse,mae,mape]=ehm_Evap_buildmodel(input_1dy,output_1dy,input_3hr,A,k_train,mm1)
if mm1==1
    method=@mapminmax;
elseif mm1==2
    method=@mapstd;
end
area=size(A,1)*size(A,2);
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            num_sample=size(input_1dy{i,j},1);
            num_train=floor(num_sample*k_train);
            train_x=input_1dy{i,j}(1:num_train,:)';%��Ϊ��������Ϊ����
            test_x=input_1dy{i,j}(num_train+1:end,:)';
            train_y=output_1dy{i,j}(1:num_train,:)';
            test_y=output_1dy{i,j}(num_train+1:end,:)';
            [train_x,train_ps]=method(train_x);
            test_x=method('apply',test_x,train_ps);
            [train_y,output_ps]=method(train_y);
            test_y=method('apply',test_y,output_ps);
            [m,n1]=size(train_x);
            [~,n2]=size(test_x);
            trainD=reshape(train_x,[m,1,1,n1]);%ѵ��������
            testD=reshape(test_x,[m,1,1,n2]);%���Լ�����
            targetD=train_y;%ѵ�������
            targetD_test=test_y;%���Լ����
            layers = [imageInputLayer([m 1 1]) %������������
                convolution2dLayer(3,16,'Padding','same')%�˴�С����������䷽ʽ
                reluLayer%relu�����
                fullyConnectedLayer(384) % 384 ȫ���Ӳ���Ԫ
                fullyConnectedLayer(384) % 384 ȫ���Ӳ���Ԫ
                fullyConnectedLayer(7) % �������Ԫ
                regressionLayer];%��ӻع�㣬���ڼ�����ʧֵ
            % ���õ������� batchsize ѧϰ��ɶ��
            options = trainingOptions('adam', ...
                'MaxEpochs',10, ...
                'MiniBatchSize',16, ...
                'InitialLearnRate',0.005, ...
                'GradientThreshold',1, ...
                'Verbose',false,...
                'ValidationData',{testD,targetD_test'});%                'Plots','training-progress',...
            % ѵ��
            net{i,j} = trainNetwork(trainD,targetD',layers,options);
            YPred = predict(net{i,j},testD);
            YPred=double(YPred');%�����n*1��single�����ݣ�Ҫת��Ϊ1*n��double��������ʽ
            predict_value{i,j}=method('reverse',YPred,output_ps);predict_value{i,j}=double(abs(predict_value{i,j}));
            true_value{i,j}=method('reverse',targetD_test,output_ps);true_value{i,j}=double(true_value{i,j});
            if sum(output_1dy{i,j}(:,7))==0
                predict_value{i,j}(7,:)=0;
            end
            rsquare{i,j}=min(min(corrcoef(true_value{i,j},predict_value{i,j})))^.2;
            rmse{i,j}=sqrt(mean((true_value{i,j}-predict_value{i,j}).^2));
%             disp(['��������(RMSE)��',num2str(rmse)])
            mae{i,j}=mean(abs(true_value{i,j}-predict_value{i,j}));
%             disp(['ƽ��������MAE����',num2str(mae)])
            mape{i,j}=mean(abs((true_value{i,j}-predict_value{i,j})./true_value{i,j}));
%             disp(['ƽ����԰ٷ���MAPE����',num2str(mape*100),'%'])

%%
            [m3,n3]=size(input_3hr{i,j});
            pred_D=reshape(input_3hr{i,j},[m3,1,1,n3]);%���Լ�����
            Pred_3hr=predict(net{i,j},pred_D);
            Pred_3hr01=double(Pred_3hr');%�����n*1��single�����ݣ�Ҫת��Ϊ1*n��double��������ʽ
            pred_Evap{i,j}=method('reverse',Pred_3hr01,output_ps);pred_Evap{i,j}=double(abs(pred_Evap{i,j}));

        end
        num_complete=(i-1)*size(A,2)+j;
        if mod(num_complete,5)==0
            disp(['----- Model Build Completed ',num2str(num_complete/area*100),'% -----'])
        end
    end
end


