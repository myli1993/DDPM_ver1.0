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
            train_x=input_1dy{i,j}(1:num_train,:)';%行为变量，列为序列
            test_x=input_1dy{i,j}(num_train+1:end,:)';
            train_y=output_1dy{i,j}(1:num_train,:)';
            test_y=output_1dy{i,j}(num_train+1:end,:)';
            [train_x,train_ps]=method(train_x);
            test_x=method('apply',test_x,train_ps);
            [train_y,output_ps]=method(train_y);
            test_y=method('apply',test_y,output_ps);
            [m,n1]=size(train_x);
            [~,n2]=size(test_x);
            trainD=reshape(train_x,[m,1,1,n1]);%训练集输入
            testD=reshape(test_x,[m,1,1,n2]);%测试集输入
            targetD=train_y;%训练集输出
            targetD_test=test_y;%测试集输出
            layers = [imageInputLayer([m 1 1]) %输入层参数设置
                convolution2dLayer(3,16,'Padding','same')%核大小、数量，填充方式
                reluLayer%relu激活函数
                fullyConnectedLayer(384) % 384 全连接层神经元
                fullyConnectedLayer(384) % 384 全连接层神经元
                fullyConnectedLayer(7) % 输出层神经元
                regressionLayer];%添加回归层，用于计算损失值
            % 设置迭代次数 batchsize 学习率啥的
            options = trainingOptions('adam', ...
                'MaxEpochs',10, ...
                'MiniBatchSize',16, ...
                'InitialLearnRate',0.005, ...
                'GradientThreshold',1, ...
                'Verbose',false,...
                'ValidationData',{testD,targetD_test'});%                'Plots','training-progress',...
            % 训练
            net{i,j} = trainNetwork(trainD,targetD',layers,options);
            YPred = predict(net{i,j},testD);
            YPred=double(YPred');%输出是n*1的single型数据，要转换为1*n的double是数据形式
            predict_value{i,j}=method('reverse',YPred,output_ps);predict_value{i,j}=double(abs(predict_value{i,j}));
            true_value{i,j}=method('reverse',targetD_test,output_ps);true_value{i,j}=double(true_value{i,j});
            if sum(output_1dy{i,j}(:,7))==0
                predict_value{i,j}(7,:)=0;
            end
            rsquare{i,j}=min(min(corrcoef(true_value{i,j},predict_value{i,j})))^.2;
            rmse{i,j}=sqrt(mean((true_value{i,j}-predict_value{i,j}).^2));
%             disp(['根均方差(RMSE)：',num2str(rmse)])
            mae{i,j}=mean(abs(true_value{i,j}-predict_value{i,j}));
%             disp(['平均绝对误差（MAE）：',num2str(mae)])
            mape{i,j}=mean(abs((true_value{i,j}-predict_value{i,j})./true_value{i,j}));
%             disp(['平均相对百分误差（MAPE）：',num2str(mape*100),'%'])

%%
            [m3,n3]=size(input_3hr{i,j});
            pred_D=reshape(input_3hr{i,j},[m3,1,1,n3]);%测试集输入
            Pred_3hr=predict(net{i,j},pred_D);
            Pred_3hr01=double(Pred_3hr');%输出是n*1的single型数据，要转换为1*n的double是数据形式
            pred_Evap{i,j}=method('reverse',Pred_3hr01,output_ps);pred_Evap{i,j}=double(abs(pred_Evap{i,j}));

        end
        num_complete=(i-1)*size(A,2)+j;
        if mod(num_complete,5)==0
            disp(['----- Model Build Completed ',num2str(num_complete/area*100),'% -----'])
        end
    end
end


