%% plot temporal dynamics
clear
close all

% if for cluster group load data like this
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcBi_addRF_cluster.mat')
% cluster = 'C4';
% AllAni = eval(cluster);

% if any other group simply load data
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh2_addRF_new_extended_sorted.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcUni2_addRF_new_extended.mat')
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcUni1_addRF_new_extended.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_InhUni1_addRF.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_InhBi_addRF.mat')
savename = {'ExcUni1'};

% set vars
ex = 20;
dir = 'bw';
type = 'translation';
rep = 1;
x = [0.5 1 5 10 20 40 60 80 100 120];
binnum1 = 300;
binnum = 300;%1500; % # bins for histogram (15s || 1500 = 10ms; 750 = 20ms; 300 = 50ms; 150 = 100ms)

%% hist indi and mean for one example
clear histBins
l = 1;
figure
d = designfilt('lowpassiir','FilterOrder',1,'HalfPowerFrequency',0.15,'DesignMethod','butter');
for j = 1 : size(AllAni,2)
    temp2 = AllAni(j).R01.times.(char(type)).(char(dir)).w8{rep,find(x == ex)}'; 
    histData = histogram(temp2,binnum1,'FaceColor','k','EdgeColor',[1 1 1],'BinLimits',[-5 10],'FaceAlpha',0.2,'Visible','off');
    histBins(j,:) = filtfilt(d,histData.Values/max(histData.Values));    
    histBins(j,:) = histData.Values/max(histData.Values);
    histTimes{j} = histData.Data;
    inst{j} = 1./diff(histTimes{j});
end
histEdge2 = histData.BinEdges;
close

% plot with shaded area
figure
xlabel('time (s)')
set(gca,'Box','on')
hold on     
patch([0 5 5 0], [0 0, 1 1], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
y = nanmean(histBins); % your mean vector;
std_dev = nanstd(histBins);
x = histEdge2(2:end)-mean(diff(histEdge2))/2;
patch([x fliplr(x)], [y-std_dev  fliplr(y+std_dev)], [0.6  0.6  0.6],'EdgeColor','none','FaceAlpha',.5)
hold on;
plot(x,y,'Color',[0.2 0.2 0.2],'LineWidth',1.5);
set(gcf,'position',[530 440 445 240])
xlim([-1 6])
ylim([0 1])
 
print(['231004_temporal_inhbi_',num2str(ex),'_8_',num2str(dir)],'-depsc','-r300','-tiff','-painters')
savefig(['231004_temporal_inhbi_',num2str(ex),'_8_',num2str(dir),'.fig'])

%% hist mean
x = [0.5 1 5 10 20 40 60 80 100 120];
clear histBins
figure
for j = 1 : size(AllAni,2)
    for i = 1 : 10 % all velocities
        maxval = max([AllAni(j).R01.times.translation.bw.w8{rep,find(x == ex)}' AllAni(j).R01.times.translation.fw.w8{rep,find(x == ex)}']);
        temp = AllAni(j).R01.times.(char(type)).(char(dir)).w8{rep,i}'; 
        histData = histogram(temp,binnum,'FaceColor','k','EdgeColor',[1 1 1],'BinLimits',[-5 10],'FaceAlpha',0.2,'Visible','off');
        histBins{i}(j,:) = smooth(histData.Values,4);
        yval{i}(j,:) = histBins{i}(j,:)/max(histBins{i}(j,:));
        tempbg = [temp(find(temp < 0)) temp(find(temp > 5))];
        bghist = histogram(tempbg,binnum,'FaceColor','k','EdgeColor',[1 1 1],'BinLimits',[-5 10],'FaceAlpha',0.2,'Visible','off');
        bg{i}(j,:) = smooth(bghist.Values(1:binnum/3),4);
        histBinsHeat{i}(j,:) = (histBins{i}(j,:))./maxval-(mean(bg{i}(j,:))/maxval); 
    end
end
histEdge = bghist.BinEdges;
close
figure
hold on     
patch([0 5 5 0], [0 0, 2 2], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
for i = 1 : 10
    plot(histEdge(2:end)-mean(diff(histEdge))/2, mean(histBins{i}),'Color',[0.2*(i/2)-0.1 0.2*(i/2)-0.1 0.2*(i/2)-0.1],'LineWidth',1.5)
end
xlabel('time (s)')
set(gca,'Box','on')
set(gcf,'position',[530 440 445 240])
xlim([-1 6])
%% heatmap
x = [0.5 1 5 10 20 40 60 80 100 120];
figure
load('colormapBlueRed.mat')
heatmap(histBinsHeat{find(x == ex)}(:,binnum/3-((binnum/3)/5)*1:(binnum/3)*2+((binnum/3)/5)*1))
set(gca,'colorLimits',[-1 1],'colormap', BlueRed)
grid off
set(gcf,'position',[1000 200 300 200])

print(['231004_temporal_heat_inhbi_',num2str(ex),'_8_',num2str(dir)],'-depsc','-r300','-tiff','-painters')
savefig(['231004_temporal_heat_inhbi_',num2str(ex),'_8_',num2str(dir),'.fig'])

%% mean TC
x2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350]; x2 = x2 * 0.0889;
x4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; x4 = x4 * 0.0444;
x8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5 NaN]; x8 = x8 * 0.0222;
v2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350];
v4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; 
v8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5 NaN]; 


