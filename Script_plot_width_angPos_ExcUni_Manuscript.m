clear all
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\RF\Results_all_addRF_extended.mat')
clearvars -except AllAni
% close all
load('\\132.187.28.171\home\rest\Manuskript\I_Optic_flow\JEB\data\classification\Results_groups_manuscript.mat')
w = 2;
v = 20;

close all

% excuni1
% start = 104;
% stop = 116;
% col = [.3 .3 .3];

%excuni2
start = 117;
stop = 128;
col = [.3 .3 .3];
%%

for i = start : stop %1 : size(AllAni,2)
    if isempty(AllAni(i).RF1)
        widCCW(i) = NaN;
        statsCCW(i) = NaN;
        angCCW(i) = NaN;
    else
        stim = find([AllAni(i).RF1.vel] == -v & [AllAni(i).RF1.width] == w);
        statsCCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
        if isnan(statsCCW(i)) %| statsCCW(i) > 0.05
            widCCW(i) = NaN;
            statsCCW(i) = NaN;
            angCCW(i) = NaN;
        else
            if AllAni(i).RF1(stim).RFangPos.val < 180
                angCCW(i) = AllAni(i).RF1(stim).RFangPos.val+360;
            else
                angCCW(i) = AllAni(i).RF1(stim).RFangPos.val;
            end
            widCCW(i) = AllAni(i).RF1(stim).RFwidth.diffW;
            statsCCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
        end
    end
end

angCCW = 360-angCCW+360;

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


for i = start : stop %1 : size(AllAni,2)
    if isempty(AllAni(i).RF1)
        widCW(i) = NaN;
        statsCW(i) = NaN;
        angCW(i) = NaN;
    else
        stim = find([AllAni(i).RF1.vel] == v & [AllAni(i).RF1.width] == w);
        statsCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
        if isnan(statsCW(i))% | statsCW(i) > 0.05
            widCW(i) = NaN;
            statsCW(i) = NaN;
            angCW(i) = NaN;
        else
            if AllAni(i).RF1(stim).RFangPos.val < 180
                angCW(i) = AllAni(i).RF1(stim).RFangPos.val+360;
            else
                angCW(i) = AllAni(i).RF1(stim).RFangPos.val;
            end
            widCW(i) = AllAni(i).RF1(stim).RFwidth.diffW;
            statsCW(i) = AllAni(i).RF1(stim).RFangPos.statsP;
        end
    end
end

subplot(1,3,2)
axis equal
hold on
title('cw')
plot([360 360],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
patch([270 450 450 270], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCW, widCW, 'o', 'Color', col)
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


%% ang cw ccw
figure(2)
subplot(1,2,1)
axis equal
hold on
% plot([0 0],[180 540],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% plot([180 540],[0 0],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
patch([360 540 540 360], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
patch([360 0 0 360], [540 540, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCCW, angCW, '*', 'Color', col)
xlim([180 3*180])
ylim([180 3*180])
xlabel('mean angular position CCW')
ylabel('mean angular position CW')
xticks([180, 2*180, 3*180])
xticklabels([-180, 0, 180])
yticks([180, 2*180, 3*180])
yticklabels([-180, 0, 180])
box on

% wid cw ccw
subplot(1,2,2)
axis equal
hold on
% plot([0 0],[180 540],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
% plot([180 540],[0 0],'--','Color',[.8 .8 .8 .5],'LineWidth',2)
patch([360 540 540 360], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
patch([360 0 0 360], [540 540, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(widCCW, widCW, '*', 'Color', col)
xlim([0 360])
ylim([0 360])
xlabel('full width at half maximum CCW')
ylabel('full width at half maximum CW')
xticks([0 90 180 270 360])
yticks([0 90 180 270 360])
box on
set(gcf,'position',[500 50 880 420])

%% bino mono
% find positions
Bino1 = find(angCCW > 180*2 & angCW < 180*2);
Bino2 = find(angCCW < 180*2 & angCW > 180*2);
Mono1 = find(angCCW > 180*2 & angCW > 180*2);
Mono2 = find(angCCW < 180*2 & angCW < 180*2);


figure(3)

%%%%% mono %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,2)
axis equal
hold on
title('monocular')
plot([360 360],[0 360],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
patch([270 450 450 270], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCW, widCW, '*', 'Color', col)
plot(angCCW, widCCW, 'x', 'Color', col)
xlim([180 3*180])
ylim([0 360])
xlabel('mean angular position')
ylabel('full width at half maximum')
xticks([180, 2*180, 3*180])
xticklabels([-180, 0, 180])
yticks([0 90 180 270 360])
box on

subplot(1,3,1)
axis equal
hold on
title('monocular')
patch([360 540 540 360], [0 0, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
patch([360 0 0 360], [540 540, 360 360], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
% plot([360 360],[180 360+180],'--','Color',[.6 .6 .6 .5],'LineWidth',1)
% patch([270 450 450 270], [180 180, 360+180 360+180], [0.9 0.9 0.9],'EdgeColor','none','FaceAlpha',.5)
plot(angCCW, angCW, 'o', 'Color', col)
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
subplot(1,3,3)
axis equal
hold on
title('monocular cw-ccw')
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




