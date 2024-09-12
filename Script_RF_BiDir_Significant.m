close all; clear
clearvars -except AllAni idx

load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\cluster\231004_Results_Cluster_KnK_Manuscript_All_clusterData2.mat')
clearvars -except idx
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcBi_addRF_extended.mat')
clearvars -except AllAni idx


AllAni(19).RF1 = []; % because stimuli to map RF were wrong for A52
AllAni(19).RF2 = []; 
AllAni(20).RF1 = []; 
AllAni(20).RF2 = [];

% exc bi
start = 1; 
stop = 87;
col = 'k';
clust = 4;

Data = AllAni;

AllAni = Data(find(idx == clust));

UnitNum = size(AllAni,2);

%% get mean angular position
c = 1; d = 1;
for i = 1 : size(AllAni,2)
    if isempty(AllAni(i).RF1) % check if receptive fields were recorded
        CW{i} = NaN;
        CCW{i} = NaN;
    else
        % area of curve to find stim per unit
        clear temp
        for j = 1 : size(AllAni(i).RF1,2)
            temp(j) = sum(AllAni(i).RF1(j).spikes);
        end
        
        % no more spikes at the end of stimulus presentation 
        if clust == 4 && i == 11
            temp([13,17,26]) = NaN; % 13 17 26
        end

        % choose stim for current unit
        vel = abs(AllAni(i).RF1(find(temp == max(temp))).vel);
        width = AllAni(i).RF1(find(temp == max(temp))).width;

        % find position of chosen stim for current unit
        posCW = find([AllAni(i).RF1.vel] == vel & [AllAni(i).RF1.width] == width);
        posCCW = find([AllAni(i).RF1.vel] == vel*-1 & [AllAni(i).RF1.width] == width);
        CW{i} = AllAni(i).RF1(posCW).spikes;
        CCW{i} = AllAni(i).RF1(posCCW).spikes;

        % find mean angular position of current unit and only include it if
        % statistically significant
        % CW
        duration = (360/calcVelocity(vel,width));
        figure('visible','off')
        objCW = CircHist(CW{i},72/2,'areAxialData',false,'parent',polaraxes,'histType','frequency','binSizeSec',duration/(36));
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')

        if objCW.rayleighP <= 0.03 % bonferroni corrected (15 stim)
            meanAngCW(c) = objCW.avgAng;
            % meanAngCW(c) = mean(objCW.edges(find(objCW.histData(:,1) == max(objCW.histData(:,1))))-7.5);
            yDataCW(c,:) = objCW.histData(:,1);
            xCW(c,:) = objCW.edges(1:end-1);
            stimInfo(i,1) = AllAni(i).Animal;
            stimInfo(i,2) = AllAni(i).UnitNbr;
            stimInfo(i,3) = vel;
            stimInfo(i,4) = width;
            
            % get width at 75 % of maximum
            clear v tempStart tempEnd
            v = find(objCW.histData(:,1) >= max(objCW.histData(:,1)*0.75));
            tempv = find(diff(v) == 2);
            for j = 1 : length(tempv)
                v = [v(1:find(diff(v) == 2,1)); v(find(diff(v) == 2,1))+1; v(find(diff(v) == 2,1)+1:end)];
            end
            if v(1) == 1 && v(end) == 23
                v(end) = 24;
            end
            if v(1) == 2 && v(end) == 24
                v = [1;v];
            end
            e = 1;
            n = 1;
            for j = 1 : length(v)-1
                if v(j)+1 == v(j+1) 
                    if j == 1
                        tempStart(e) = 1;
                        tempEnd(e) = j+1;
                        e = e + 1;
                    else
                        tempEnd(e) = j+1;
                    end
                    n = 1;
                else
                    tempStart(e) = j+1;
                    tempEnd(e) = j+1;
                    if n == 0
                        if tempStart(e) == tempEnd(e)
                        else
                            e = e + 1;
                        end
                    elseif n == 1
                        n = 0;
                    end
                end
            end
            if length(v) == 1
                tempStart = 1;
                tempEnd = 1;
            end
            if length(tempStart) == 1 && length(tempEnd) > 1
                tempEnd(1) = tempEnd(2);
                tempEnd(2) = [];
            end

            % get length of sequences
            if v(1) == 1 && v(end) == 24 % sequences include 0°/360°
                [~,pos] = max([tempEnd(1)-tempStart(1)+tempEnd(end)-tempStart(end),tempEnd(2:end-1)-tempStart(2:end-1)]);
                if pos == 1 % longest sequence covering 0°/360°
                    widSCW(c) = xCW(c,v(tempStart(end)));
                    widECW(c) = xCW(c,v(tempEnd(1)))+15;
                    widDiffCW(c) = 360-widSCW(c)+widECW(c);
                else
                    widSCW(c) = xCW(c,v(tempStart(pos)));
                    widECW(c) = xCW(c,v(tempEnd(pos)))+15;
                    widDiffCW(c) = widECW(c)-widSCW(c);
                end
            else
                [~,pos] = max(tempEnd-tempStart);
                widSCW(c) = xCW(c,v(tempStart(pos)));
                widECW(c) = xCW(c,v(tempEnd(pos)))+15;
                widDiffCW(c) = widECW(c)-widSCW(c);
            end
            c = c + 1;
        else
            meanAngCW(c) = NaN;
            yDataCW(c,72/2) = NaN;
            xCW(c,72/2) = NaN;
            c = c + 1;
        end

        % CCW
        figure('visible','off')
        objCCW = CircHist(CCW{i},72/2,'areAxialData',false,'parent',polaraxes,'histType','frequency','binSizeSec',duration/(36));
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')

        if objCCW.rayleighP <= 0.03 % bonferroni corrected (15 stim)
            meanAngCCW(d) = objCCW.avgAng;
            % meanAngCCW(d) = mean(objCCW.edges(find(objCCW.histData(:,1) == max(objCCW.histData(:,1))))+7.5);
            yDataCCW(d,:) = objCCW.histData(:,1);
            xCCW(d,:) = objCCW.edges(1:end-1);
         
            % get width at 75 % of maximum
            clear v tempStart tempEnd
            v = find(objCCW.histData(:,1) >= max(objCCW.histData(:,1)*0.75));
            tempv = find(diff(v) == 2);
            for j = 1 : length(tempv)
                v = [v(1:find(diff(v) == 2,1)); v(find(diff(v) == 2,1))+1; v(find(diff(v) == 2,1)+1:end)];
            end
            if v(1) == 1 && v(end) == 23
                v(end) = 24;
            end
            if v(1) == 2 && v(end) == 24
                v = [1;v];
            end
            e = 1;
            n = 1;
            for j = 1 : length(v)-1
                if v(j)+1 == v(j+1)
                    if j == 1
                        tempStart(e) = 1;
                        tempEnd(e) = j+1;
                        e = e + 1;
                    else
                        tempEnd(e) = j+1;
                    end
                    n = 1;
                else
                    tempStart(e) = j+1;
                    tempEnd(e) = j+1;
                    if n == 0
                        if tempStart(e) == tempEnd(e)
                        else
                            e = e + 1;
                        end
                    elseif n == 1
                        n = 0;
                    end
                end
            end
            if length(v) == 1
                tempStart = 1;
                tempEnd = 1;
            end
            if length(tempStart) == 1 && length(tempEnd) > 1
                tempEnd(1) = tempEnd(2);
                tempEnd(2) = [];
            end

            % get length of sequences
            if v(1) == 1 && v(end) == 24 % sequences include 0°/360°
                [~,pos] = max([tempEnd(1)-tempStart(1)+tempEnd(end)-tempStart(end),tempEnd(2:end-1)-tempStart(2:end-1)]);
                if pos == 1 % longest sequence covering 0°/360°
                    widSCCW(d) = xCCW(d,v(tempStart(end)));
                    widECCW(d) = xCCW(d,v(tempEnd(1)))+15;
                    widDiffCCW(d) = 360-widSCCW(d)+widECCW(d);
                else
                    widSCCW(d) = xCCW(d,v(tempStart(pos)));
                    widECCW(d) = xCCW(d,v(tempEnd(pos)))+15;
                    widDiffCCW(d) = widECCW(d)-widSCCW(d);
                end
            else
                [~,pos] = max(tempEnd-tempStart);
                widSCCW(d) = xCCW(d,v(tempStart(pos)));
                widECCW(d) = xCCW(d,v(tempEnd(pos)))+15;
                widDiffCCW(d) = widECCW(d)-widSCCW(d);
            end
            % figure
            % histogram('BinCounts', objCW.histData(:,1), 'BinEdges', objCW.edges)
            % hold on
            % plot([0 360],[max(objCW.histData(:,1))*0.75 max(objCW.histData(:,1))*0.75])
            % xlim([0 360])
            % close
            d = d + 1;
        else
            meanAngCCW(d) = NaN;
            yDataCCW(d,72/2) = NaN;
            xCCW(d,72/2) = NaN;
            d = d + 1;
        end
    end
