% ExcInh - plot population response of receptive fields
% !!! line 154 155, depending on which condition, adapt code!!!
% imline to measure width

clear
close all
clc

filename = uigetfile('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF');
load(['\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\',filename])
UnitNum = size(AllAni,2);
a = 3; % to define number of subplots per row or column
b = 2; % to define number of subplots in other direction

%% set stimulus parameters
width = 2;
vel = 20;
histW = 36;
th = 75; % in percent
deg = 0:360/histW:359;

% extract data from large table file
for i = 1 : size(AllAni,2) % for all animals
    if isempty(AllAni(i).RF1) % check if RF1 is available
        %NaN
        CW{i} = NaN;
        CCW{i} = NaN;
    else
        if size([AllAni(i).RF1],2) == 30 % all three spatial frequencies presented
            if ~isempty(find([AllAni(i).RF1.vel] == vel*-1 & [AllAni(i).RF1.width] == width)) && ~isempty(find([AllAni(i).RF1.vel] == vel & [AllAni(i).RF1.width] == width))
                % find and save stim information
                posCW = find([AllAni(i).RF1.vel] == vel & [AllAni(i).RF1.width] == width);
                posCCW = find([AllAni(i).RF1.vel] == vel*-1 & [AllAni(i).RF1.width] == width);
                CW{i} = AllAni(i).RF1(posCW).spikes;
                CCW{i} = AllAni(i).RF1(posCCW).spikes;
            else
                % NaN
                CW{i} = NaN;
                CCW{i} = NaN;
            end
        elseif ~isempty(AllAni(i).RF2) % check if RF2 is available
            if size([AllAni(i).RF2],2) == 30 % all three spatial frequencies presented
                % find and save stim information
                posCW = find([AllAni(i).RF1.vel] == vel & [AllAni(i).RF1.width] == width);
                posCCW = find([AllAni(i).RF1.vel] == vel*-1 & [AllAni(i).RF1.width] == width);
                CW{i} = AllAni(i).RF1(posCW).spikes;
                CCW{i} = AllAni(i).RF1(posCCW).spikes;
            else
                % NaN
                CW{i} = NaN;
                CCW{i} = NaN;
            end
        else
            % NaN
            CW{i} = NaN;
            CCW{i} = NaN;
        end
    end
end

% plot circular figures and supress figure ouptut - save bin data and mean value
c = 1;
for i = 1 : size(AllAni,2)
    if isnan(CW{i})
    elseif isnan(CCW{i})
    else
        figure('visible','off')
        objCW = CircHist(CW{i},36,'areAxialData',false,'parent',polaraxes);
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
        % add background activity
        clear temp
        temp = find(objCW.histData(:,1) == 0);
        widCW(c,:) = length(find(diff(temp) == 1))*10;
     
        figure('visible','off')
        objCCW = CircHist(CCW{i},36,'areAxialData',false,'parent',polaraxes);
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
        % add background activity
        clear temp
        temp = find(objCCW.histData(:,1) == 0);
        widCCW(c,:) = length(find(diff(temp) == 1))*10;
        
        meanAngCW(c) = objCW.avgAng;
        yDataCW(c,:) = objCW.histData(:,1);
        xCW(c,:) = objCW.edges(1:end-1)+5;
        
        meanAngCCW(c) = objCCW.avgAng;
        yDataCCW(c,:) = objCCW.histData(:,1);
        xCCW(c,:) = objCCW.edges(1:end-1)+5;
        
        % plot receptive field in q plot
        figure('visible','off')
        clear objCW objCCW
        objCW = CircHist(CW{i},histW,'areAxialData',false,'parent',polaraxes);
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
        objCCW = CircHist(CCW{i},histW,'areAxialData',false,'parent',polaraxes);
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
     
        t = objCW.histData(:,1); % change for CW/CCW
        temp = [t(size(deg,2)/2+1:end);t(1:size(deg,2)/2)];
        figure
        hold on
        plot(deg,temp,'r')
        plot(deg,smooth(temp),'k')
        box on
        xticks([0, 180, 2*180])
        xticklabels([-180, 0, 180])
        xlim([0 2*180])
        plot([0 360],[max(temp)*(th/100) max(temp)*(th/100)],'--r')
        plot([0 360],[max(smooth(temp))*(th/100) max(smooth(temp))*(th/100)],'--k')
        close
        
        c = c + 1;
    end
end

figure
meanObjCW = CircHist(meanAngCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
meanObjCW.setRLim([0 3])
title('cw exc')
print(['231004_ExcInh2_exc_RF_circular_',num2str(vel),'_',num2str(width),'_cw'],'-depsc','-r300','-tiff','-painters')
savefig(['231004_ExcInh2_exc_RF_circular_',num2str(vel),'_',num2str(width),'_cw_.fig'])

figure
meanObjCCW = CircHist(meanAngCCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
meanObjCCW.setRLim([0 3])
title('ccw exc')
print(['231004_ExcInh2_exc_RF_circular_',num2str(vel),'_',num2str(width),'_ccw'],'-depsc','-r300','-tiff','-painters')
savefig(['231004_ExcInh2_exc_RF_circular_',num2str(vel),'_',num2str(width),'_ccw_.fig'])

%% subtract maxval and get max from abs of all values
c = 1;
clear temp
for i = 1 : size(yDataCW,1)
        temp(:,1) = yDataCW(i,:);
        temp(:,2) = zeros(length(yDataCW(i,:)),1);
        temp(:,1) = abs(temp(:,1)-max(temp(:,1)));
        figure('visible','off')
        INHobjCW = CircHist(temp,'dataType','histogram');
        INHobjCW.setRLim([0 5])
        INHmeanAngCW(c) = INHobjCW.avgAng;
        INHyDataCW(c,:) = INHobjCW.histData(:,1);
        INHxCW(c,:) = INHobjCW.edges(1:end-1)+5;
        
        temp(:,1) = yDataCCW(i,:);
        temp(:,2) = zeros(length(yDataCCW(i,:)),1);
        temp(:,1) = abs(temp(:,1)-max(temp(:,1)));
        figure('visible','off')
        INHobjCCW = CircHist(temp,'dataType','histogram');
        INHobjCCW.setRLim([0 5])
        INHmeanAngCCW(c) = INHobjCCW.avgAng;
        INHyDataCCW(c,:) = INHobjCCW.histData(:,1);
        INHxCCW(c,:) = INHobjCCW.edges(1:end-1)+5;
        
        c = c + 1;
end

figure
INHmeanObjCW = CircHist(INHmeanAngCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
INHmeanObjCW.setRLim([0 3])
title('cw inh')
print(['231004_ExcInh2_inh_RF_circular_',num2str(vel),'_',num2str(width),'_cw'],'-depsc','-r300','-tiff','-painters')
savefig(['231004_ExcInh2_inh_RF_circular_',num2str(vel),'_',num2str(width),'_cw_.fig'])

figure
INHmeanObjCCW = CircHist(INHmeanAngCCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
INHmeanObjCCW.setRLim([0 3])
title('ccw inh')    
print(['231004_ExcInh2_inh_RF_circular_',num2str(vel),'_',num2str(width),'_ccw'],'-depsc','-r300','-tiff','-painters')
savefig(['231004_ExcInh2_inh_RF_circular_',num2str(vel),'_',num2str(width),'_ccw_.fig'])

INHmeanAngCW = INHmeanAngCW-180; % excinh1
% INHmeanAngCW = INHmeanAngCW+180; % excinh2


%% corr
col = [.3 .3 .3];
figure(1000)

subplot(1,3,1)
axis equal
hold on
title('inh')
patch([-180 0 0 -180], [0 0, 180 180], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
patch([180 0 0 180], [0 0, -180 -180], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(INHmeanAngCW, INHmeanAngCCW, 'o', 'Color', col)
xlim([-180 180])
ylim([-180 180])
xlabel('mean angular position ccw')
ylabel('mean angular position cw')
xticks([-180, 0, 180])
xticklabels([-180, 0, 180])
yticks([-180, 0, 180])
yticklabels([-180, 0, 180])
% plot([270 270],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% plot([450 450],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
box on

%
subplot(1,3,2)
axis equal
hold on
title('inh')
plot([0 0],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
patch([-90 90 90 -90], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(INHmeanAngCW, widCW, '*', 'Color', col)
plot(INHmeanAngCCW, widCCW, 'x', 'Color', col)
xlim([-180 180])
ylim([0 360])
xlabel('mean angular position')
ylabel('full width at half maximum')
xticks([-180, 0, 180])
xticklabels([-180, 0, 180])
yticks([0 90 180 270 360])
box on


% diff
subplot(1,3,3)
axis equal
hold on
title('inh cw-ccw')
plot(INHmeanAngCW-INHmeanAngCCW, widCW-widCCW, '*', 'Color', col)
xlim([-360 360])
ylim([-360 360])
xlabel('diff(mean angular position)')
ylabel('diff(full width at half maximum)')
xticks([-360, -180, 0, 180, 360])
xticklabels([-360 -180 0 180 360])
yticks([-360 -180 0 180 360])
yticklabels([-360 -180 0 180 360])
box on
plot([0 0],[-360 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
plot([-360 360],[0 0],'--','Color',[.6 .6 .6 .5],'LineWidth',1)

print(['231004_ExcInh2_inh_RF_circular_',num2str(vel),'_',num2str(width)],'-depsc','-r300','-tiff','-painters')
savefig(['231004_ExcInh2_inh_RF_circular_',num2str(vel),'_',num2str(width),'.fig'])

