clearvars
close all
clc

% cluster
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\cluster\231004_Results_Cluster_KnK_Manuscript_All_clusterData2.mat')
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcBi_addRF.mat')
groups = 4;

% other groups
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh1_addRF_new_extended_sorted.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh2_addRF_new_extended_sorted.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcUni1_addRF_new_extended.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcUni2_addRF_new_extended.mat')
% groups = 1;
% idx = ones(1,size(AllAni,2));

clearvars -except AllAni groups idx

savename = {'contour_Cluster'};

%% temporal frequency (x, x2, x4, x8) and spatial frequency (y) vectors
x2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350]; x2 = x2 * 0.0889;
x4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; x4 = x4 * 0.0444;
x8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5 3375]; x8 = x8 * 0.0222;

x = [x8;x4;x2];
y = [0.0222 0.0222 0.0222 0.0222 0.0222 0.0222 0.0222 0.0222 0.0222 NaN; 0.0444 0.0444 0.0444 0.0444 0.0444 0.0444 0.0444 0.0444 0.0444 0.0444; 0.0889 0.0889 0.0889 0.0889 0.0889 0.0889 0.0889 0.0889 0.0889 0.0889];

%% baseline correction
width = [2 4 8];
for i = 1 : size(AllAni,2)
    for k = width
        for dir = 1 : 2
            if dir == 1
                dir2 = 'fw';
            else
                dir2 = 'bw';
            end
            if ~isempty(find(isnan(AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)])) == 1))
                AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)])(1:find(isnan(AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)])) == 1,1)-1) = ...
                    AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)])(1:find(isnan(AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)])) == 1,1)-1) ...
                    - AllAni(i).R01.background.rawmean.translation.(char(dir2)).(['w',num2str(k)])(1:find(isnan(AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)])) == 1,1)-1);
            else
                AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)]) = ...
                    AllAni(i).R01.yfreq.mean.translation.(char(dir2)).(['w',num2str(k)]) ...
                    - AllAni(i).R01.background.rawmean.translation.(char(dir2)).(['w',num2str(k)]);
            end
        end
    end
end

%% data normalization
for i = 1 : size(AllAni,2)
    maxval = max([AllAni(i).R01.yfreq.mean.translation.bw.w2 AllAni(i).R01.yfreq.mean.translation.bw.w4 AllAni(i).R01.yfreq.mean.translation.bw.w8 ...
        AllAni(i).R01.yfreq.mean.translation.fw.w2 AllAni(i).R01.yfreq.mean.translation.fw.w4 AllAni(i).R01.yfreq.mean.translation.fw.w8]);
    bgData.fw.w8(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w8/maxval;
    bgData.fw.w4(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w4/maxval;
    bgData.fw.w2(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w2/maxval;
    bgData.bw.w8(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w8/maxval;
    bgData.bw.w4(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w4/maxval;
    bgData.bw.w2(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w2/maxval;
end

% %% data normalization
% % wrong for inhexc? Neu machen, wie mit Keram besprochen
% bgVector(1:size(AllAni,2)) = NaN;
% 
% % data of all animals/units to matrix
% for i = 1 : size(AllAni,2)
%     dataMatrix.fw.w8(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w8;  
%     dataMatrix.fw.w4(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w4;  
%     dataMatrix.fw.w2(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w2;  
%     dataMatrix.bw.w8(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w8;  
%     dataMatrix.bw.w4(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w4;  
%     dataMatrix.bw.w2(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w2;  
%     
%     bgVector(i) = AllAni(i).R01.background.sum(1); % save baseline activity per unit for basleline correction
% end
% 
% for i = 1 : size(dataMatrix.fw.w8,1)
%     % baseline correction
%     bgData.fw.w8(i,:) = (dataMatrix.fw.w8(i,:)-bgVector(i))/(max(dataMatrix.fw.w8(i,:))-bgVector(i));
%     bgData.fw.w4(i,:) = (dataMatrix.fw.w4(i,:)-bgVector(i))/(max(dataMatrix.fw.w8(i,:))-bgVector(i));
%     bgData.fw.w2(i,:) = (dataMatrix.fw.w2(i,:)-bgVector(i))/(max(dataMatrix.fw.w8(i,:))-bgVector(i));
%     bgData.bw.w8(i,:) = (dataMatrix.bw.w8(i,:)-bgVector(i))/(max(dataMatrix.bw.w8(i,:))-bgVector(i));
%     bgData.bw.w4(i,:) = (dataMatrix.bw.w4(i,:)-bgVector(i))/(max(dataMatrix.bw.w8(i,:))-bgVector(i));
%     bgData.bw.w2(i,:) = (dataMatrix.bw.w2(i,:)-bgVector(i))/(max(dataMatrix.bw.w8(i,:))-bgVector(i));
% end

%% contour plots 
close all
for i = 1 : groups
    temp = [median(bgData.bw.w8(find(idx == i),:)); median(bgData.bw.w4(find(idx == i),:)); median(bgData.bw.w2(find(idx == i),:))]; % this is the median data for the contour plot
    figure
    contourf(x,y,temp) % x is temporal frequency, y is spatial frequency, temp is isoline/depth matrix
    ylim([0 .1])
    xlim([0.3122 120.015])
    set(gca,'XScale','log','YScale','log','XTick',[1 10 100],'XTickLabels',{'1','10','100'})
    view([90 -90]) 
    colorbar
    caxis([0 1]) % to level the colormap limits for all figures
    if groups == 4 %cluster
        print([char(savename),'_C',num2str(i),'_btf'],'-depsc','-r300','-tiff','-painters')
        savefig([char(savename),'_C',num2str(i),'_btf','.fig'])
    else
        print([char(savename),'_btf'],'-depsc','-r300','-tiff','-painters')
        savefig([char(savename),'_btf','.fig'])
    end
end

for i = 1 : groups
    temp = [median(bgData.fw.w8(find(idx == i),:)); median(bgData.fw.w4(find(idx == i),:)); median(bgData.fw.w2(find(idx == i),:))]; % this is the median data for the contour plot
    figure
    contourf(x,y,temp) % x is temporal frequency, y is spatial frequency, temp is isoline/depth matrix
    ylim([0 .1])
    xlim([0.3122 120.015])
    set(gca,'XScale','log','YScale','log','XTick',[1 10 100],'XTickLabels',{'1','10','100'})
    view([90 -90]) 
    colorbar
    caxis([0 1]) % to level the colormap limits for all figures
    if groups == 4 %cluster
        print([char(savename),'_C',num2str(i),'_ftb'],'-depsc','-r300','-tiff','-painters')
        savefig([char(savename),'_C',num2str(i),'_ftb','.fig'])
    else
        print([char(savename),'_ftb'],'-depsc','-r300','-tiff','-painters')
        savefig([char(savename),'_ftb','.fig'])
    end
end

