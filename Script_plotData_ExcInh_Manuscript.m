clearvars
close all
clc
type = 'excinh2';

switch type
    case 'excinh2'
%         load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\Results_ExcInh2_addRF_new_extended_sorted.mat')
        load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh2_addRF_new_extended_sorted.mat')
    case 'excinh1'
%         load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\Results_ExcInh1_addRF_new_extended_sorted.mat')
        load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh1_addRF_new_extended_sorted.mat')
end


UnitNum = size(AllAni,2);
a = 1; % to define number of subplots per row or column
b = 1; % to define number of subplots in other direction
COL = [.3 .3 .3];

x2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350]; x2 = x2 * 0.0889;
x4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; x4 = x4 * 0.0444;
x8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5]; x8 = x8 * 0.0222;
v2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350];
v4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; 
v8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5]; 

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

%% norm
% beacause max is potentially negative if first correccting for baseline
% and then norm, do it like that:
for i = 1 : size(AllAni,2)
    normVal = abs([AllAni(i).R01.yfreq.mean.translation.fw.w2 AllAni(i).R01.yfreq.mean.translation.fw.w4 AllAni(i).R01.yfreq.mean.translation.fw.w8 AllAni(i).R01.yfreq.mean.translation.bw.w2 AllAni(i).R01.yfreq.mean.translation.bw.w4 AllAni(i).R01.yfreq.mean.translation.bw.w8]);
    TCmatrix.ftbW2(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w2/max(normVal);
    TCmatrix.ftbW4(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w4/max(normVal);
    TCmatrix.ftbW8(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w8/max(normVal);
    TCmatrix.btfW2(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w2/max(normVal);
    TCmatrix.btfW4(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w4/max(normVal);
    TCmatrix.btfW8(i,:) = AllAni(i).R01.yfreq.mean.translation.bw.w8/max(normVal);
end

%% plot mean tuning curves
figure % tr, fw, freq
subplot(1,2,1)
hold on
plot([10^0.6 10^3.6],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2)
% plot([0 120],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2) % for ft
plot_distribution_prctile(v2, TCmatrix.ftbW2,'Color',[0.8 0.8 0.8],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(v4, TCmatrix.ftbW4,'Color',[0.5 0.5 0.5],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(v8, TCmatrix.ftbW8(:,1:end-1),'Color',[0.2 0.2 0.2],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
% set(gcf,'position',[1000 500 297 276])
set(gca,'XScale','log','xtick',[10^-1 10^0 10^1 10^2 10^3],'xticklabels',{'0.1','1','10','100','1000'})
% set(gca,'XScale','log','xtick',[1 10 100],'xticklabels',{'1','10','100'}) % for ft
ylim([-1 1])
xlim([10^0.6 10^3.6])
% xlim([0 120]) % for ft
title('ftb')
box on
axis square

% figure % tr, bw, freq
subplot(1,2,2)
hold on
plot([10^0.6 10^3.6],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2)
% plot([0 120],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2) % for ft
plot_distribution_prctile(v2, TCmatrix.btfW2,'Color',[0.8 0.8 0.8],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(v4, TCmatrix.btfW4,'Color',[0.5 0.5 0.5],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
plot_distribution_prctile(v8, TCmatrix.btfW8(:,1:end-1),'Color',[0.2 0.2 0.2],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
set(gca,'XScale','log','xtick',[10^-1 10^0 10^1 10^2 10^3],'xticklabels',{'0.1','1','10','100','1000'})
% set(gca,'XScale','log','xtick',[1 10 100],'xticklabels',{'1','10','100'}) % for ft
ylim([-1 1])
xlim([10^0.6 10^3.6])
% xlim([0 120]) % for ft
title('btf')
box on
axis square
set(gcf,'position',[50 450 600 300])

switch type
    case 'excinh2'
        print(['231004_Excinh2_TC'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh2_TC.fig'])
    case 'excinh1'
        print(['231004_Excinh1_TC'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh1_TC.fig'])
end

%% heatmap
TCmatrix.btfW8(:,10) = [];
TCmatrix.ftbW8(:,10) = [];
load('colormapBlueRed.mat')
for i = 1 : size(AllAni,2)
    maxval = max([AllAni(i).R01.yfreq.mean.translation.fw.w2 AllAni(i).R01.yfreq.mean.translation.fw.w4 AllAni(i).R01.yfreq.mean.translation.fw.w8 AllAni(i).R01.yfreq.mean.translation.bw.w2 AllAni(i).R01.yfreq.mean.translation.bw.w4 AllAni(i).R01.yfreq.mean.translation.bw.w8]);
    normbg = 0;%4AllAni(i).R01.background.sum(1)/maxval;
%     normbg = mean(maxval)/max(maxval);
%     maxval = max(maxval);
    normpeak.fw.w2(i,:) = (AllAni(i).R01.yfreq.mean.translation.fw.w2/maxval)-normbg;
    normpeak.fw.w4(i,:) = (AllAni(i).R01.yfreq.mean.translation.fw.w4/maxval)-normbg;
    normpeak.fw.w8(i,:) = (AllAni(i).R01.yfreq.mean.translation.fw.w8(:,1:end-1)/maxval)-normbg;
    normpeak.bw.w2(i,:) = (AllAni(i).R01.yfreq.mean.translation.bw.w2/maxval)-normbg;
    normpeak.bw.w4(i,:) = (AllAni(i).R01.yfreq.mean.translation.bw.w4/maxval)-normbg;
    normpeak.bw.w8(i,:) = (AllAni(i).R01.yfreq.mean.translation.bw.w8(:,1:end-1)/maxval)-normbg;
end

width = [2 4 8];
figure
for i = 1 : 6
    subplot(2,3,i)
    if i <=3
        heatmap(TCmatrix.(['ftbW',num2str(width(i))]))
    else
        heatmap(TCmatrix.(['btfW',num2str(width(i-3))]))
    end
    set(gca,'colorLimits',[-1 1],'colormap', BlueRed)
    grid off
    set(gcf,'position',[600 350 900 415])
end

switch type
    case 'excinh2'
        print(['231004_Excinh2_heatmap'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh2_heatmap.fig'])
    case 'excinh1'
        print(['231004_Excinh1_heatmap'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh1_heatmap.fig'])
end

figure
for i = 1 : 6
    subplot(2,3,i)
    if i <=3
        heatmap(median(TCmatrix.(['ftbW',num2str(width(i))])))
    else
        heatmap(median(TCmatrix.(['btfW',num2str(width(i-3))])))
    end
    set(gca,'colorLimits',[-1 1],'colormap', BlueRed)
    grid off
    set(gcf,'position',[600 350 900 66])
end

switch type
    case 'excinh2'
        print(['231004_Excinh2_heatmap_mean'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh2_heatmap_mean.fig'])
    case 'excinh1'
        print(['231004_Excinh1_heatmap_mean'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh1_heatmap_mean.fig'])
end


%% plot peak

freq = [0.5 1 5 10 20 40 60 80 100 120];
switch type
    case 'excinh2'
        for i = 1 : size(AllAni,2)
            temp = min(AllAni(i).R01.yfreq.mean.translation.bw.w2(2:end-1)); % inh
            amplPeak.bw.w2(i)  = temp(1);
            temp = v2(AllAni(i).R01.yfreq.mean.translation.bw.w2 == amplPeak.bw.w2(i));
            freqPeak.bw.w2(i) = median(temp);
            
            temp = min(AllAni(i).R01.yfreq.mean.translation.bw.w4(2:end-1)); % inh
            amplPeak.bw.w4(i) = temp(1);
            temp = v4(AllAni(i).R01.yfreq.mean.translation.bw.w4 == amplPeak.bw.w4(i));
            freqPeak.bw.w4(i) = median(temp);
            
            temp = min(AllAni(i).R01.yfreq.mean.translation.bw.w8(2:end-1)); % inh
            amplPeak.bw.w8(i) = temp(1);
            temp = v8(AllAni(i).R01.yfreq.mean.translation.bw.w8 == amplPeak.bw.w8(i));
            freqPeak.bw.w8(i) = median(temp);
            
            temp = max(AllAni(i).R01.yfreq.mean.translation.fw.w2(2:end-1)); % exc
            amplPeak.fw.w2(i) = temp(1);
            temp = v2(AllAni(i).R01.yfreq.mean.translation.fw.w2 == amplPeak.fw.w2(i));
            freqPeak.fw.w2(i) = median(temp);
            
            temp = max(AllAni(i).R01.yfreq.mean.translation.fw.w4(2:end-1)); % exc
            amplPeak.fw.w4(i) = temp(1);
            temp = v4(AllAni(i).R01.yfreq.mean.translation.fw.w4 == amplPeak.fw.w4(i));
            freqPeak.fw.w4(i) = median(temp);
            
            temp = max(AllAni(i).R01.yfreq.mean.translation.fw.w8(2:end-1)); % exc
            amplPeak.fw.w8(i) = temp(1);
            temp = v8(AllAni(i).R01.yfreq.mean.translation.fw.w8 == amplPeak.fw.w8(i));
            freqPeak.fw.w8(i) = median(temp);
        end
    case 'excinh1'
        for i = 1 : size(AllAni,2)
            temp = max(AllAni(i).R01.yfreq.mean.translation.bw.w2(2:end-1)); % inh
            amplPeak.bw.w2(i)  = temp(1);
            temp = v2(AllAni(i).R01.yfreq.mean.translation.bw.w2 == amplPeak.bw.w2(i));
            freqPeak.bw.w2(i) = median(temp);
            
            temp = max(AllAni(i).R01.yfreq.mean.translation.bw.w4(2:end-1)); % inh
            amplPeak.bw.w4(i) = temp(1);
            temp = v4(AllAni(i).R01.yfreq.mean.translation.bw.w4 == amplPeak.bw.w4(i));
            freqPeak.bw.w4(i) = median(temp);
            
            temp = max(AllAni(i).R01.yfreq.mean.translation.bw.w8(2:end-1)); % inh
            amplPeak.bw.w8(i) = temp(1);
            temp = v8(AllAni(i).R01.yfreq.mean.translation.bw.w8 == amplPeak.bw.w8(i));
            freqPeak.bw.w8(i) = median(temp);
            
            temp = min(AllAni(i).R01.yfreq.mean.translation.fw.w2(2:end-1)); % exc
            amplPeak.fw.w2(i) = temp(1);
            temp = v2(AllAni(i).R01.yfreq.mean.translation.fw.w2 == amplPeak.fw.w2(i));
            freqPeak.fw.w2(i) = median(temp);
            
            temp = min(AllAni(i).R01.yfreq.mean.translation.fw.w4(2:end-1)); % exc
            amplPeak.fw.w4(i) = temp(1);
            temp = v4(AllAni(i).R01.yfreq.mean.translation.fw.w4 == amplPeak.fw.w4(i));
            freqPeak.fw.w4(i) = median(temp);
            
            temp = min(AllAni(i).R01.yfreq.mean.translation.fw.w8(2:end-1)); % exc
            amplPeak.fw.w8(i) = temp(1);
            temp = v8(AllAni(i).R01.yfreq.mean.translation.fw.w8 == amplPeak.fw.w8(i));
            freqPeak.fw.w8(i) = median(temp);
        end
end
%% save inh and exc for plot
% for inh in bw dir units
w = [8 4 2];
switch type
    case 'excinh2'
        for i = 1 : 3
            temp_I(:,i) = freqPeak.bw.(['w',num2str(w(i))]); % inh
            temp_E(:,i) = freqPeak.fw.(['w',num2str(w(i))]); % exc
        end
    case 'excinh1'
        for i = 1 : 3
            temp_E(:,i) = freqPeak.bw.(['w',num2str(w(i))]); % inh
            temp_I(:,i) = freqPeak.fw.(['w',num2str(w(i))]); % exc
        end
end

%% plot
% plot Boxplot of peak values
col = [.3 .3 .3];
limy = [0 3000];

Boxplot_B(temp_I,3,20,[0.75 0.75 0.75; 0.75 0.75 0.75; 0.75 0.75 0.75],{'8','4','2'},{'8','4','2'}) % inh
hold on
x1 = ones(size(temp_I(:,1))).*(1+(rand(size(temp_I(:,1)))*4-2)/10);
scatter(x1,temp_I(:,1),10,'filled','MarkerFaceColor',col)
x2 = ones(size(temp_I(:,2))).*(1+(rand(size(temp_I(:,2)))*4+8)/10);
scatter(x2,temp_I(:,2),10,'filled','MarkerFaceColor',col)
x3 = ones(size(temp_I(:,3))).*(1+(rand(size(temp_I(:,3)))*4+18)/10);
scatter(x3,temp_I(:,3),10,'filled','MarkerFaceColor',col)
xlabel('stripe width (# of rows)')
ylabel('preferred temporal frequency (Hz)')
set(gcf,'position',[50 50 260 335])
ylim(limy)
title('inh')

switch type
    case 'excinh2'
        print(['231004_Excinh2_bp_inh'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh2_bp_inh.fig'])
    case 'excinh1'
        print(['231004_Excinh1_bp_inh'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh1_bp_inh.fig'])
end

Boxplot_B(temp_E,3,20,[0.75 0.75 0.75; 0.75 0.75 0.75; 0.75 0.75 0.75],{'8','4','2'},{'8','4','2'}) % exc
hold on
x1 = ones(size(temp_E(:,1))).*(1+(rand(size(temp_E(:,1)))*4-2)/10);
scatter(x1,temp_E(:,1),10,'filled','MarkerFaceColor',col)
x2 = ones(size(temp_E(:,2))).*(1+(rand(size(temp_E(:,2)))*4+8)/10);
scatter(x2,temp_E(:,2),10,'filled','MarkerFaceColor',col)
x3 = ones(size(temp_E(:,3))).*(1+(rand(size(temp_E(:,3)))*4+18)/10);
scatter(x3,temp_E(:,3),10,'filled','MarkerFaceColor',col)
xlabel('stripe width (# of rows)')
ylabel('preferred temporal frequency (Hz)')
set(gcf,'position',[350 50 260 335])
ylim(limy)
title('exc')

switch type
    case 'excinh2'
        print(['231004_Excinh2_bp_exc'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh2_bp_exc.fig'])
    case 'excinh1'
        print(['231004_Excinh1_bp_exc'],'-depsc','-r300','-tiff','-painters')
        savefig(['231004_ExcInh1_bp_exc.fig'])
end


%% stats
[statsE,~,stats] = friedman(temp_E);% close;
resultsE = multcompare(stats,'CType','bonferroni'); close; 
[statsI,~,stats] = friedman(temp_I);% close; 
resultsI = multcompare(stats,'CType','bonferroni'); close; 

for i = 1 : 3
    for j = 1 : 3
        statsPE(i,j) = signrank(temp_E(:,i),temp_E(:,j));
        statsPI(i,j) = signrank(temp_I(:,i),temp_I(:,j));
    end
end

pnew = [0.05/21 0.01/21 0.001/21];

switch type
    case 'excinh2'
        save ExcInh2_BP_stats.mat statsE statsI resultsE resultsI statsPE statsPI
    case 'excinh1'
        save ExcInh1_BP_stats.mat statsE statsI resultsE resultsI statsPE statsPI
end
%%
% % plot I and E as LP beneath each other
% for i = 1 : size(AllAni,2)
%     temp_IE(i,1) = temp_I(i,1); % inh w2
%     temp_IE(i,2) = temp_E(i,1); % exc w2
%     temp_IE(i,3) = temp_I(i,2); % inh w4
%     temp_IE(i,4) = temp_E(i,2); % exc w4
%     temp_IE(i,5) = temp_I(i,3); % inh w8
%     temp_IE(i,6) = temp_E(i,3); % exc w8
% end
% 
% Boxplot_B(temp_IE,6,15,[0.75 0.75 0.75; 0.5 0.5 0.5; 0.75 0.75 0.75; 0.5 0.5 0.5; 0.75 0.75 0.75; 0.5 0.5 0.5],{'inh 2','exc 2','inh 4','exc 4','inh 8','exc 8'},{'2','4','8','2','4','8'}) % exc
% hold on
% x1 = ones(size(temp_IE(:,1))).*(1+(rand(size(temp_IE(:,1)))*4-2)/10);
% scatter(x1,temp_IE(:,1),10,'k','filled')
% x2 = ones(size(temp_IE(:,2))).*(1+(rand(size(temp_IE(:,2)))*4+8)/10);
% scatter(x2,temp_IE(:,2),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i)],[temp_IE(i,1) temp_IE(i,2)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% x1 = ones(size(temp_IE(:,3))).*(1+(rand(size(temp_IE(:,3)))*4+18)/10);
% scatter(x1,temp_IE(:,3),10,'k','filled')
% x2 = ones(size(temp_IE(:,4))).*(1+(rand(size(temp_IE(:,4)))*4+28)/10);
% scatter(x2,temp_IE(:,4),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i)],[temp_IE(i,3) temp_IE(i,4)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% x1 = ones(size(temp_IE(:,5))).*(1+(rand(size(temp_IE(:,5)))*4+38)/10);
% scatter(x1,temp_IE(:,5),10,'k','filled')
% x2 = ones(size(temp_IE(:,6))).*(1+(rand(size(temp_IE(:,6)))*4+48)/10);
% scatter(x2,temp_IE(:,6),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i)],[temp_IE(i,5) temp_IE(i,6)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% xlabel('stripe width (# of rows)')
% ylabel('preferred TF (s-1)')
% set(gcf,'position',[100 200 575 463])
% ylim([0 120])



%% ampl of peak
% % find peak amplitude values
% 
% % plot Boxplot of peak values
% w = [2 4 8];
% for i = 1 : 3
%     temp_I(:,i) = amplPeak.bw.(['w',num2str(w(i))]); % inh
%     temp_E(:,i) = amplPeak.fw.(['w',num2str(w(i))]); % exc
% end
% 
% Boxplot_B(temp_I,3,20,[0.75 0.75 0.75; 0.75 0.75 0.75; 0.75 0.75 0.75],{'2','4','8'},{'2','4','8'}) % inh
% hold on
% x1 = ones(size(temp_I(:,1))).*(1+(rand(size(temp_I(:,1)))*4-2)/10);
% scatter(x1,temp_I(:,1),10,'k','filled')
% x2 = ones(size(temp_I(:,2))).*(1+(rand(size(temp_I(:,2)))*4+8)/10);
% scatter(x2,temp_I(:,2),10,'k','filled')
% x3 = ones(size(temp_I(:,3))).*(1+(rand(size(temp_I(:,3)))*4+18)/10);
% scatter(x3,temp_I(:,3),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i) x3(i)],[temp_I(i,1) temp_I(i,2) temp_I(i,3)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% xlabel('stripe width (# of rows)')
% ylabel('ampl at preferred TF (s-1)')
% set(gcf,'position',[512 122 300 361])
% ylim([0 40])
% 
% Boxplot_B(temp_E,3,20,[0.5 0.5 0.5; 0.5 0.5 0.5; 0.5 0.5 0.5],{'2','4','8'},{'2','4','8'}) % exc
% hold on
% x1 = ones(size(temp_E(:,1))).*(1+(rand(size(temp_E(:,1)))*4-2)/10);
% scatter(x1,temp_E(:,1),10,'k','filled')
% x2 = ones(size(temp_E(:,2))).*(1+(rand(size(temp_E(:,2)))*4+8)/10);
% scatter(x2,temp_E(:,2),10,'k','filled')
% x3 = ones(size(temp_E(:,3))).*(1+(rand(size(temp_E(:,3)))*4+18)/10);
% scatter(x3,temp_E(:,3),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i) x3(i)],[temp_E(i,1) temp_E(i,2) temp_E(i,3)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% xlabel('stripe width (# of rows)')
% ylabel('ampl at preferred TF (s-1)')
% set(gcf,'position',[512 122 300 361])
% ylim([0 80])
% 
% % plot I and E as LP beneath each other
% for i = 1 : size(AllAni,2)
%     temp_IE(i,1) = temp_I(i,1); % inh w2
%     temp_IE(i,2) = temp_E(i,1); % exc w2
%     temp_IE(i,3) = temp_I(i,2); % inh w4
%     temp_IE(i,4) = temp_E(i,2); % exc w4
%     temp_IE(i,5) = temp_I(i,3); % inh w8
%     temp_IE(i,6) = temp_E(i,3); % exc w8
% end
% 
% Boxplot_B(temp_IE,6,15,[0.75 0.75 0.75; 0.5 0.5 0.5; 0.75 0.75 0.75; 0.5 0.5 0.5; 0.75 0.75 0.75; 0.5 0.5 0.5],{'inh 2','exc 2','inh 4','exc 4','inh 8','exc 8'},{'2','4','8','2','4','8'}) % exc
% hold on
% x1 = ones(size(temp_IE(:,1))).*(1+(rand(size(temp_IE(:,1)))*4-2)/10);
% scatter(x1,temp_IE(:,1),10,'k','filled')
% x2 = ones(size(temp_IE(:,2))).*(1+(rand(size(temp_IE(:,2)))*4+8)/10);
% scatter(x2,temp_IE(:,2),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i)],[temp_IE(i,1) temp_IE(i,2)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% x1 = ones(size(temp_IE(:,3))).*(1+(rand(size(temp_IE(:,3)))*4+18)/10);
% scatter(x1,temp_IE(:,3),10,'k','filled')
% x2 = ones(size(temp_IE(:,4))).*(1+(rand(size(temp_IE(:,4)))*4+28)/10);
% scatter(x2,temp_IE(:,4),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i)],[temp_IE(i,3) temp_IE(i,4)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% x1 = ones(size(temp_IE(:,5))).*(1+(rand(size(temp_IE(:,5)))*4+38)/10);
% scatter(x1,temp_IE(:,5),10,'k','filled')
% x2 = ones(size(temp_IE(:,6))).*(1+(rand(size(temp_IE(:,6)))*4+48)/10);
% scatter(x2,temp_IE(:,6),10,'k','filled')
% % for i = 1 : size(AllAni,2)
% %     plot([x1(i) x2(i)],[temp_IE(i,5) temp_IE(i,6)],'-','Color',[0.75 0.75 0.75],'LineWidth',1)
% % end
% xlabel('stripe width (# of rows)')
% ylabel('ampl at preferred TF (s-1)')
% set(gcf,'position',[100 200 575 463])
% ylim([0 120])

%% get PTF and FWHM
% x = [.5 1 5 10 20 40 60 80 100 120];
% for i = 1 : UnitNum
%     if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w2,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
%     else
%         [AllAni(i).peaks.fw(1), AllAni(i).locs.fw(1), AllAni(i).width.fw(1), AllAni(i).prom.fw(1)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w2,x,'Annotate','extents',NPeaks=1,SortStr='descend');
%     end
%     if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w4,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
%     else
%         [AllAni(i).peaks.fw(2), AllAni(i).locs.fw(2), AllAni(i).width.fw(2), AllAni(i).prom.fw(2)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w4,x,'Annotate','extents',NPeaks=1,SortStr='descend');
%     end
%     [AllAni(i).peaks.fw(3), AllAni(i).locs.fw(3), AllAni(i).width.fw(3), AllAni(i).prom.fw(3)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.fw.w8,x,'Annotate','extents',NPeaks=1,SortStr='descend');
%     if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w2,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
%     else
%         [AllAni(i).peaks.bw(1), AllAni(i).locs.bw(1), AllAni(i).width.bw(1), AllAni(i).prom.bw(1)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w2,x,'Annotate','extents',NPeaks=1,SortStr='descend');
%     end
%     if isempty(findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w4,x,'Annotate','extents',NPeaks=1,SortStr='descend'))
%     else
%         [AllAni(i).peaks.bw(2), AllAni(i).locs.bw(2), AllAni(i).width.bw(2), AllAni(i).prom.bw(2)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w4,x,'Annotate','extents',NPeaks=1,SortStr='descend');
%     end
%     [AllAni(i).peaks.bw(3), AllAni(i).locs.bw(3), AllAni(i).width.bw(3), AllAni(i).prom.bw(3)] = findpeaks(AllAni(i).R01.yfreq.mean.translation.bw.w8,x,'Annotate','extents',NPeaks=1,SortStr='descend');
% end
% 
% col = [.3 .3 .3];
% limy = [0 120];
% 
% 
% switch type
%     case 'excinh2'
%         for i = 1 : size(AllAni,2)
%             tempbw(i,1) = temp_I(i,1);
%             tempbw(i,2) = temp_I(i,2);
%             tempbw(i,3) = temp_I(i,3);
%         end
%         for i = 1 : size(AllAni,2)
%             tempfw(i,1) = temp_E(i,1);
%             tempfw(i,2) = temp_E(i,2);
%             tempfw(i,3) = temp_E(i,3);
%         end
%     case 'excinh1'
%         for i = 1 : size(AllAni,2)
%             tempbw(i,1) = temp_E(i,1);
%             tempbw(i,2) = temp_E(i,2);
%             tempbw(i,3) = temp_E(i,3);
%         end
%         for i = 1 : size(AllAni,2)
%             tempfw(i,1) = temp_I(i,1);
%             tempfw(i,2) = temp_I(i,2);
%             tempfw(i,3) = temp_I(i,3);
%         end
% end
% 
% PTF.bw = tempbw;
% PTF.fw = tempfw;
% 
% % amplitude
% for i = 1 : size(AllAni,2)
%     tempbw(i,1) = AllAni(i).prom.bw(1);
%     tempbw(i,2) = AllAni(i).prom.bw(2);
%     tempbw(i,3) = AllAni(i).prom.bw(3);
% end
% 
% for i = 1 : size(AllAni,2)
%     tempfw(i,1) = AllAni(i).prom.fw(1);
%     tempfw(i,2) = AllAni(i).prom.fw(2);
%     tempfw(i,3) = AllAni(i).prom.fw(3);
% end
% AMPL.bw = tempbw;
% AMPL.fw = tempfw;
% 
% % FWHM
% for i = 1 : size(AllAni,2)
%     tempbw(i,1) = AllAni(i).width.bw(1);
%     tempbw(i,2) = AllAni(i).width.bw(2);
%     tempbw(i,3) = AllAni(i).width.bw(3);
% end
% 
% for i = 1 : size(AllAni,2)
%     tempfw(i,1) = AllAni(i).width.fw(1);
%     tempfw(i,2) = AllAni(i).width.fw(2);
%     tempfw(i,3) = AllAni(i).width.fw(3);
% end
% 
% FWHM.bw = tempbw;
% FWHM.fw = tempfw;
% 
% % delay
% limy = [0 200];
% for i = 1 : size(AllAni,2)
%     for j = 1 : 10 % temporal frequencies
%         if ~isempty(find(AllAni(i).R01.times.translation.bw.w2{j}>0,1))
%             AllAni(i).delay.bw(j,1) = AllAni(i).R01.times.translation.bw.w2{j}(find(AllAni(i).R01.times.translation.bw.w2{j}>0,1));
%         end
%         if ~isempty(find(AllAni(i).R01.times.translation.bw.w4{j}>0,1))
%             AllAni(i).delay.bw(j,2) = AllAni(i).R01.times.translation.bw.w4{j}(find(AllAni(i).R01.times.translation.bw.w4{j}>0,1));
%         end
%         if ~isempty(find(AllAni(i).R01.times.translation.bw.w8{j}>0,1))
%             AllAni(i).delay.bw(j,3) = AllAni(i).R01.times.translation.bw.w8{j}(find(AllAni(i).R01.times.translation.bw.w8{j}>0,1));
%         end
%         if ~isempty(find(AllAni(i).R01.times.translation.fw.w2{j}>0,1))
%             AllAni(i).delay.fw(j,1) = AllAni(i).R01.times.translation.fw.w2{j}(find(AllAni(i).R01.times.translation.fw.w2{j}>0,1));
%         end
%         if ~isempty(find(AllAni(i).R01.times.translation.fw.w4{j}>0,1))
%             AllAni(i).delay.fw(j,2) = AllAni(i).R01.times.translation.fw.w4{j}(find(AllAni(i).R01.times.translation.fw.w4{j}>0,1));
%         end
%         if ~isempty(find(AllAni(i).R01.times.translation.fw.w8{j}>0,1))
%             AllAni(i).delay.fw(j,3) = AllAni(i).R01.times.translation.fw.w8{j}(find(AllAni(i).R01.times.translation.fw.w8{j}>0,1));
%         end
%     end
% end
% 
% for i = 1 : size(AllAni,2)
%     tempbw(i,:) = AllAni(i).delay.bw(4,:)*1000;
%     tempfw(i,:) = AllAni(i).delay.fw(4,:)*1000;
% end
% 
% DELAY.bw = tempbw;
% DELAY.fw = tempfw;

%% corr of PTF and FWHM
% figure(200)
% col = COL;
% subplot(2,4,1)
% hold on
% for i = 1 : size(AllAni,2)
%     plot(AMPL.fw(i,3),FWHM.fw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('amplitude at PTF')
% ylabel('FWHM')
% title('amplitude delay ftb')
% axis square
% 
% subplot(2,4,5)
% hold on
% for i = 1 : size(AllAni,2)
%     plot(AMPL.bw(i,3),FWHM.bw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('amplitude at PTF')
% ylabel('FWHM')
% title('amplitude delay btf')
% axis square
% 
% 
% % figure
% subplot(2,4,2)
% hold on
% for i = 1 : size(AllAni,2)
%     plot(DELAY.fw(i,3),FWHM.fw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('delay')
% ylabel('FWHM')
% title('delay fwhm ftb')
% axis square
% 
% subplot(2,4,6)
% hold on
% for i = 1 : size(AllAni,2)
%     plot(DELAY.bw(i,3),FWHM.bw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('delay')
% ylabel('FWHM')
% title('delay fwhm btf')
% axis square
% 
% 
% subplot(2,4,3)
% % daspect([1 1 1])
% hold on
% for i = 1 : size(AllAni,2)
%     plot(PTF.fw(i,3),FWHM.fw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('PTF (Hz)')
% ylabel('FWHM')
% title('PTF fwhm ftb')
% axis square
% 
% subplot(2,4,7)
% hold on
% for i = 1 : size(AllAni,2)
%     plot(PTF.bw(i,3),FWHM.bw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('PTH (Hz)')
% ylabel('FWHM')
% title('PTF fwhm btf')
% axis square
% 
% 
% subplot(2,4,4)
% % daspect([1 1 1])
% hold on
% for i = 1 : size(AllAni,2)
%     plot(PTF.fw(i,3),DELAY.fw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('PTF (Hz)')
% ylabel('delay')
% title('PTF delay ftb')
% axis square
% 
% subplot(2,4,8)
% hold on
% for i = 1 : size(AllAni,2)
%     plot(PTF.bw(i,3),DELAY.bw(i,3),'o','LineWidth',1.2,'Color',col)
% end
% plot([0 120],[0 120],'--','Color',[.7 .7 .7 .5],'LineWidth',1.2)
% set(gca,'Box','on')
% xlim([0 120])
% ylim([0 120])
% xlabel('PTH (Hz)')
% ylabel('delay')
% title('PTF delay btf')
% axis square
% set(gcf,'position',[600 50 800 400])
