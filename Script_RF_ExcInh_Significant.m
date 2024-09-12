close all; clear

dat = 1;

if dat == 1
    load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh1_addRF_new_extended_sorted.mat')
elseif dat == 2
    load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcInh2_addRF_new_extended_sorted.mat')
% AllAni(2).RF1 = []; % wrong stimuli (movement direction)
else
    error('wrong value for variable dat')
end

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
            lengCW(c) = objCW.r;
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
            lengCW(c) = NaN;
            c = c + 1;
        end

        % CCW
        figure('visible','off')
        objCCW = CircHist(CCW{i},72/2,'areAxialData',false,'parent',polaraxes,'histType','frequency','binSizeSec',duration/(36));
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')

        if objCCW.rayleighP <= 0.03 % bonferroni corrected (15 stim)
            meanAngCCW(d) = objCCW.avgAng;
            lengCCW(d) = objCCW.r;
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
            lengCCW(d) = NaN;
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
lengCCW(find(isnan(meanAngCCW) == 1)) = NaN;
lengCW(find(isnan(meanAngCCW) == 1)) = NaN;


%% plot mean angular positions for all units
% figure('Visible','off')
% L1 = CircHist(widSCW(~isnan(widSCW)),36);
% set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
% figure('Visible','off')
% L2 = CircHist(widECW(~isnan(widECW)),36);
% set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
figure
meanObjCW = CircHist(meanAngCW(~isnan(meanAngCW))',36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
meanObjCW.setRLim([0 3])
title('cw')
print(['RF_allStim_75_cw_ExcInh',num2str(dat)],'-depsc','-r300','-tiff','-painters')
savefig(['RF_allStim_75_cw_ExcInh',num2str(dat),'.fig'])

% figure('Visible','off')
% L3 = CircHist(widSCCW(~isnan(widSCCW)),36);
% figure('Visible','off')
% L4 = CircHist(widECCW(~isnan(widECCW)),36);
figure
meanObjCCW = CircHist(meanAngCCW(~isnan(meanAngCCW))',36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
meanObjCCW.setRLim([0 3])
title('ccw')  
print(['RF_allStim_75_ccw_ExcInh',num2str(dat)],'-depsc','-r300','-tiff','-painters')
savefig(['RF_allStim_75_ccw_ExcInh',num2str(dat),'.fig'])


%% plot width for all units
widDiffCCW(find(widDiffCCW  > 360)) = abs(360-widDiffCCW(find(widDiffCCW  > 360))); 
widDiffCW(find(widDiffCW  > 360)) = abs(360-widDiffCW(find(widDiffCW  > 360))); 
Boxplot_B([widDiffCW' widDiffCCW'],2,15,[.75 .75 .75; .75 .75 .75],{'1','2'},[1,2])
set(gcf,'position',[500 400 280 330])
ylim([0 180])
set(gca,'XTickLabels',{'cw','ccw'})
plot(ones(length(widDiffCW'),1),widDiffCW','.','Color',[.5 .5 .5])
plot(ones(length(widDiffCCW'),1)+1,widDiffCCW','.','Color',[.5 .5 .5])
print(['RF_BP_allStim_75_ExcInh',num2str(dat)],'-depsc','-r300','-tiff','-painters')
savefig(['RF_BP_allStim_75_ExcInh',num2str(dat),'.fig'])

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
