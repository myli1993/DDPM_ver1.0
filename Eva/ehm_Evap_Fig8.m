function ehm_Evap_Fig8
a=a(1:length(a)-mod(a,8),:);
a1=a(:,1);
% a2=a(:,2);
for i=1:length(a1)/8
    b1(:,i)=a1((i-1)*8+1:(i-1)*8+8,1);
%     b2(:,i)=a2((i-1)*8+1:(i-1)*8+8,1);
end
c1(:,1)=mean(b1,2);
% c2(:,1)=mean(b2,2);
c1(:,2)=std(b1')'/sqrt(8);
% c2(:,2)=std(b2')'/sqrt(8);
% d=[c1 c2];
