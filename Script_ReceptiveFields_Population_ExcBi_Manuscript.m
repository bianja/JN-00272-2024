close all; clear
clearvars -except AllAni idx
% load 230912_ReceptiveFieldAnalysisClusterData.mat
% load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\Results_ExcBi_addRF.mat')
% load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_ExcBi_addRF.mat')

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
clust = 1;

% Data = AllAni;
% AllAni = [Data(1:56) Data(61:end)];
Data = AllAni;

AllAni = Data(find(idx == clust));

UnitNum = size(AllAni,2);
a = 3; % to define number of subplots per row or column
b = 2; % to define number of subplots in other direction

%% set stimulus parameters
close all
width = 2;
vel = 20;

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
        set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
        % add background activity
        
        meanAngCW(c) = objCW.avgAng;
        yDataCW(c,:) = objCW.histData(:,1);
        xCW(c,:) = objCW.edges(1:end-1)+5;
        
        meanAngCCW(c) = objCCW.avgAng;
        yDataCCW(c,:) = objCCW.histData(:,1);
        xCCW(c,:) = objCCW.edges(1:end-1)+5;
        
        c = c + 1;
    end
end

figure
meanObjCW = CircHist(meanAngCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','clockwise')
meanObjCW.setRLim([0 5])
title('cw')
print(['231004_RF_circular_',num2str(vel),'_',num2str(width),'_cw_C',num2str(clust)],'-depsc','-r300','-tiff','-painters')
savefig(['231004_RF_circular_',num2str(vel),'_',num2str(width),'_cw_C',num2str(clust),'.fig'])

figure
meanObjCCW = CircHist(meanAngCCW,36,'areAxialData',false,'parent',polaraxes);
set(gca,'ThetaZeroLocation', 'top','ThetaDir','counterclockwise')
meanObjCCW.setRLim([0 5])
title('ccw')   
print(['231004_RF_circular_',num2str(vel),'_',num2str(width),'_ccw_C',num2str(clust)],'-depsc','-r300','-tiff','-painters')
savefig(['231004_RF_circular_',num2str(vel),'_',num2str(width),'_ccw_C',num2str(clust),'.fig'])
