function Flow_dir=ehm_Flow_Dir(A,DEM,outlet)
dem=9999.*ones(size(A,1)+2,size(A,2)+2);
m=[-1,0,1,1,1,0,-1,-1];
n=[1,1,1,0,-1,-1,-1,0];
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            dem(i+1,j+1)=DEM(i,j);
        end
        if A(i,j)==1
            for k=1:length(m)
               h{i,j}(k)=dem(1+i+m(1,k),1+j+n(1,k)); 
            end
            [~,index(i,j)]=min(h{i,j});
            Flow_dir(i,j)=index(i,j);
        else
            Flow_dir(i,j)=-1;
        end
    end
end
Flow_dir(outlet(1),outlet(2))=0;
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            dem(i+1,j+1)=DEM(i,j);
        end
        if A(i,j)==1
            for k=1:length(m)
               h{i,j}(k)=dem(1+i+m(1,k),1+j+n(1,k)); 
            end
            [~,index(i,j)]=min(h{i,j});
            Flow_dir(i,j)=index(i,j);
        else
            Flow_dir(i,j)=-1;
        end
    end
end
Flow_dir(outlet(1),outlet(2))=0;

doindex=1;
while doindex==1
    doindex=0;
    for i=1:size(A,1)
        for j=1:size(A,2)
            if A(i,j)==1
                if Flow_dir(i,j)==1 && Flow_dir(i-1,j+1)==5
                    h{i,j}(1)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                elseif Flow_dir(i,j)==2 && Flow_dir(i,j+1)==6
                    h{i,j}(2)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                elseif Flow_dir(i,j)==3 && Flow_dir(i+1,j+1)==7
                    h{i,j}(3)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                elseif Flow_dir(i,j)==4 && Flow_dir(i+1,j)==8
                    h{i,j}(4)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                elseif Flow_dir(i,j)==5 && Flow_dir(i+1,j-1)==1
                    h{i,j}(5)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                elseif Flow_dir(i,j)==6 && Flow_dir(i,j-1)==2
                    h{i,j}(6)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                elseif Flow_dir(i,j)==7 && Flow_dir(i-1,j-1)==3
                    h{i,j}(7)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                elseif Flow_dir(i,j)==8 && Flow_dir(i-1,j)==4
                    h{i,j}(8)=9999;
                    [~,Flow_dir(i,j)]=min(h{i,j});
                    doindex=1;
                end
            end
        end
    end
end




            