end

meanAngCW(find(isnan(meanAngCCW) == 1)) = NaN;
meanAngCCW(find(isnan(meanAngCW) == 1)) = NaN;
stimInfo(find(isnan(meanAngCCW) == 1),1:4) = NaN;
widSCW(find(isnan(meanAngCCW) == 1)) = NaN;
widECW(find(isnan(meanAngCCW) == 1)) = NaN;
widDiffCW(find(isnan(meanAngCCW) == 1)) = NaN;
widSCCW(find(isnan(meanAngCCW) == 1)) = NaN;
widECCW(find(isnan(meanAngCCW) == 1)) = NaN;
widDiffCCW(find(isnan(meanAngCCW) == 1)) = NaN;


%% plot mean angular positions for all units
figure('Visible','off')
L1 = CircHist(widSCW(~isnan(widSCW)),36);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
figure('Visible','off')
L2 = CircHist(widECW(~isnan(widECW)),36);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
figure
meanObjCW = CircHist(meanAngCW(~isnan(meanAngCW))',36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
meanObjCW.setRLim([0 6])
title('cw')
print(['RF_cluster_allStim_75_cw_C',num2str(clust)],'-depsc','-r300','-tiff','-painters')
savefig(['RF_cluster_allStim_75_cw_C',num2str(clust),'.fig'])

figure('Visible','off')
L3 = CircHist(widSCCW(~isnan(widSCCW)),36);
figure('Visible','off')
L4 = CircHist(widECCW(~isnan(widECCW)),36);
figure
meanObjCCW = CircHist(meanAngCCW(~isnan(meanAngCCW))',36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
meanObjCCW.setRLim([0 6])
title('ccw')  
print(['RF_cluster_allStim_75_ccw_C',num2str(clust)],'-depsc','-r300','-tiff','-painters')
savefig(['RF_cluster_allStim_75_ccw_C',num2str(clust),'.fig'])

%% contour plot with histogram information 
% coordinate system of cw and ccw separated in x quadrants (10°x10°), for
% each quadrant occurence frequency is calculated; matrix is normalized
% over itself; contour plot with angCW, angCCW, and occurence matrix
% clear b cm
% b = 0:30:360; % matrix boundaries
% for i = 1 : length(b)-1
%     for j =  1 : length(b)-1
%         cm2(i,j) = length(find(meanAngCW>b(i)&meanAngCW<b(i+1)&meanAngCCW>b(j)&meanAngCCW<b(j+1)));
%     end
% end
% cm(1:6,1:6) = cm2(7:12,7:12);
% cm(7:12,7:12) = cm2(1:6,1:6);
% cm(1:6,7:12) = cm2(7:12,1:6);
% cm(7:12,1:6) = cm2(1:6,7:12);
% figure
% grid on
% contourf(b(1:end-1)+15,b(1:end-1)+15,cm/max(max(cm)))
% axis equal
% xlim([0 360])
% ylim([0 360])
% set(gca,'XTick',[0,90,180,270,360],'XTickLabels',{'-180','-90','0','90','180'},'YTick',[0,90,180,270,360],'YTickLabels',{'-180','-90','0','90','180'})
% xlabel('ccw')
% ylabel('cw')
% colorbar
% caxis([0 1])
% % daspect([1 1 1])
% savefig(['ExcBi_Contour_cluster',num2str(clust),'.fig'])
% print(['ExcBi_Contour_cluster',num2str(clust)],'-depsc','-r300','-tiff','-painters')


for i = 1 : length(meanAngCW)
    if meanAngCW(i) < 180
        angCW(i) = meanAngCW(i) + 360;
    else
        angCW(i) = meanAngCW(i);
    end
end
for i = 1 : length(meanAngCCW)
    if meanAngCCW(i) < 180
        angCCW(i) = meanAngCCW(i) + 360;
    else
        angCCW(i) = meanAngCCW(i);
    end
end
figure
plot(angCCW,angCW,'x','LineWidth',1.5,'Color',[0.5 0.5 0.5])
xlim([180 360+180])
ylim([180 360+180])
axis equal
xlim([180 540])
ylim([180 540])
set(gca,'XTick',[180,270,360,450,540],'XTickLabels',{'-180','-90','0','90','180'},'YTick',[180,270,360,450,540],'YTickLabels',{'-180','-90','0','90','180'})
xlabel('ccw')
ylabel('cw')
box on
savefig(['ExcBi_Contour_individual_cluster',num2str(clust),'.fig'])
print(['ExcBi_Contour_individual_cluster',num2str(clust)],'-depsc','-r300','-tiff','-painters')

clear b cm
b = 180:30:360+180; % matrix boundaries
for i = 1 : length(b)-1
    for j =  1 : length(b)-1
        cm(i,j) = length(find(angCW>b(i)&angCW<b(i+1)&angCCW>b(j)&angCCW<b(j+1)));
    end
end
figure
grid on
contourf(b(1:end-1)+15,b(1:end-1)+15,cm/max(max(cm)))
axis equal
xlim([180 540])
ylim([180 540])
set(gca,'XTick',[180,270,360,450,540],'XTickLabels',{'-180','-90','0','90','180'},'YTick',[180,270,360,450,540],'YTickLabels',{'-180','-90','0','90','180'})
xlabel('ccw')
ylabel('cw')
colorbar
caxis([0 1])
savefig(['ExcBi_Contour_cluster',num2str(clust),'.fig'])
print(['ExcBi_Contour_cluster',num2str(clust)],'-depsc','-r300','-tiff','-painters')


%% plot width for all units
widDiffCCW(find(widDiffCCW  > 360)) = abs(360-widDiffCCW(find(widDiffCCW  > 360))); 
widDiffCW(find(widDiffCW  > 360)) = abs(360-widDiffCW(find(widDiffCW  > 360))); 
Boxplot_B([widDiffCW' widDiffCCW'],2,15,[.75 .75 .75; .75 .75 .75],{'1','2'},[1,2])
set(gcf,'position',[500 400 280 330])
title(num2str(clust))
ylim([0 180])
set(gca,'XTickLabels',{'cw','ccw'})
plot(ones(length(widDiffCW'),1),widDiffCW','.','Color',[.5 .5 .5])
plot(ones(length(widDiffCCW'),1)+1,widDiffCCW','.','Color',[.5 .5 .5])
print(['RF_BP_cluster_allStim_75_C',num2str(clust)],'-depsc','-r300','-tiff','-painters')
savefig(['RF_BP_cluster_allStim_75_C',num2str(clust),'.fig'])

% load StatsBPclustWid
% clustWidStatsCW(1:length(widDiffCW),clust) =  widDiffCW;
% clustWidStatsCCW(1:length(widDiffCCW),clust) = widDiffCCW;
% save StatsBPclustWid clustWidStatsCW clustWidStatsCCW

%% BP wid ks test
% clearvars
% close all
% load StatsBPclustWid
% 
% [aCW,bCW] = kstest(clustWidStatsCW);
% [aCCW,bCCW] = kstest(clustWidStatsCCW);
% for i = 1 : 4
%     for j = 1 : 4
%         cCW(i,j) = ranksum(clustWidStatsCW(:,i),clustWidStatsCW(:,j));
%         cCCW(i,j) = ranksum(clustWidStatsCCW(:,i),clustWidStatsCCW(:,j));
%     end
% end

