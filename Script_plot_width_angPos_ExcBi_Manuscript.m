% load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\Results_all_addRF_extended.mat')
% clearvars -except AllAni
% close all; clear
% load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\cluster\231004_Results_Cluster_KnK_Manuscript_All_clusterData2.mat')
% clearvars -except idx
% load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\Results_ExcBi_addRF_extended.mat')
% clearvars -except AllAni idx
% % load 230912_ReceptiveFieldAnalysisClusterData.mat
% AllAni(19).RF1 = []; % because stimuli to map RF were wrong for A52
% AllAni(19).RF2 = []; 
% AllAni(20).RF1 = []; 
% AllAni(20).RF2 = [];
% Data = AllAni;

%%

close all
clearvars
% clearvars -except AllAni idx
% load 230912_ReceptiveFieldAnalysisClusterData.mat
% load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\Results_ExcBi_addRF.mat')

% close all; clear
% load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\cluster\231004_Results_Cluster_KnK_Manuscript_All_clusterData2.mat')
% clearvars -except idx
% load('\\132.187.28.171\home\Manuskript\I Optic flow\data\RF\Results_ExcBi_addRF_extended.mat')
% clearvars -except AllAni idx

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

%% add width and MAP values from Script_ReceptiveFields_Population_ExcBi_Manuscript.m
if clust == 1
    widCCW = [38 104 37 109 26 45 35 91 78 48 27 73 13 19 23 17 17];
    widCW = [39 62 53 72 64 81 60 61 22 100 29 67 22 50 20 10 67];
    angCCW = [27.7682167511194,246.556996494266,112.794521645894,307.871496727319,291.273783081482,334.765051105192,359.602308896019,341.176348609894,342.663863599270,329.922271313988,357.675395636306,50.6526787217908,303.177959101492,10.3787520228800,28.0288543043262,6.95905362191579,335.830638463034];
    angCW = [23.3727336853507,70.9610144514523,112.777972671696,94.0498476171404,13.1607958077514,43.8113184804680,335.231840358401,9.18078956626508,343.867996959488,1.87188037672534,347.997816679912,354.216099106048,0.531868770563905,323.470046899931,1.61337256309500,59.5123526048187,306.952351420909];
    bpm = [];
elseif clust == 2
    widCCW = [44 27 19 65 27 20 84 49 27 83];
    widCW = [22 11 15 54 34 16 19 18 41 34];
    angCCW = [1.511289969988665e+02,68.570509128487960,2.758621509757545e+02,3.324982085181806e+02,11.778000607241442,22.624189801573593,2.966710150602536e+02,2.873295272358226e+02,2.705139183091072e+02,12.974131989154202];
    angCW = [2.484677264121243e+02,2.544771775772352e+02,2.539909067239944e+02,47.394293064072720,21.380067685287800,3.059316716165346e+02,3.404106227826465e+02,3.519126136062689e+02,3.787762668664843,3.496098066585513e+02];
elseif clust == 3
    widCCW = [44 21 20 9 35 40 16 20 21 38 55 83 74 19 43 46 34 18 20 20 111 30];
    widCW = [54 22 39 10 109 43 89 74 108 117 60 95 79 15 72 65 64 62 33 15 14 38];
    angCCW = [298.258190133155,331.911590259251,322.826432269313,335.496901859270,312.249086408202,342.275922081729,5.52942689964018,12.1270062533804,3.50763066361318,348.747744806275,315.890623741035,340.135532740992,325.325965748836,163.048166383126,42.1172178668171,24.4114875478732,185.909450022126,98.6701355593737,319.512640039743,304.387839117083,311.592727177904,6.91751187933039];
    angCW = [307.417427950922,330.400584657494,331.889680974237,289.725213594411,16.3870924701836,312.713021638490,301.159004503277,340.318914354672,349.493870208878,346.758594166947,29.8767992198809,4.95356944534665,28.1467761143309,290.889780845083,302.989194109760,305.787808581049,311.776944450340,341.082126857565,331.451528546951,349.855094459321,11.5342556769512,331.663730574691];
elseif clust == 4
    widCCW = [116 102 43 37 19 123 136 190 149 117 53 21];
    widCW = [68 68 82 121 73 131 31 133 73 72 127 135];
    angCCW = [18.4033898266127,286.903194919114,293.386385387658,15.3695942159611,292.763933464363,2.14698027400765,303.283863369030,328.910817659739,344.837850147122,314.323831955850,12.9387776858520,37.7385763586346];
    angCW = [314.740144527635,54.0824183396705,203.307141694954,318.767288804940,80.7353567699362,352.455057406173,336.348513189476,282.606923098530,312.757167986755,191.518289074039,292.578250917328,25.2525732709664];
end

