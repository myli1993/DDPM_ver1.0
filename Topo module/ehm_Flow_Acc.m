function [Flow_acc,Flow_dir]=ehm_Flow_Acc(A,Flow_dir1,outlet)
% Flow_dir1=Flow_dir;
%|7|8|1|
%|6|0|2|
%|5|4|3|

for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            if Flow_dir1(i,j)==0
                Flow_acc(i,j)=0;
            else
                xy=[];ia=[];ic=[];sqr=[];
                dir=Flow_dir1(i,j);
                index_acc=0;
                xy(1,1)=i;xy(1,2)=j;
                while dir~=0
                    [xy(index_acc+2,1),xy(index_acc+2,2)]=ehm_dir2acc(dir,xy(index_acc+1,1),xy(index_acc+1,2));
                    dir=Flow_dir1(xy(index_acc+2,1),xy(index_acc+2,2));
                    [~,ia,ic] = unique(xy,'rows','stable');
                    index_acc=size(ic,1)-1;
                    if ~isequal(ia,ic)
                        x=xy(end,1);y=xy(end,2);
                        if outlet(1)<x && outlet(2)<y
                            Flow_dir1(x,y)=7;
                        elseif outlet(1)==x && outlet(2)<y
                            Flow_dir1(x,y)=8;
                        elseif outlet(1)<x && outlet(2)==y
                            Flow_dir1(x,y)=6;
                        elseif outlet(1)<x && outlet(2)>y
                            Flow_dir1(x,y)=1;
                        elseif outlet(1)==x && outlet(2)>y
                            Flow_dir1(x,y)=2;
                        elseif outlet(1)>x && outlet(2)==y
                            Flow_dir1(x,y)=4;
                        elseif outlet(1)>x && outlet(2)<y
                            Flow_dir1(x,y)=5;
                        elseif outlet(1)>x && outlet(2)>y
                            Flow_dir1(x,y)=3;
                        end
                        sqr=find(ic(end)==ic);
                        index_acc=size(ic,1)-1-abs(sqr(2)-sqr(1));
                        xy=xy(1:index_acc+1,:);
                    end
                end
                Flow_acc(i,j)=index_acc;
            end
        else
            Flow_acc(i,j)=-32768;
        end
    end
end
Flow_dir=Flow_dir1;


