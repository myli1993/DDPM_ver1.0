function result=model_kge(A,result,Evap_1dy,output_1dy)
name={'E','Eb','Ei','Ep','Es','Et','Ew'};
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            for k=1:size(name,1)
                pred=Evap_1dy{i,j}(:,k);
                obvi=output_1dy{i,j}(:,k);
                eval(['result.kge.',name{k},'(i,j)=sqrt(real((1-min(min(corrcoef(obvi,pred)))).^2+(1-std(pred)).^2+(1-mean(pred)).^2));']);
            end

        end
    end
end

for k=1:size(name,1)
    eval(['result.kge.',name{k},'=result.kge.',name{k},'/max(max(result.kge.',name{k},'));']);
end

