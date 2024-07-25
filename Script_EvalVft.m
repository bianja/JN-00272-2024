% velocity/temporal freq evaluation
clearvars
close all
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcBi_addRF_extended.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh1_addRF_new_extended_sorted.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh2_addRF_new_extended_sorted.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcUni1_addRF_new_extended.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcUni2_addRF_new_extended.mat')

% cluster
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\cluster\Results_ExcBi_addRF_cluster.mat')
AllAni = C4;
fignum = 3;
savename = {'diffCurves_cluster_c4'};
axlim = [0.5 1];

%% stimuli information, velocity (v2,v4,v8) and temporal frequency (x2, x4, x8) for the three different spatial frequencies
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
    for k = 1 : size(AllAni,2)
        maxval = max([AllAni(k).R01.yfreq.mean.translation.bw.w2 AllAni(k).R01.yfreq.mean.translation.bw.w4 AllAni(k).R01.yfreq.mean.translation.bw.w8 ...
            AllAni(k).R01.yfreq.mean.translation.fw.w2 AllAni(k).R01.yfreq.mean.translation.fw.w4 AllAni(k).R01.yfreq.mean.translation.fw.w8]);
        w2 = AllAni(k).R01.yfreq.mean.translation.(char(dir)).w2/maxval;
        w4 = AllAni(k).R01.yfreq.mean.translation.(char(dir)).w4/maxval;
        w8 = AllAni(k).R01.yfreq.mean.translation.(char(dir)).w8/maxval;
        
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
        
        
        ft.diffval(k,:) = (.5 - ((ft.Y2 - ft.Y4).^2 + (ft.Y2 - ft.Y8).^2 + (ft.Y4 - ft.Y8).^2)/3)*2;
        V.diffval(k,:) = (.5 - ((V.Y2 - V.Y4).^2 + (V.Y2 - V.Y8).^2 + (V.Y4 - V.Y8).^2)/3)*2;
    end
    
    %% plot
    figure(8)
    hold on
    % plot(V.plot,median(V.diffval),'Color',[.3 .3 .3],'LineWidth',1.5)
    plot_distribution_prctile(V.plot,V.diffval,'Color',[.3*m .3 .6/m],'LineWidth',1.5,'Alpha',0.15,'Prctile',[50])
%     ylim([.5 1])
    ylim(axlim)
    box on
    title('b = btf, r = ftb')
    axis square
    xlabel('velocity (°/s)')
    xlim([V.plot(1) V.plot(end)])
    set(gcf,'Position',[820 400 350 300])
    set(gca,'xscale','log','XTick',[10,100,1000],'XTickLabels',{'10','100','1000'})
    print([char(savename),'_V'],'-depsc','-r300','-tiff','-painters')
    savefig([char(savename),'_V','.fig'])
    
    figure(9)
    hold on
    % plot(ft.plot,median(ft.diffval),'Color',[.3 .3 .3],'LineWidth',1.5)
    plot_distribution_prctile(ft.plot,ft.diffval,'Color',[.3*m .3 .6/m],'LineWidth',1.5,'Alpha',0.15,'Prctile',[50])
%     ylim([.5 1])
    ylim(axlim)
    box on
    title('b = btf, r = ftb')
    axis square
    xlim([ft.plot(1) ft.plot(end)])
    xlabel('temporal frequency (Hz)')
    set(gcf,'Position',[420 400 350 300])
    set(gca,'xscale','log','XTick',[1,10,100],'XTickLabels',{'1','10','100'})   
    print([char(savename),'_ft'],'-depsc','-r300','-tiff','-painters')
    savefig([char(savename),'_ft','.fig'])
    
    xp1.(char(['r',num2str(m)])) = V.plot;
    yp1.(char(['r',num2str(m)])) = median(V.diffval);
    xp2.(char(['r',num2str(m)])) = ft.plot;
    yp2.(char(['r',num2str(m)])) = median(ft.diffval);
end

%% plot
% figure(7)
% hold on
% % axis square
% t = tiledlayout(1,1);
% ax1 = axes(t);
% hold on
% plot(xp1.r1,yp1.r1,'--','Color','m','LineWidth',1.5)
% plot(xp1.r2,yp1.r2,'-','Color','m','LineWidth',1.5)
% ax1.XColor = 'm';
% ax1.Box = 'off';
% xlim(ax1,[V.plot(1) V.plot(end)])
% xlabel(ax1, 'velocity (°/s)')
% ax1.XScale = 'log';
% ax1.YLim = [.3 .5];
% 
% 
% ax2 = axes(t);
% hold on
% plot(xp2.r1,yp2.r1,'--','Color','b','LineWidth',1.5)
% plot(xp2.r2,yp2.r2,'-','Color','b','LineWidth',1.5)
% ax2.XAxisLocation = 'top';
% ax2.YAxisLocation = 'right';
% ax2.XColor = 'b';
% ax2.Color = 'none';
% ax2.Box = 'off';
% xlim(ax2,[ft.plot(1) ft.plot(end)])
% xlabel(ax2, 'temporal frequency (Hz)')
% ax2.XScale = 'log';
% ax2.YLim = [.3 .5];
% set(gcf,'Position',[420 400 350 350])
% createLegend({'btf','ftb'},[.4 .4 .4; .4 .4 .4],{'--','-'},'best',1.5)

%% to test code
% figure
% plot(V.plot,V.Y2)
% hold on
% plot(V.plot,V.Y4)
% plot(V.plot,V.Y8)
% set(gca,'xscale','log')
%
% figure
% plot(V.x2,V.w2)
% hold on
% plot(V.x4,V.w4)
% plot(V.x8,V.w8)
% set(gca,'xscale','log')
%
% figure
% plot(v2,w2)
% hold on
% plot(v4,w4)
% plot(v8,w8)
% set(gca,'xscale','log')