%% bp MAP
angCCW = [27.7682167511194,246.556996494266,112.794521645894,307.871496727319,291.273783081482,334.765051105192,359.602308896019,341.176348609894,342.663863599270,329.922271313988,357.675395636306,50.6526787217908,303.177959101492,10.3787520228800,28.0288543043262,6.95905362191579,335.830638463034];
angCW = [23.3727336853507,70.9610144514523,112.777972671696,94.0498476171404,13.1607958077514,43.8113184804680,335.231840358401,9.18078956626508,343.867996959488,1.87188037672534,347.997816679912,354.216099106048,0.531868770563905,323.470046899931,1.61337256309500,59.5123526048187,306.952351420909];
a = [360-angCCW;angCW];
for i = 1 : length(angCW)
    bpm(i,1) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
    bpmcw(i,1) = angCW(i);
    bpmccw(i,1) = angCCW(i);
end
angCCW = [1.511289969988665e+02,68.570509128487960,2.758621509757545e+02,3.324982085181806e+02,11.778000607241442,22.624189801573593,2.966710150602536e+02,2.873295272358226e+02,2.705139183091072e+02,12.974131989154202];
angCW = [2.484677264121243e+02,2.544771775772352e+02,2.539909067239944e+02,47.394293064072720,21.380067685287800,3.059316716165346e+02,3.404106227826465e+02,3.519126136062689e+02,3.787762668664843,3.496098066585513e+02];
a = [360-angCCW;angCW];
for i = 1 : length(angCW)
    bpm(i,2) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
    bpmcw(i,2) = angCW(i);
    bpmccw(i,2) = angCCW(i);
end
angCCW = [298.258190133155,331.911590259251,322.826432269313,335.496901859270,312.249086408202,342.275922081729,5.52942689964018,12.1270062533804,3.50763066361318,348.747744806275,315.890623741035,340.135532740992,325.325965748836,163.048166383126,42.1172178668171,24.4114875478732,185.909450022126,98.6701355593737,319.512640039743,304.387839117083,311.592727177904,6.91751187933039];
angCW = [307.417427950922,330.400584657494,331.889680974237,289.725213594411,16.3870924701836,312.713021638490,301.159004503277,340.318914354672,349.493870208878,346.758594166947,29.8767992198809,4.95356944534665,28.1467761143309,290.889780845083,302.989194109760,305.787808581049,311.776944450340,341.082126857565,331.451528546951,349.855094459321,11.5342556769512,331.663730574691];
a = [360-angCCW;angCW];
for i = 1 : length(angCW)
    bpm(i,3) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
    bpmcw(i,3) = angCW(i);
    bpmccw(i,3) = angCCW(i);
end
angCCW = [18.4033898266127,286.903194919114,293.386385387658,15.3695942159611,292.763933464363,2.14698027400765,303.283863369030,328.910817659739,344.837850147122,314.323831955850,12.9387776858520,37.7385763586346];
angCW = [314.740144527635,54.0824183396705,203.307141694954,318.767288804940,80.7353567699362,352.455057406173,336.348513189476,282.606923098530,312.757167986755,191.518289074039,292.578250917328,25.2525732709664];
a = [360-angCCW;angCW];
for i = 1 : length(angCW)
    bpm(i,4) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
    bpmcw(i,4) = angCW(i);
    bpmccw(i,4) = angCCW(i);
end
bpm(find(bpm == 0)) = NaN;
bpmcw(find(bpmcw == 0)) = NaN;
bpmccw(find(bpmccw == 0)) = NaN;
    
