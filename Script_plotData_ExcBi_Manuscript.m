clear
close all
clc
% cd \\132.187.28.171\home\Data\Analysis\matlab\scripts
cd \\132.187.28.171\home\rest\data\Analysis\matlab\scripts
% load 'Results_groups_manuscript2'
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\classification\Results_groups_manuscript.mat')
% load('230309_Results_KernellKMeans_FW_W8.mat') % updated data

% find units to plot
type = 'excbi';
AllAni = eval(type);
CIval = CI.(type); % although label is CI it also might be 2*sd of mean
UnitNum = size(AllAni,2);
a = 1; % to define number of subplots per row or column
b = 1; % to define number of subplots in other direction

% load('230628_Results_Cluster_KnK_Manuscript_All_clusterData.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\cluster\231004_Results_Cluster_KnK_Manuscript_All_clusterData2.mat')
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcBi_addRF_cluster.mat')
clear AllAni
AllAni = C4;
UnitNum = size(AllAni,2);
COL = 'g';

%% baseline correction
% for TC do baseline correction for heatmaps it is done right before
% plotting them, hence baseline correction here is not required
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

%% plot mean tuning curves
for i = 1 : size(AllAni,2)
    normVal = [AllAni(i).R01.yfreq.mean.translation.fw.w2 AllAni(i).R01.yfreq.mean.translation.fw.w4 AllAni(i).R01.yfreq.mean.translation.fw.w8 AllAni(i).R01.yfreq.mean.translation.bw.w2 AllAni(i).R01.yfreq.mean.translation.bw.w4 AllAni(i).R01.yfreq.mean.translation.bw.w8];
    TCmatrix.ftbW2(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w2/max(normVal);
    TCmatrix.ftbW4(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w4/max(normVal);
    TCmatrix.ftbW8(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w8/max(normVal);
    TCmatrix.btfW2(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w2/max(normVal);
    TCmatrix.btfW4(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w4/max(normVal);
    TCmatrix.btfW8(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w8/max(normVal);
end

x2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350]; x2 = x2 * 0.0889;
x4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; x4 = x4 * 0.0444;
x8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5 3375]; x8 = x8 * 0.0222;

figure % tr, fw, freq
subplot(1,2,1)
hold on
plot_distribution_prctile(x2, TCmatrix.ftbW2,'Color',[0.8 0.8 0.8],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(x4, TCmatrix.ftbW4,'Color',[0.5 0.5 0.5],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(x8, TCmatrix.ftbW8,'Color',[0.2 0.2 0.2],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
% set(gcf,'position',[1000 500 297 276])
set(gca,'XScale','log')
ylim([0 1])
title('ftb')
box on
axis square

% tr, bw, freq
subplot(1,2,2)
hold on
plot_distribution_prctile(x2, TCmatrix.btfW2,'Color',[0.8 0.8 0.8],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(x4, TCmatrix.btfW4,'Color',[0.5 0.5 0.5],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(x8, TCmatrix.btfW8,'Color',[0.2 0.2 0.2],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
set(gca,'XScale','log')
ylim([0 1])
title('btf')
box on 
axis square
set(gcf,'position',[50 450 600 300])

%% heatmap
load('colormapBlueRed.mat')
for i = 1 : size(AllAni,2)
    maxval = max([AllAni(i).R01.yfreq.mean.translation.fw.w2 AllAni(i).R01.yfreq.mean.translation.fw.w4 AllAni(i).R01.yfreq.mean.translation.fw.w8 AllAni(i).R01.yfreq.mean.translation.bw.w2 AllAni(i).R01.yfreq.mean.translation.bw.w4 AllAni(i).R01.yfreq.mean.translation.bw.w8]);
    normbg = AllAni(i).R01.background.sum(1)/maxval;
%     normbg = mean(maxval)/max(maxval);
%     maxval = max(maxval);
    normpeak.fw.w2(i,:) = (AllAni(i).R01.yfreq.mean.translation.fw.w2/maxval)-normbg;
    normpeak.fw.w4(i,:) = (AllAni(i).R01.yfreq.mean.translation.fw.w4/maxval)-normbg;
    normpeak.fw.w8(i,:) = (AllAni(i).R01.yfreq.mean.translation.fw.w8/maxval)-normbg;
    normpeak.bw.w2(i,:) = (AllAni(i).R01.yfreq.mean.translation.bw.w2/maxval)-normbg;
    normpeak.bw.w4(i,:) = (AllAni(i).R01.yfreq.mean.translation.bw.w4/maxval)-normbg;
    normpeak.bw.w8(i,:) = (AllAni(i).R01.yfreq.mean.translation.bw.w8/maxval)-normbg;
end

width = [2 4 8];
figure
for i = 1 : 6
    subplot(2,3,i)
    if i <=3
        heatmap(normpeak.fw.(['w',num2str(width(i))]))
    else
        heatmap(normpeak.bw.(['w',num2str(width(i-3))]))
    end
    set(gca,'colorLimits',[-1 1],'colormap', BlueRed)
    grid off
    set(gcf,'position',[600 350 900 415])
end

%% get PTF and FWHM
x = [.5 1 5 10 20 40 60 80 100 120];
for i = 1 : UnitNum
    if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w2,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
    else
        [AllAni(i).peaks.fw(1), AllAni(i).locs.fw(1), AllAni(i).width.fw(1), AllAni(i).prom.fw(1)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w2,x2,'Annotate','extents',NPeaks=1,SortStr='descend');
    end
    if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w4,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
    else
        [AllAni(i).peaks.fw(2), AllAni(i).locs.fw(2), AllAni(i).width.fw(2), AllAni(i).prom.fw(2)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w4,x4,'Annotate','extents',NPeaks=1,SortStr='descend');
    end
    [AllAni(i).peaks.fw(3), AllAni(i).locs.fw(3), AllAni(i).width.fw(3), AllAni(i).prom.fw(3)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w8,x8,'Annotate','extents',NPeaks=1,SortStr='descend');
    if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w2,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
    else
        [AllAni(i).peaks.bw(1), AllAni(i).locs.bw(1), AllAni(i).width.bw(1), AllAni(i).prom.bw(1)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w2,x2,'Annotate','extents',NPeaks=1,SortStr='descend');
    end
    if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w2,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
    else
        [AllAni(i).peaks.bw(2), AllAni(i).locs.bw(2), AllAni(i).width.bw(2), AllAni(i).prom.bw(2)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w4,x4,'Annotate','extents',NPeaks=1,SortStr='descend');
    end
    [AllAni(i).peaks.bw(3), AllAni(i).locs.bw(3), AllAni(i).width.bw(3), AllAni(i).prom.bw(3)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w8,x8,'Annotate','extents',NPeaks=1,SortStr='descend');
end

%% plot preferred temporal frequency
col = [.3 .3 .3];
limy = [0 120];

for i = 1 : size(AllAni,2)
    tempbw(i,1) = AllAni(i).locs.bw(1);
    tempbw(i,2) = AllAni(i).locs.bw(2);
    tempbw(i,3) = AllAni(i).locs.bw(3);
end

for i = 1 : size(AllAni,2)
    tempfw(i,1) = AllAni(i).locs.fw(1);
    tempfw(i,2) = AllAni(i).locs.fw(2);
    tempfw(i,3) = AllAni(i).locs.fw(3);
end

% boxplot
Boxplot_B(tempbw,3,20,[0.75 0.75 0.75; 0.75 0.75 0.75; 0.75 0.75 0.75],{'2','4','8'},{'2','4','8'})
hold on
x = ones(size(tempbw(:,1))).*(1+(rand(size(tempbw(:,1)))*4-2)/10);
scatter(x,tempbw(:,1),10,'filled','MarkerFaceColor',col)
x = ones(size(tempbw(:,2))).*(1+(rand(size(tempbw(:,2)))*4+8)/10);
scatter(x,tempbw(:,2),10,'filled','MarkerFaceColor',col)
x = ones(size(tempbw(:,3))).*(1+(rand(size(tempbw(:,3)))*4+18)/10);
scatter(x,tempbw(:,3),10,'filled','MarkerFaceColor',col)
xlabel('stripe width (# of rows)')
ylabel('preferred temporal frequency (Hz)')
set(gcf,'position',[100 50 260 335])
ylim(limy)
title('btf')

% boxplot
Boxplot_B(tempfw,3,20,[0.75 0.75 0.75; 0.75 0.75 0.75; 0.75 0.75 0.75],{'2','4','8'},{'2','4','8'})
hold on
x = ones(size(tempfw(:,1))).*(1+(rand(size(tempfw(:,1)))*4-2)/10);
scatter(x,tempfw(:,1),10,'filled','MarkerFaceColor',col)
x = ones(size(tempfw(:,2))).*(1+(rand(size(tempfw(:,2)))*4+8)/10);
scatter(x,tempfw(:,2),10,'filled','MarkerFaceColor',col)
x = ones(size(tempfw(:,3))).*(1+(rand(size(tempfw(:,3)))*4+18)/10);
scatter(x,tempfw(:,3),10,'filled','MarkerFaceColor',col)
xlabel('stripe width (# of rows)')
ylabel('preferred temporal frequency (Hz)')
set(gcf,'position',[350 50 260 335])
ylim(limy)
title('ftb')

PTF.bw = tempbw;
PTF.fw = tempfw;

%% plot PTF amplitude
col = [.3 .3 .3];
limy = [0 200];

for i = 1 : size(AllAni,2)
    tempbw(i,1) = AllAni(i).prom.bw(1);
    tempbw(i,2) = AllAni(i).prom.bw(2);
    tempbw(i,3) = AllAni(i).prom.bw(3);
end

for i = 1 : size(AllAni,2)
    tempfw(i,1) = AllAni(i).prom.fw(1);
    tempfw(i,2) = AllAni(i).prom.fw(2);
    tempfw(i,3) = AllAni(i).prom.fw(3);
end

AMPL.bw = tempbw;
AMPL.fw = tempfw;

%% plot FWHM
col = [.3 .3 .3];
limy = [0 100];

for i = 1 : size(AllAni,2)
    tempbw(i,1) = AllAni(i).width.bw(1);
    tempbw(i,2) = AllAni(i).width.bw(2);
    tempbw(i,3) = AllAni(i).width.bw(3);
end

for i = 1 : size(AllAni,2)
    tempfw(i,1) = AllAni(i).width.fw(1);
    tempfw(i,2) = AllAni(i).width.fw(2);
    tempfw(i,3) = AllAni(i).width.fw(3);
end

FWHM.bw = tempbw;
FWHM.fw = tempfw;

%% delay
limy = [0 200];
for i = 1 : size(AllAni,2)
    for j = 1 : 10 % temporal frequencies
        if ~isempty(find(AllAni(i).R01.times.translation.bw.w2{j}>0,1))
            AllAni(i).delay.bw(j,1) = AllAni(i).R01.times.translation.bw.w2{j}(find(AllAni(i).R01.times.translation.bw.w2{j}>0,1));
        end
        if ~isempty(find(AllAni(i).R01.times.translation.bw.w4{j}>0,1))
            AllAni(i).delay.bw(j,2) = AllAni(i).R01.times.translation.bw.w4{j}(find(AllAni(i).R01.times.translation.bw.w4{j}>0,1));
        end
        if ~isempty(find(AllAni(i).R01.times.translation.bw.w8{j}>0,1))
            AllAni(i).delay.bw(j,3) = AllAni(i).R01.times.translation.bw.w8{j}(find(AllAni(i).R01.times.translation.bw.w8{j}>0,1));
        end
        if ~isempty(find(AllAni(i).R01.times.translation.fw.w2{j}>0,1))
            AllAni(i).delay.fw(j,1) = AllAni(i).R01.times.translation.fw.w2{j}(find(AllAni(i).R01.times.translation.fw.w2{j}>0,1));
        end
        if ~isempty(find(AllAni(i).R01.times.translation.fw.w4{j}>0,1))
            AllAni(i).delay.fw(j,2) = AllAni(i).R01.times.translation.fw.w4{j}(find(AllAni(i).R01.times.translation.fw.w4{j}>0,1));
        end
        if ~isempty(find(AllAni(i).R01.times.translation.fw.w8{j}>0,1))
            AllAni(i).delay.fw(j,3) = AllAni(i).R01.times.translation.fw.w8{j}(find(AllAni(i).R01.times.translation.fw.w8{j}>0,1));
        end
    end
end

for i = 1 : size(AllAni,2)
    tempbw(i,:) = AllAni(i).delay.bw(4,:)*1000;
    tempfw(i,:) = AllAni(i).delay.fw(4,:)*1000;
end

DELAY.bw = tempbw;
DELAY.fw = tempfw;

%% corr of PTF and FWHM
col = COL;
figure(200)
hold on
subplot(2,4,1)
hold on
for i = 1 : size(AllAni,2)
    plot(AMPL.fw(i,3),FWHM.fw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('amplitude at PTF')
ylabel('FWHM')
title('amplitude delay ftb')
axis square

subplot(2,4,5)
hold on
for i = 1 : size(AllAni,2)
    plot(AMPL.bw(i,3),FWHM.bw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('amplitude at PTF')
ylabel('FWHM')
title('amplitude delay btf')
axis square

subplot(2,4,2)
hold on
for i = 1 : size(AllAni,2)
    plot(DELAY.fw(i,3),FWHM.fw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('delay')
ylabel('FWHM')
title('delay fwhm ftb')
axis square

subplot(2,4,6)
hold on
for i = 1 : size(AllAni,2)
    plot(DELAY.bw(i,3),FWHM.bw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('delay')
ylabel('FWHM')
title('delay fwhm btf')
axis square


subplot(2,4,3)
% daspect([1 1 1])
hold on
for i = 1 : size(AllAni,2)
    plot(PTF.fw(i,3),FWHM.fw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('PTF (Hz)')
ylabel('FWHM')
title('PTF fwhm ftb')
axis square

subplot(2,4,7)
hold on
for i = 1 : size(AllAni,2)
    plot(PTF.bw(i,3),FWHM.bw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('PTH (Hz)')
ylabel('FWHM')
title('PTF fwhm btf')
axis square


subplot(2,4,4)
% daspect([1 1 1])
hold on
for i = 1 : size(AllAni,2)
    plot(PTF.fw(i,3),DELAY.fw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('PTF (Hz)')
ylabel('delay')
title('PTF delay ftb')
axis square

subplot(2,4,8)
hold on
for i = 1 : size(AllAni,2)
    plot(PTF.bw(i,3),DELAY.bw(i,3),'o','LineWidth',1.2,'Color',col)
end
plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
set(gca,'Box','on')
xlim([0 120])
ylim([0 120])
xlabel('PTH (Hz)')
ylabel('delay')
title('PTF delay btf')
axis square
set(gcf,'position',[600 50 800 400])