figure
wid = [2 4 8];
for k = wid
    for j = 1 : size(AllAni,2)
        for i = 1 : 10 % all velocities
            temp = AllAni(j).R01.times.translation.fw.(char(['w',num2str(k)])){rep,i}';
            matrixBftb.(char(['w',num2str(k)]))(j,i) = length(find(temp > 0 & temp < 0.5))/0.5;
            matrixAftb.(char(['w',num2str(k)]))(j,i) = length(find(temp > 0 & temp < 5))/5;
            temp = AllAni(j).R01.times.translation.bw.w8{rep,i}';
            matrixBbtf.(char(['w',num2str(k)]))(j,i) = length(find(temp > 0 & temp < 0.5))/0.5;
            matrixAbtf.(char(['w',num2str(k)]))(j,i) = length(find(temp > 0 & temp < 5))/5;
        end
    end

    % baseline correction
    for i = 1 : size(AllAni,2)
        matrixAbtf.(char(['w',num2str(k)]))(i,:) = matrixAbtf.(char(['w',num2str(k)]))(i,:) - AllAni(i).R01.background.rawmean.translation.bw.(['w',num2str(k)]);
        matrixAftb.(char(['w',num2str(k)]))(i,:) = matrixAftb.(char(['w',num2str(k)]))(i,:) - AllAni(i).R01.background.rawmean.translation.fw.(['w',num2str(k)]);
        matrixBbtf.(char(['w',num2str(k)]))(i,:) = matrixBbtf.(char(['w',num2str(k)]))(i,:) - AllAni(i).R01.background.rawmean.translation.bw.(['w',num2str(k)]);
        matrixBftb.(char(['w',num2str(k)]))(i,:) = matrixBftb.(char(['w',num2str(k)]))(i,:) - AllAni(i).R01.background.rawmean.translation.fw.(['w',num2str(k)]);
    end
end

for k = wid    
    % PROBLEM: norm per wid, but I need it over all wid
    % normalization
    for i = 1 : size(matrixAftb.w2,1)
        maxvalA = max([matrixAftb.w2(i,:) matrixAbtf.w2(i,:) matrixAftb.w4(i,:) matrixAbtf.w4(i,:) matrixAftb.w8(i,:) matrixAbtf.w8(i,:)]);
        maxvalB = max([matrixBftb.w2(i,:) matrixBbtf.w2(i,:) matrixBftb.w4(i,:) matrixBbtf.w4(i,:) matrixBftb.w8(i,:) matrixBbtf.w8(i,:)]);
        maxvalC = max([matrixBftb.w2(i,:) matrixBbtf.w2(i,:) matrixAftb.w2(i,:) matrixAbtf.w2(i,:) ...
            matrixBftb.w4(i,:) matrixBbtf.w4(i,:) matrixAftb.w4(i,:) matrixAbtf.w4(i,:) ...
            matrixBftb.w8(i,:) matrixBbtf.w8(i,:) matrixAftb.w8(i,:) matrixAbtf.w8(i,:)]);
        matrixAftb.(char(['w',num2str(k)]))(i,:) = matrixAftb.(char(['w',num2str(k)]))(i,:)/maxvalA;
        matrixAbtf.(char(['w',num2str(k)]))(i,:) = matrixAbtf.(char(['w',num2str(k)]))(i,:)/maxvalA;
        matrixBftb.(char(['w',num2str(k)]))(i,:) = matrixBftb.(char(['w',num2str(k)]))(i,:)/maxvalA;
        matrixBbtf.(char(['w',num2str(k)]))(i,:) = matrixBbtf.(char(['w',num2str(k)]))(i,:)/maxvalA;
    end


    hold on
    % plot(x,median(matrixBbtf),'-')
    % plot(x,median(matrixAbtf),'--')
    % plot(x,median(matrixBftb),'-')
    % plot(x,median(matrixAftb),'--')
    subplot(1,2,1)
    hold on
    plot([10^0.6 10^3.6],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2)
