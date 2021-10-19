function ehm_river_break_print(A,Rbreak,Rbreak_month,river_width,LAI)
break01=zeros(size(A,1),size(A,2));
break02=zeros(size(A,1),size(A,2));
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            if river_width(i,j)>2
                break01(i,j,1)=mean(Rbreak{i,j}(:,4))*8*12+0.001;
                break01(i,j,2)=min(min(corrcoef(Rbreak_month{i,j}(1:size(LAI{i,j},1),3),LAI{i,j}(:,3))))+0.001;
            else
                break02(i,j,1)=mean(Rbreak{i,j}(:,4))*8*12+0.001;
                break02(i,j,2)=min(min(corrcoef(Rbreak_month{i,j}(1:size(LAI{i,j},1),3),LAI{i,j}(:,3))))+0.001;
            end
        end
    end
end
[~,R]=geotiffread('F:\文章\水文模型\I-Eva module\data\1.2resample\dem_shimen_0.1.tif');
info = geotiffinfo('F:\文章\水文模型\I-Eva module\data\1.2resample\dem_shimen_0.1.tif');
geoTags = info.GeoTIFFTags.GeoKeyDirectoryTag;
geotiffwrite('F:\文章\水文模型\II-Flow module\data\gis\break_main1.tif',break01(:,:,1),R,'GeoKeyDirectoryTag',geoTags);
geotiffwrite('F:\文章\水文模型\II-Flow module\data\gis\break_main2.tif',break01(:,:,2),R,'GeoKeyDirectoryTag',geoTags);
geotiffwrite('F:\文章\水文模型\II-Flow module\data\gis\break_nonmain1.tif',break02(:,:,1),R,'GeoKeyDirectoryTag',geoTags);
geotiffwrite('F:\文章\水文模型\II-Flow module\data\gis\break_nonmain2.tif',break02(:,:,2),R,'GeoKeyDirectoryTag',geoTags);


