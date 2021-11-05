function ehm_Evap_print(result)
[~,R]=geotiffread('F:\文章\水文模型\data\1.2resample\dem_shimen_0.1.tif');
info = geotiffinfo('F:\文章\水文模型\data\1.2resample\dem_shimen_0.1.tif');
geoTags = info.GeoTIFFTags.GeoKeyDirectoryTag;
result_label={'result.Rsq','result.nse','result.rmse','result.mae'};
E_label={'E','Eb','Ei','Ep','Es','Et','Ew'};
for i=1:length(result_label)
    for j=1:length(E_label)
        eval(['x=',result_label{i},'.',E_label{j},';']);
        filename{i,j}=['F:\文章\水文模型\data\2.1evap\result\',result_label{i},'_',E_label{j},'.tif'];
        geotiffwrite(filename{i,j},x,R,'GeoKeyDirectoryTag',geoTags);
    end
end
    