%     plot([0 120],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2) % fot ft
    plot_distribution_prctile(eval((char(['v',num2str(k)]))),matrixBftb.(char(['w',num2str(k)])),'Color',[0.1*(k/2) 0.1*(k/2) 0.1*(k/2)],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
    title ftb
    ylim([-.2 1])
    xlim([10^0.6 10^3.6])
%     xlim([0 140]) % for ft
    set(gca,'XScale','log','xtick',[10^-1 10^0 10^1 10^2 10^3],'xticklabels',{'0.1','1','10','100','1000'})
%     set(gca,'XScale','log','xtick',[0 10 100],'xticklabels',{'0','10','100'}) % for ft
    box on
    axis square
    subplot(1,2,2)
    hold on
    plot([10^0.6 10^3.6],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2)
%     plot([0 120],[0 0],'--','Color',[.7 .7 .7],'LineWidth',1.2) % fot ft
    plot_distribution_prctile(eval((char(['v',num2str(k)]))),matrixBbtf.(char(['w',num2str(k)])),'Color',[0.1*(k/2) 0.1*(k/2) 0.1*(k/2)],'LineWidth',2,'Alpha',0.15,'Prctile',[50])
    title btf
    ylim([-.2 1])
    xlim([10^0.6 10^3.6])
%     xlim([0 140]) % for ft
    set(gca,'XScale','log','xtick',[10^-1 10^0 10^1 10^2 10^3],'xticklabels',{'0.1','1','10','100','1000'})
%     set(gca,'XScale','log','xtick',[0 10 100],'xticklabels',{'0','10','100'}) % for ft
    box on
    axis square
end
% % patch([0 5 5 0], [0 0, 1 1], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
% y = nanmean(temp); % your mean vector;
% std_dev = nanstd(temp);
% x = [.5 1 5 10 20 40 60 80 100 120];
% patch([x fliplr(x)], [y-std_dev  fliplr(y+std_dev)], [0.6  0.6  0.6],'EdgeColor','none','FaceAlpha',.5)
% hold on;
% plot(x,y,'Color',[0.2 0.2 0.2],'LineWidth',1.5);
set(gcf,'position',[50 450 600 300])
print([char(savename),'_TC_halfSec_ft'],'-depsc','-r300','-tiff','-painters')
savefig([char(savename),'_TC_halfSec_ft.fig'])


%% plot curve differnce index for 0.5 s
axLim = [.5 1];

% stimuli information, velocity (v2,v4,v8) and temporal frequency (x2, x4, x8) for the three different spatial frequencies
x2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350]; x2 = x2 * 0.0889;
x4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025]; x4 = x4 * 0.0444;
x8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5 3375]; x8 = x8 * 0.0222;

v2 = [5.625 11.25 56.25 112.5 225 450 675 900 1125 1350];
v4 = [8.4375 16.875 84.375 168.75 337.5 675 1012.5 1350 1687.5 2025];
v8 = [14.0625 28.125 140.625 281.25 562.5 1125 1687.5 2250 2812.5 3375];

