% ExcUni - plot population response of receptive fields

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
%         meanAngCW(i) = NaN;
%         yDataCW(i,1:36) = NaN;
%         xCW(i,1:36) = NaN;
%         meanAngCCW(i) = NaN;
%         yDataCCW(i,1:36) = NaN;
%         xCCW(i,1:36) = NaN;
    elseif isnan(CCW{i})
%         meanAngCW(i) = NaN;
%         yDataCW(i,1:36) = NaN;
%         xCW(i,1:36) = NaN;
%         meanAngCCW(i) = NaN;
%         yDataCCW(i,1:36) = NaN;
%         xCCW(i,1:36) = NaN;
    else
        figure('visible','off')
        objCW = CircHist(CW{i},36,'areAxialData',false,'parent',polaraxes);
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
        % add background activity
        
        figure('visible','off')
        objCCW = CircHist(CCW{i},36,'areAxialData',false,'parent',polaraxes);
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
        % add background activity
        
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
%         ylim([0 40])
        close
        
        % extract data
%         st = smooth(t,5);
%         degree = deg(find(st > (max(st-min(st)))/100*th));
%         width = [degree(find(diff(degree)-2 > 5)+1) degree(find(diff(degree)-2 > 5))];
%         if isempty(width)
%             width = NaN;
%         elseif width(1) > width(2)
%             widthCW(c) = 360-width(1)+width(2);
%         else
%             widthCW(c) = width(2)-width(1);
%         end
        
        c = c + 1;
    end
end

figure
meanObjCW = CircHist(meanAngCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
meanObjCW.setRLim([0 3])
title('cw')
print(['231004_ExcUni1_RF_circular_',num2str(vel),'_',num2str(width),'_cw'],'-depsc','-r300','-tiff','-painters')
savefig(['231004_ExcUni1_RF_circular_',num2str(vel),'_',num2str(width),'_cw_.fig'])

figure
meanObjCCW = CircHist(meanAngCCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
meanObjCCW.setRLim([0 3])
title('ccw')   
print(['231004_ExcUni1_RF_circular_',num2str(vel),'_',num2str(width),'_ccw'],'-depsc','-r300','-tiff','-painters')
savefig(['231004_ExcUni1_RF_circular_',num2str(vel),'_',num2str(width),'_ccw_.fig'])