Boxplot_B(bpm,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
hold on
ylim([0 360])
yticks([0 90 180 270 360])
yticklabels([0 90 180 270 360])
set(gcf,'position',[500 400 280 330])
xlabel('cluster')
ylabel('mean angular position (°) cw-ccw')
plot(ones(length(bpm(:,1)),1),bpm(:,1),'.','Color',[.5 .5 .5])
plot(ones(length(bpm(:,2)),1)+1,bpm(:,2),'.','Color',[.5 .5 .5])
plot(ones(length(bpm(:,3)),1)+2,bpm(:,3),'.','Color',[.5 .5 .5])
plot(ones(length(bpm(:,4)),1)+3,bpm(:,4),'.','Color',[.5 .5 .5])
savefig('ExcBi_Ocularity_BP_MAP_cluster_all.fig')
print('ExcBi_Ocularity__BP_MAP_cluster_all','-depsc','-r300','-tiff','-painters')

Boxplot_B(bpmcw,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
hold on
ylim([0 360])
yticks([0 90 180 270 360])
yticklabels([0 90 180 270 360])
set(gcf,'position',[500 400 280 330])
xlabel('cluster')
ylabel('mean angular position (°) cw-ccw')
plot(ones(length(bpmcw(:,1)),1),bpmcw(:,1),'.','Color',[.5 .5 .5])
plot(ones(length(bpmcw(:,2)),1)+1,bpmcw(:,2),'.','Color',[.5 .5 .5])
plot(ones(length(bpmcw(:,3)),1)+2,bpmcw(:,3),'.','Color',[.5 .5 .5])
plot(ones(length(bpmcw(:,4)),1)+3,bpmcw(:,4),'.','Color',[.5 .5 .5])
savefig('ExcBi_Ocularity_BP_MAP_cluster_all.fig')
print('ExcBi_Ocularity__BP_MAP_cluster_all','-depsc','-r300','-tiff','-painters')

Boxplot_B(bpmccw,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
hold on
ylim([0 360])
yticks([0 90 180 270 360])
yticklabels([0 90 180 270 360])
set(gcf,'position',[500 400 280 330])
xlabel('cluster')
ylabel('mean angular position (°) cw-ccw')
plot(ones(length(bpmccw(:,1)),1),bpmccw(:,1),'.','Color',[.5 .5 .5])
plot(ones(length(bpmccw(:,2)),1)+1,bpmccw(:,2),'.','Color',[.5 .5 .5])
plot(ones(length(bpmccw(:,3)),1)+2,bpmccw(:,3),'.','Color',[.5 .5 .5])
plot(ones(length(bpmccw(:,4)),1)+3,bpmccw(:,4),'.','Color',[.5 .5 .5])
savefig('ExcBi_Ocularity_BP_MAP_cluster_all.fig')
print('ExcBi_Ocularity__BP_MAP_cluster_all','-depsc','-r300','-tiff','-painters')

%%
c = 1;
for i = 1 : 4
    bpmcwccw(:,c) = bpmcw(:,i);
    bpmcwccw(:,c+1) = bpmccw(:,i);
    c = c + 2;
end

for j = 1 : 8
    for i = 1 : size(bpmcwccw,1)
        if bpmcwccw(i,j) < 180
            bpmcwccw(i,j) = bpmcwccw(i,j) + 360;
        end
    end
end

close all
figure
hold on
for j = 1 : 2 : 8
    for i = 1 : size(bpmcwccw,1)
        plot([j,j+1],bpmcwccw(i,j:j+1),'-xk')
    end
    plot([j,j+1],nanmean(bpmcwccw(:,j:j+1)),'-xr','LineWidth',2)
end
plot([0 9],[360 360],'--')
ylim([180 360+180])
yticks([180 270 360 450 540])
yticklabels([-180 -90 0 90 180])

Boxplot_B(bpmcwccw,8,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1cw','1ccw','2cw','2ccw','3cw','3ccw','4cw','4ccw'},{'1','2','3','4','5','6','7','8'})
hold on
ylim([180 360+180])
yticks([180 270 360 450 540])
yticklabels([-180 -90 0 90 180])
set(gcf,'position',[500 400 280 330])
xlabel('cluster')
ylabel('mean angular position (°) cw-ccw')
plot(ones(length(bpmcwccw(:,1)),1),bpmcwccw(:,1),'.','Color',[.5 .5 .5])
plot(ones(length(bpmcwccw(:,2)),1)+1,bpmcwccw(:,2),'.','Color',[.5 .5 .5])
plot(ones(length(bpmcwccw(:,3)),1)+2,bpmcwccw(:,3),'.','Color',[.5 .5 .5])
plot(ones(length(bpmcwccw(:,4)),1)+3,bpmcwccw(:,4),'.','Color',[.5 .5 .5])
plot([0 9],[360 360],'--')
% savefig('ExcBi_Ocularity_BP_MAP_cluster_all.fig')
% print('ExcBi_Ocularity__BP_MAP_cluster_all','-depsc','-r300','-tiff','-painters')

for i = 1 : 8
    for j = 1 : 8
        MAP_stats(i,j) = watsons_U2_perm_test(bpmcwccw(:,i),bpmcwccw(:,j),1000);
    end
end
new_p = [0.05/28 0.01/28 0.001/28];

save MAP_stats.mat MAP_stats new_p

%% boxplots width
clear bpm
close all
widCCW = [38 104 37 109 26 45 35 91 78 48 27 73 13 19 23 17 17];
widCW = [39 62 53 72 64 81 60 61 22 100 29 67 22 50 20 10 67];
a = [360-widCCW;widCW];
for i = 1 : length(widCW)
    bpm(i,1) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
end
widCCW = [44 27 19 65 27 20 84 49 27 83];
widCW = [22 11 15 54 34 16 19 18 41 34];
a = [360-widCCW;widCW];
for i = 1 : length(widCW)
    bpm(i,2) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
end
widCCW = [44 21 20 9 35 40 16 20 21 38 55 83 74 19 43 46 34 18 20 20 111 30];
widCW = [54 22 39 10 109 43 89 74 108 117 60 95 79 15 72 65 64 62 33 15 14 38];
a = [360-widCCW;widCW];
for i = 1 : length(widCW)
    bpm(i,3) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
end
widCCW = [116 102 43 37 19 123 136 190 149 117 53 21];
widCW = [68 68 82 121 73 131 31 133 73 72 127 135];
a = [360-widCCW;widCW];
for i = 1 : length(widCW)
    bpm(i,4) = min([360-abs((a(2,i)-a(1,i))) abs(a(2,i)-a(1,i))]);
end
bpm(find(bpm == 0)) = NaN;
    
Boxplot_B(bpm,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
hold on
ylim([0 360])
yticks([0 90 180 270 360])
yticklabels([0 90 180 270 360])
set(gcf,'position',[500 400 280 330])
xlabel('cluster')
ylabel('width at 75 % (°) cw-ccw')
plot(ones(length(bpm(:,1)),1),bpm(:,1),'.','Color',[.5 .5 .5])
plot(ones(length(bpm(:,2)),1)+1,bpm(:,2),'.','Color',[.5 .5 .5])
plot(ones(length(bpm(:,3)),1)+2,bpm(:,3),'.','Color',[.5 .5 .5])
plot(ones(length(bpm(:,4)),1)+3,bpm(:,4),'.','Color',[.5 .5 .5])
savefig('ExcBi_Ocularity_BP_width_cluster_all.fig')
print('ExcBi_Ocularity__BP_width_cluster_all','-depsc','-r300','-tiff','-painters')

clear bpCW bpCCW
bpCCW(1:17,1) = [38 104 37 109 26 45 35 91 78 48 27 73 13 19 23 17 17];
bpCW(1:17,1) = [39 62 53 72 64 81 60 61 22 100 29 67 22 50 20 10 67];
bpCCW(1:10,2) = [44 27 19 65 27 20 84 49 27 83];
bpCW(1:10,2) = [22 11 15 54 34 16 19 18 41 34];
bpCCW(1:22,3) = [44 21 20 9 35 40 16 20 21 38 55 83 74 19 43 46 34 18 20 20 111 30];
bpCW(1:22,3) = [54 22 39 10 109 43 89 74 108 117 60 95 79 15 72 65 64 62 33 15 14 38];
bpCCW(1:12,4) = [116 102 43 37 19 123 136 190 149 117 53 21];
bpCW(1:12,4) = [68 68 82 121 73 131 31 133 73 72 127 135];
bpCW(find(bpCW == 0)) = NaN;
bpCCW(find(bpCCW == 0)) = NaN;


Boxplot_B(bpCW,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
hold on
ylim([0 360])
yticks([0 90 180 270 360])
yticklabels([0 90 180 270 360])
set(gcf,'position',[500 400 280 330])
xlabel('cluster')
ylabel('width at 75 % (°) cw')
plot(ones(length(bpCW(:,1)),1),bpCW(:,1),'.','Color',[.5 .5 .5])
plot(ones(length(bpCW(:,2)),1)+1,bpCW(:,2),'.','Color',[.5 .5 .5])
plot(ones(length(bpCW(:,3)),1)+2,bpCW(:,3),'.','Color',[.5 .5 .5])
plot(ones(length(bpCW(:,4)),1)+3,bpCW(:,4),'.','Color',[.5 .5 .5])
savefig('ExcBi_Ocularity_BP_width_cw_cluster_all.fig')
print('ExcBi_Ocularity__BP_width_cw_cluster_all','-depsc','-r300','-tiff','-painters')

Boxplot_B(bpCCW,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
hold on
ylim([0 360])
yticks([0 90 180 270 360])
yticklabels([0 90 180 270 360])
set(gcf,'position',[500 400 280 330])
xlabel('cluster')
ylabel('width at 75 % (°) ccw')
plot(ones(length(bpCCW(:,1)),1),bpCCW(:,1),'.','Color',[.5 .5 .5])
plot(ones(length(bpCCW(:,2)),1)+1,bpCCW(:,2),'.','Color',[.5 .5 .5])
% plot(ones(length(bpCCW(:,3)),1)+2,bpCCW(:,3),'.','Color',[.5 .5 .5])
plot(ones(length(bpCCW(:,4)),1)+3,bpCCW(:,4),'.','Color',[.5 .5 .5])
savefig('ExcBi_Ocularity_BP_width_cww_cluster_all.fig')
print('ExcBi_Ocularity__BP_width_cww_cluster_all','-depsc','-r300','-tiff','-painters')

%% plot MAP vs width
% AllAni = Data(find(idx == 4));
w = 2;
v = 20;
col = [.3 .3 .3];

angCCW = 360-angCCW; % to invert ccw
for i = 1 : length(widCW)
    if angCCW(i) < 180
        angCCW(i) = angCCW(i)+360;
    else
    end
    if angCW(i) < 180
        angCW(i) = angCW(i)+360;
    else
    end
end


% exc bi
% start = 1; 
% stop = size(AllAni,2);
% % col = 'k';
% for i = start : stop %1 : size(AllAni,2)
%     if isempty(AllAni(i).RF1)
%         widCCW(i) = NaN;
%         statsCCW(i) = NaN;
%         angCCW(i) = NaN;
%     else
%         stim = find([AllAni(i).RF1.vel] == -v & [AllAni(i).RF1.width] == w);
%         if isempty(AllAni(i).RF1(stim).RFangPos)
%             statsCCW(i) = NaN;
%         else
%             statsCCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
%         end
%         if isnan(statsCCW(i)) %| statsCCW(i) > 0.05
%             widCCW(i) = NaN;
%             statsCCW(i) = NaN;
%             angCCW(i) = NaN;
%         else
%             if AllAni(i).RF1(stim).RFangPos.val < 180
%                 angCCW(i) = AllAni(i).RF1(stim).RFangPos.val+360;
%             else
%                 angCCW(i) = AllAni(i).RF1(stim).RFangPos.val;
%             end
%             widCCW(i) = AllAni(i).RF1(stim).RFwidth.diffW;
%             statsCCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
%         end
%     end
% end

figure(1)
subplot(1,3,1)
axis equal
hold on
title('ccw')
plot([360 360],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
patch([270 450 450 270], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCCW, widCCW, 'x', 'Color', col)
xlim([180 3*180])
ylim([0 360])
xlabel('mean angular position')
ylabel('full width at half maximum')
xticks([180, 270, 360, 450, 540])
xticklabels([-180 -90 0 90 180])
yticks([0 90 180 270 360])
box on
% plot([270 270],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% plot([450 450],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)


% for i = start : stop %1 : size(AllAni,2)
%     if isempty(AllAni(i).RF1)
%         widCW(i) = NaN;
%         statsCW(i) = NaN;
%         angCW(i) = NaN;
%     else
%         stim = find([AllAni(i).RF1.vel] == v & [AllAni(i).RF1.width] == w);
%         if isempty(AllAni(i).RF1(stim).RFangPos)
%             statsCW(i) = NaN;
%         else
%             statsCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
%         end
%         if isnan(statsCW(i))% | statsCW(i) > 0.05
%             widCW(i) = NaN;
%             statsCW(i) = NaN;
%             angCW(i) = NaN;
%         else
%             if AllAni(i).RF1(stim).RFangPos.val < 180
%                 angCW(i) = AllAni(i).RF1(stim).RFangPos.val+360;
%             else
%                 angCW(i) = AllAni(i).RF1(stim).RFangPos.val;
%             end
%             widCW(i) = AllAni(i).RF1(stim).RFwidth.diffW;
%             statsCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
%         end
%     end
% end

subplot(1,3,2)
axis equal
hold on
title('cw')
plot([360 360],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
patch([270 450 450 270], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCW, widCW, '*', 'Color', col)
xlim([180 3*180])
ylim([0 360])
xlabel('mean angular position')
ylabel('full width at half maximum')
xticks([180, 270, 360, 450, 540])
xticklabels([-180 -90 0 90 180])
yticks([0 90 180 270 360])
box on
% plot([270 270],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% plot([450 450],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)

subplot(1,3,3)
axis equal
hold on
title('cw-ccw')
plot(angCW-angCCW, widCW-widCCW, '*', 'Color', col)
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
set(gcf,'position',[210 550 1500 360])
savefig(['ExcBi_MAP_width_cluster',num2str(clust),'.fig'])
print(['ExcBi_MAP_width_cluster',num2str(clust)],'-depsc','-r300','-tiff','-painters')

%%
figure
plot(angCCW,angCW,'kx')
axis equal
xlim([180 180+360])
ylim([180 180+360])
xlabel('ccw')
ylabel('cw')
set(gca,'XTick',[180,270,360,450,540],'XTickLabels',{'-180','-90','0','90','180'},'YTick',[180,270,360,450,540],'YTickLabels',{'-180','-90','0','90','180'})
savefig(['ExcBi_Ocularity_cluster',num2str(clust),'.fig'])
print(['ExcBi_Ocularity_cluster',num2str(clust)],'-depsc','-r300','-tiff','-painters')

%% contour plot with histogram information 
% coordinate system of cw and ccw separated in x quadrants (10°x10°), for
% each quadrant occurence frequency is calculated; matrix is normalized
% over itself; contour plot with angCW, angCCW, and occurence matrix
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
% daspect([1 1 1])
savefig(['ExcBi_Ocularity_Contour_cluster',num2str(clust),'.fig'])
print(['ExcBi_Ocularity__Contour_cluster',num2str(clust)],'-depsc','-r300','-tiff','-painters')

%% ang cw ccw
% figure(6)
% subplot(1,3,1)
% axis equal
% hold on
% % plot([0 0],[180 540],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% % plot([180 540],[0 0],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% patch([360 540 540 360], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
% patch([360 0 0 360], [540 540, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
% plot(angCCW(find(idx == 1)), angCW(find(idx == 1)), '*', 'Color', 'c')
% plot(angCCW(find(idx == 2)), angCW(find(idx == 2)), '*', 'Color', 'b')
% plot(angCCW(find(idx == 3)), angCW(find(idx == 3)), '*', 'Color', 'g')
% plot(angCCW(find(idx == 4)), angCW(find(idx == 4)), '*', 'Color', 'm')
% xlim([180 3*180])
% ylim([180 3*180])
% xlabel('mean angular position CCW')
% ylabel('mean angular position CW')
% xticks([180, 2*180, 3*180])
% xticklabels([-180, 0, 180])
% yticks([180, 2*180, 3*180])
% yticklabels([-180, 0, 180])
% box on
% 
% % wid cw ccw
% subplot(1,3,2)
% axis equal
% hold on
% % plot([0 0],[180 540],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% % plot([180 540],[0 0],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% patch([360 540 540 360], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
% patch([360 0 0 360], [540 540, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
% plot(widCCW(find(idx == 1)), widCW(find(idx == 1)), '*', 'Color', 'c')
% plot(widCCW(find(idx == 2)), widCW(find(idx == 2)), '*', 'Color', 'b')
% plot(widCCW(find(idx == 3)), widCW(find(idx == 3)), '*', 'Color', 'g')
% plot(widCCW(find(idx == 4)), widCW(find(idx == 4)), '*', 'Color', 'm')
% % plot(widCCW, widCW, '*', 'Color', col)
% xlim([0 360])
% ylim([0 360])
% xlabel('full width at half maximum CCW')
% ylabel('full width at half maximum CW')
% xticks([0 90 180 270 360])
% yticks([0 90 180 270 360])
% box on
% 
% % wid - ang
% subplot(1,3,2)
% axis equal
% hold on
% % plot([0 0],[180 540],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% % plot([180 540],[0 0],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% patch([360 540 540 360], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
% patch([360 0 0 360], [540 540, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
% plot(widCCW(find(idx == 1)), angCCW(find(idx == 1)), '*', 'Color', 'c')
% plot(widCCW(find(idx == 2)), widCW(find(idx == 2)), '*', 'Color', 'b')
% plot(widCCW(find(idx == 3)), widCW(find(idx == 3)), '*', 'Color', 'g')
% plot(widCCW(find(idx == 4)), widCW(find(idx == 4)), '*', 'Color', 'm')
% % plot(widCCW, widCW, '*', 'Color', col)
% xlim([0 360])
% ylim([0 360])
% xlabel('full width at half maximum CCW')
% ylabel('full width at half maximum CW')
% xticks([0 90 180 270 360])
% yticks([0 90 180 270 360])
% box on
% set(gcf,'position',[500 50 880 420])

%% %%%%%%%%%%%%%%%%%%%%%%%
% ocularity
% find positions
Bino1 = find(angCCW > 180*2 & angCW < 180*2);
Bino2 = find(angCCW < 180*2 & angCW > 180*2);
Mono1 = find(angCCW > 180*2 & angCW > 180*2);
Mono2 = find(angCCW < 180*2 & angCW < 180*2);


figure
a = 360;
%%%%% mono %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,2)
axis equal
hold on
title('monocular')
patch([270 450 450 270], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot([360 360],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
plot(angCW(Mono1), widCW(Mono1), 'o', 'Color', 'b')
plot(angCCW(Mono1), widCCW(Mono1), 'x', 'Color', 'b')
plot(a-angCW(Mono2)+a, widCW(Mono2), 'o', 'Color', 'b')
plot(a-angCCW(Mono2)+a, widCCW(Mono2), 'x', 'Color', 'b')
xlim([180 3*180])
ylim([0 360])
xlabel('mean angular position')
ylabel('full width at half maximum')
xticks([180, 2*180, 3*180])
xticklabels([-180, 0, 180])
yticks([0 90 180 270 360])
box on

subplot(1,3,1)
% axis equal
daspect([1 1 1])
hold on
% title('monocular')
% plot([360 360],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
patch([360 540 540 360], [180 180, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
patch([180 360 360 180], [360 360, 540 540], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCCW(Mono1), angCW(Mono1), '*', 'Color', 'b')
plot(a-angCCW(Mono2)+a, a-angCW(Mono2)+a, '*', 'Color', 'b')
xlim([180 3*180])
ylim([180 3*180])
xlabel('mean angular position ccw')
ylabel('mean angular position cw')
xticks([180, 2*180, 3*180])
xticklabels([-180, 0, 180])
yticks([180, 2*180, 3*180])
yticklabels([-180, 0, 180])
% plot([270 270],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% plot([450 450],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
box on

% diff
% subplot(2,3,3)
% axis equal
% hold on
% title('monocular cw-ccw')
% plot(angCW(Mono1)-angCCW(Mono1), widCW(Mono1)-widCCW(Mono1), '*', 'Color', 'b')
% plot((a-angCW(Mono2)+a)-(a-angCCW(Mono2)+a), widCW(Mono2)-widCCW(Mono2), '*', 'Color', 'g')
% xlim([-360 360])
% ylim([-360 360])
% xlabel('diff(mean angular position)')
% ylabel('diff(full width at half maximum)')
% xticks([-360, -180, 0, 180, 360])
% xticklabels([-360 -180 0 180 360])
% yticks([-360 -180 0 180 360])
% yticklabels([-360 -180 0 180 360])
% box on
% plot([0 0],[-360 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% plot([-360 360],[0 0],'--','Color',[.6 .6 .6 .5],'LineWidth',1)

%%%%%% bino %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,3)
daspect([1 1 1])
hold on
title('binocular')
patch([270 450 450 270], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot([360 360],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
plot(angCCW(Bino1), widCCW(Bino1), 'x', 'Color', 'm')
plot(a-angCCW(Bino2)+a, widCCW(Bino2), 'x', 'Color', 'm')
plot(angCW(Bino1), widCW(Bino1), 'o', 'Color', 'm')
plot(a-angCW(Bino2)+a, widCW(Bino2), 'o', 'Color', 'm')
xlim([180 3*180])
ylim([0 360])
xlabel('mean angular position')
ylabel('full width at half maximum')
xticks([180, 2*180, 3*180])
xticklabels([-180, 0, 180])
yticks([0 90 180 270 360])
box on

subplot(1,3,1)
% axis equal
daspect([1 1 1])
hold on
% title('binocular')
% plot([360 360],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
patch([360 540 540 360], [180 180, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
patch([180 360 360 180], [360 360, 540 540], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCCW(Bino1), angCW(Bino1), '*', 'Color', 'm')
plot(a-angCCW(Bino2)+a, a-angCW(Bino2)+a, '*', 'Color', 'm')
xlim([180 3*180])
ylim([180 3*180])
xlabel('mean angular position ccw')
ylabel('mean angular position cw')
xticks([180, 2*180, 3*180])
xticklabels([-180, 0, 180])
yticks([180, 2*180, 3*180])
yticklabels([-180, 0, 180])
% plot([270 270],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% plot([450 450],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
box on

% diff
% subplot(2,3,6)
% axis equal
% hold on
% title('binocular cw-ccw')
% plot(angCW(Bino1)-angCCW(Bino1), widCW(Bino1)-widCCW(Bino1), '*', 'Color', 'c')
% plot((a-angCW(Bino2)+a)-(a-angCCW(Bino2)+a), widCW(Bino2)-widCCW(Bino2), '*', 'Color', 'm')
% xlim([-360 360])
% ylim([-360 360])
% xlabel('diff(mean angular position)')
% ylabel('diff(full width at half maximum)')
% xticks([-360, -180, 0, 180, 360])
% xticklabels([-360 -180 0 180 360])
% yticks([-360 -180 0 180 360])
% yticklabels([-360 -180 0 180 360])
% box on
% plot([0 0],[-360 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% plot([-360 360],[0 0],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
set(gcf,'position',[210 200 1300 500])

%% boxplot for diff
clear temp
if size(Mono1,2) + size(Mono2,2) < size(Bino1,2) + size(Bino2,2)
    si = size(Bino1,2) + size(Bino2,2);
else
    si = size(Mono1,2) + size(Mono2,2);
end
temp(1:si,1:2) = NaN;
temp(1:size(Mono1,2) + size(Mono2,2),1) = abs([angCW(Mono1)-angCCW(Mono1) (a-angCW(Mono2)+a)-(a-angCCW(Mono2)+a)]);
temp(1:size(Bino1,2) + size(Bino2,2),2) = abs([angCW(Bino1)-angCCW(Bino1) (a-angCW(Bino2)+a)-(a-angCCW(Bino2)+a)]);

temp2 = [temp(:,1); temp(:,2)];
temp2(:,2) = zeros(size(temp,1)*2,1);
% Boxplot_B(temp,2,15,[0.75 0.75 1; 1 0.75 1],{'M','B'},{'M','B'})
Boxplot_B(temp2,2,15,[0.75 0.75 1; 1 0.75 1],{'M','B'},{'M','B'})
hold on
ylim([0 360])
yticks([0 90 180 270 360])
yticklabels([0 90 180 270 360])
set(gcf,'position',[500 400 280 330])
xlabel('Ocularity')
ylabel('mean angular position (°)')
plot(ones(length(temp2(:,1)),1),temp2(:,1),'.','Color',[0 0 1])
plot(ones(length(temp2(:,2)),1)+1,temp2(:,2),'.','Color',[1 0 1])
savefig(['ExcBi_Ocularity_BP_cluster',num2str(clust),'.fig'])
print(['ExcBi_Ocularity__BP_cluster',num2str(clust)],'-depsc','-r300','-tiff','-painters')

%% tuning curves
% figure(5)
% 
% %%%%% mono fw
% clear temp
% subplot(2,2,1)
% hold on
% title('monocular - fw')
% c = 1;
% for i = 1 : length(Mono1)
%     temp(c,:) = AllAni(Mono1(i)).R01.yfreq.mean.translation.fw.w8/max(AllAni(Mono1(i)).R01.yfreq.mean.translation.fw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1;
% end
% for i = 1 : length(Mono2)
%     temp(c,:) = AllAni(Mono2(i)).R01.yfreq.mean.translation.fw.w8/max(AllAni(Mono2(i)).R01.yfreq.mean.translation.fw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1
% end
% plot([.5 1 5 10 20 40 60 80 100 120],mean(temp),'-','Color',[.6 .6 .6 1],'LineWidth',2)
% set(gca,'XScale','log','Box','on','xtick',[10^-1 10^0 10^1 10^2],'xticklabels',{'0.1','1','10','100'})
% xlim([10^-0.5 10^2.3])
% ylim([0 1])
% 
% %%%%% mono bw
% clear temp
% subplot(2,2,3)
% hold on
% title('monocular - bw')
% c = 1;
% for i = 1 : length(Mono1)
%     temp(c,:) = AllAni(Mono1(i)).R01.yfreq.mean.translation.bw.w8/max(AllAni(Mono1(i)).R01.yfreq.mean.translation.bw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1;
% end
% for i = 1 : length(Mono2)
%     temp(c,:) = AllAni(Mono2(i)).R01.yfreq.mean.translation.bw.w8/max(AllAni(Mono2(i)).R01.yfreq.mean.translation.bw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1;
% end
% plot([.5 1 5 10 20 40 60 80 100 120],mean(temp),'-','Color',[.6 .6 .6 1],'LineWidth',2)
% set(gca,'XScale','log','Box','on','xtick',[10^-1 10^0 10^1 10^2],'xticklabels',{'0.1','1','10','100'})
% xlim([10^-0.5 10^2.3])
% ylim([0 1])
% 
% 
% %%%%% bino fw
% clear temp
% subplot(2,2,2)
% hold on
% title('binocular - fw')
% c = 1;
% for i = 1 : length(Bino1)
%     temp(c,:) = AllAni(Bino1(i)).R01.yfreq.mean.translation.fw.w8/max(AllAni(Bino1(i)).R01.yfreq.mean.translation.fw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1;
% end
% for i = 1 : length(Bino2)
%     temp(c,:) = AllAni(Bino2(i)).R01.yfreq.mean.translation.fw.w8/max(AllAni(Bino2(i)).R01.yfreq.mean.translation.fw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1;
% end
% plot([.5 1 5 10 20 40 60 80 100 120],mean(temp),'-','Color',[.6 .6 .6 1],'LineWidth',2)
% set(gca,'XScale','log','Box','on','xtick',[10^-1 10^0 10^1 10^2],'xticklabels',{'0.1','1','10','100'})
% xlim([10^-0.5 10^2.3])
% ylim([0 1])
% 
% 
% %%%%% bino bw
% clear temp
% subplot(2,2,4)
% hold on
% title('binocular - bw')
% c = 1;
% for i = 1 : length(Bino1)
%     temp(c,:) = AllAni(Bino1(i)).R01.yfreq.mean.translation.bw.w8/max(AllAni(Bino1(i)).R01.yfreq.mean.translation.bw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1;
% end
% for i = 1 : length(Bino2)
%     temp(c,:) = AllAni(Bino2(i)).R01.yfreq.mean.translation.bw.w8/max(AllAni(Bino2(i)).R01.yfreq.mean.translation.bw.w8);
%     plot([0.5 1 5 10 20 40 60 80 100 120],temp(c,:),'-','Color',[.6 .6 .6 .3],'LineWidth',1.5)
%     c = c + 1;
% end
% plot([.5 1 5 10 20 40 60 80 100 120],mean(temp),'-','Color',[.6 .6 .6 1],'LineWidth',2)
% set(gca,'XScale','log','Box','on','xtick',[10^-1 10^0 10^1 10^2],'xticklabels',{'0.1','1','10','100'})
% xlim([10^-0.5 10^2.3])
% ylim([0 1])
% 
% set(gcf,'position',[200 300 650 500])
% 
%% k means
% X = [angCCW' widCCW'];
% idx = kmeans(X,3);
% figure
% plot(X(idx==1,1),X(idx==1,2),'b.','MarkerSize',12)
% hold on
% plot(X(idx==2,1),X(idx==2,2),'r.','MarkerSize',12)
% plot(X(idx==3,1),X(idx==3,2),'c.','MarkerSize',12)
% plot(X(idx==4,1),X(idx==4,2),'m.','MarkerSize',12)
% plot(X(idx==5,1),X(idx==5,2),'g.','MarkerSize',12)

%%
% wcss = zeros(1, 10);
% for k = 2:10 % WCSS for different num of clusters
%     [idx, centroid] = kmeans(X, k);
%     distances = sum((X - centroid(idx, :)).^2, 2);
%     wcss(k) = sum(distances);
% end
% figure;
% plot(1:10, wcss, 'o-');
% xlabel('Number of Clusters');
% ylabel('WCSS');

%% tuning curves
% Data = AllAni;
% AllAni = Data(idx == 4);
% clear temp
% figure; hold on
% for i = 1 : size(AllAni,2)
%     temp(i,:) = AllAni(i).R01.yfreq.mean.translation.fw.w8/max(AllAni(i).R01.yfreq.mean.translation.fw.w8);
%     plot([.5 1 5 10 20 40 60 80 100 120],temp(i,:),'-','Color',[.8 .8 .8 .5])
% end
% plot([.5 1 5 10 20 40 60 80 100 120],mean(temp),'-','Color',[.2 .2 .2 1],'LineWidth',2)
% set(gca,'XScale','log','Box','on','xtick',[10^-1 10^0 10^1 10^2],'xticklabels',{'0.1','1','10','100'})
% 


%% stats zu boxplot width
% CW
[kwCW,~,stats] = kruskalwallis(bpCW); close; 
resultsCW = multcompare(stats,'CType','bonferroni'); close; 

% CCW
[kwCCW,~,stats] = kruskalwallis(bpCCW); close; 
resultsCCW = multcompare(stats,'CType','bonferroni'); close;

% posthoc
for i = 1 : 4
    for j = 1 : 4
        statsCW(i,j) = ranksum(bpCW(:,i),bpCW(:,j));
        statsCCW(i,j) = ranksum(bpCCW(:,i),bpCCW(:,j));
        cohenCW(i,j) = computeCohen_d(bpCW(:,i),bpCW(:,j));
        cohenCCW(i,j) = computeCohen_d(bpCCW(:,i),bpCCW(:,j));
    end
end
pnew = [0.05/6 0.01/6 0.001/6];

save RFWidth_BP_stats_cluster.mat  kwCW kwCCW statsCW statsCCW resultsCW resultsCCW cohenCW cohenCCW pnew