for m = 1 : 2
    if m == 1
        dir = 'bw';
    elseif m == 2
        dir = 'fw';
    end
    %% save data to vectors and norm
    clear w2 w4 w8
    for k = 1 : size(matrixBbtf.w8,1)
        if m == 1 % btf
            w2 = matrixBbtf.w2(k,:);
            w4 = matrixBbtf.w4(k,:);
            w8 = matrixBbtf.w8(k,:);
        elseif m == 2 % ftb            
            w2 = matrixBftb.w2(k,:);
            w4 = matrixBftb.w4(k,:);
            w8 = matrixBftb.w8(k,:);
        end
        
        %% interpolate data and save same ft spike values
        w = [2 4 8];
        for i = w
            x = eval(char(['x',num2str(i)]));
            y = eval(char(['w',num2str(i)]));
            f = createFit(x,y); % Interpolant - shape preserving (PCHIP)
            X = linspace(min(x), max(x), 1000); % get x values
            Y = f(X); % get y values
            ft.(char(['w',num2str(i)])) = Y;
            ft.(char(['x',num2str(i)])) = X;
        end
        
        % limup = min([ft.x2(end) ft.x4(end) ft.x8(end)]);
        % limlow = max([ft.x2(1) ft.x4(1) ft.x8(1)]);
        
        ft.plot = [.5 1 5 10 20 30 40 50 60 74];
        
        for i = w
            for j = 1 : length(ft.plot)
                ft.(char(['Y',num2str(i)]))(j) = ft.(char(['w',num2str(i)]))(find(ft.(char(['x',num2str(i)]))>=ft.plot(j),1,'first'));
            end
            %     ft.(char(['Y',num2str(i)])) = ft.(char(['w',num2str(i)]))(find(ft.(char(['x',num2str(i)]))>=limlow,1,'first'):find(ft.(char(['x',num2str(i)]))<=limup,1,'last'));
            %     ft.(char(['X',num2str(i)])) = ft.(char(['x',num2str(i)]))(find(ft.(char(['x',num2str(i)]))>=limlow,1,'first'):find(ft.(char(['x',num2str(i)]))<=limup,1,'last'));
        end
        
        %% interpolate data and save same V spike values
        w = [2 4 8];
        for i = w
            x = eval(char(['v',num2str(i)]));
            y = eval(char(['w',num2str(i)]));
            f = createFit(x,y); % Interpolant - shape preserving (PCHIP)
            X = linspace(min(x), max(x), 1000); % get x values
            Y = f(X); % get y values
            V.(char(['w',num2str(i)])) = Y;
            V.(char(['x',num2str(i)])) = X;
        end
        
        V.plot = [14 16.875 56.25 112.5 225 450 675 900 1125 1350];
        % v2 = [];
        % v4 = [ 84.375 168.75 337.5 675 1012.5];
        % v8 = [14.0625 28.125 140.625 281.25 562.5 ];
        
        for i = w
            for j = 1 : length(V.plot)
                V.(char(['Y',num2str(i)]))(j) = V.(char(['w',num2str(i)]))(find(V.(char(['x',num2str(i)]))>=V.plot(j),1,'first'));
            end
            %     ft.(char(['Y',num2str(i)])) = ft.(char(['w',num2str(i)]))(find(ft.(char(['x',num2str(i)]))>=limlow,1,'first'):find(ft.(char(['x',num2str(i)]))<=limup,1,'last'));
            %     ft.(char(['X',num2str(i)])) = ft.(char(['x',num2str(i)]))(find(ft.(char(['x',num2str(i)]))>=limlow,1,'first'):find(ft.(char(['x',num2str(i)]))<=limup,1,'last'));
        end
        
        %%
%         ft.diffval(k,:) = .66-(abs(ft.Y2 - ft.Y4) + abs(ft.Y2 - ft.Y8) + abs(ft.Y4 - ft.Y8))/3;
%         V.diffval(k,:) = .66-(abs(V.Y2 - V.Y4) + abs(V.Y2 - V.Y8) + abs(V.Y4 - V.Y8))/3;
        
        
        ft.diffval(k,:) = (.66 - ((ft.Y2 - ft.Y4).^2 + (ft.Y2 - ft.Y8).^2 + (ft.Y4 - ft.Y8).^2)/3)*(3/2);
        V.diffval(k,:) = (.66 - ((V.Y2 - V.Y4).^2 + (V.Y2 - V.Y8).^2 + (V.Y4 - V.Y8).^2)/3)*(3/2);
    end
    
    %% plot
    figure(8)
    hold on
    % plot(V.plot,median(V.diffval),'Color',[.3 .3 .3],'LineWidth',1.5)
    plot_distribution_prctile(V.plot,V.diffval,'Color',[.3*m .3 .6/m],'LineWidth',1.5,'Alpha',0.15,'Prctile',[50])
%     ylim([.5 1])
    ylim(axLim)
    box on
    title('b = btf, r = ftb')
    axis square
    xlabel('velocity (°/s)')
    xlim([V.plot(1) V.plot(end)])
    set(gcf,'Position',[820 400 350 300])
    set(gca,'xscale','log','XTick',[10,100,1000],'XTickLabels',{'10','100','1000'})
    print([char(savename),'_V_T'],'-depsc','-r300','-tiff','-painters')
    savefig([char(savename),'_V_T','.fig'])
    
    figure(9)
    hold on
    % plot(ft.plot,median(ft.diffval),'Color',[.3 .3 .3],'LineWidth',1.5)
    plot_distribution_prctile(ft.plot,ft.diffval,'Color',[.3*m .3 .6/m],'LineWidth',1.5,'Alpha',0.15,'Prctile',[50])
%     ylim([.5 1])
    ylim(axLim)
    box on
    title('b = btf, r = ftb')
    axis square
    xlim([ft.plot(1) ft.plot(end)])
    xlabel('temporal frequency (Hz)')
    set(gcf,'Position',[420 400 350 300])
    set(gca,'xscale','log','XTick',[1,10,100],'XTickLabels',{'1','10','100'})   
    print([char(savename),'_ft_T'],'-depsc','-r300','-tiff','-painters')
    savefig([char(savename),'_ft_T','.fig'])
    
    xp1.(char(['r',num2str(m)])) = V.plot;
    yp1.(char(['r',num2str(m)])) = median(V.diffval);
    xp2.(char(['r',num2str(m)])) = ft.plot;
    yp2.(char(['r',num2str(m)])) = median(ft.diffval);
end

