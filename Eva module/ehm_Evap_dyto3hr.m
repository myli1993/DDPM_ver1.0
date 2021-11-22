function [output_3hr,output_hr2dy]=ehm_Evap_dyto3hr(input_1dy,output_1dy,input_3hr,A,method)
if method==1
    [net,E_pred,RSQ_build,RMSE_build,MAE_build,MAPE_build]=ehm_Evap_buildmodel(input_1dy,output_1dy,A,0.7,1);%1:@mapminmax;2:@mapstd;
    [output_3hr,output_hr2dy]=ehm_Evap_dy2hr(net,input_3hr,A);
elseif method==2
    for i=1:size(A,1)
        for j=1:size(A,2)
            if A(i,j)==1
                [b{i,j},~,~,~,stats{i,j}]=regress(output_1dy,[input_1dy{i,j} ones(size(input_1dy,1),1)]);

            end
        end
    end
end
