%% 4 %% plot whole group
% specify group to plot
group = 'eu2';

% prepare workspace
clearvars -except group 
close all
load ColormapZPosDataReduced3
zposCol = flipud(zposCol);
% load standard brain grey data (as nifti, convert to uint8)
im = niftiread('X:\für Bianca\von Keram\Bombus_Standard_brain\average.nii');
standard = imrotate(uint8(im),270);
%store image database to the guidata struct as well
h.standard = standard(1:621,100:720,:);
temp = 255-standard;
h.standardI = temp(1:621,100:720,:);
temp2 = h.standardI;
h.standardI = temp2(size(temp2,1)/2-300:size(temp2,1)/2+300,size(temp2,2)/2-300:size(temp2,2)/2+300,:);
IM2 = h.standardI(:,:,180);
IM2 = permute(IM2,[1 2 4 3]); 

% plot brain scan stored in IM2
figure
imshow(IM2)
hold on


% load and plot recording positions
folder = dir(group);
c = 1;
for i = 1 : size(folder,1)
    if contains(folder(i).name,'.mat')
        load([group,'/',folder(i).name])
        tempz(i) = zpos; 
        zpos = zpos - 127 + 1; % lower limit of colormap
        plot(xpos*1.6429,ypos*1.6429,'o','Color',zposCol(zpos,:),'MarkerSize',3,'MarkerFaceColor',zposCol(zpos,:))
        pos(c,:) = [xpos*1.6429*3.9;(ypos*1.6429-40)*3.9;zpos*3.9;];
        c = c + 1;
    end
end

% save figures
% savefig(['Anatomy_',group,'.fig'])
% print(['Anatomy_',group],'-depsc','-r300','-tiff','-painters')

%% boxplot for cluster
clearvars
close all
load anatomy_position_cluster
c1(9:17,:) = NaN;
c2(13:17,:) = NaN;
c4(10:17,:) = NaN;
bpx = [c1(:,1) c2(:,1) c3(:,1) c4(:,1)];
Boxplot_B(bpx,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
ylim([0 2344])
set(gcf,'position',[300 350 290 330])
title('xpos')
hold on
plot([0 5],[1172 1172],'--','Color',[.5 .5 .5 .3],'LineWidth',1.2)
for i = 1 : 4
    x = ones(size(bpx,1),1).*(1+(rand(size(bpx,1),1)*4-2)/10);
    x = ones(size(bpx,1),1);
    scatter(x+i-1,bpx(:,i),10,'filled','MarkerFaceColor',[.5 .5 .5])
end
savefig('Anatomy_BP_xpos.fig')
print('Anatomy_BP_xpos','-depsc','-r300','-tiff','-painters')

bpy = [c1(:,2) c2(:,2) c3(:,2) c4(:,2)];
Boxplot_B(bpy,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
ylim([0 1521])
set(gcf,'position',[700 350 290 330])
title('ypos')
hold on
plot([0 5],[760 760],'--','Color',[.5 .5 .5 .3],'LineWidth',1.2)
for i = 1 : 4
    x = ones(size(bpy,1),1).*(1+(rand(size(bpy,1),1)*4-2)/10);
    x = ones(size(bpy,1),1);
    scatter(x+i-1,bpy(:,i),10,'filled','MarkerFaceColor',[.5 .5 .5])
end
savefig('Anatomy_BP_ypos.fig')
print('Anatomy_BP_ypos','-depsc','-r300','-tiff','-painters')

bpz = [c1(:,3) c2(:,3) c3(:,3) c4(:,3)];
Boxplot_B(bpz,4,15,[.75 .75 .75; .75 .75 .75; .75 .75 .75; .75 .75 .75],{'1','2','3','4'},{'1','2','3','4'})
ylim([0 500])
set(gcf,'position',[1100 350 290 330])
title('zpos')
hold on
plot([0 5],[390-300 390-300],'--','Color',[.0 .75 .0 .3],'LineWidth',1.2)
plot([0 5],[624-300 624-300],'--','Color',[.0 .75 .0 .3],'LineWidth',1.2)
for i = 1 : 4
    x = ones(size(bpz,1),1).*(1+(rand(size(bpz,1),1)*4-2)/10);
    x = ones(size(bpz,1),1);
    scatter(x+i-1,bpz(:,i),10,'filled','MarkerFaceColor',[.5 .5 .5])
end
savefig('Anatomy_BP_zpos.fig')
print('Anatomy_BP_zpos','-depsc','-r300','-tiff','-painters')

% stats
kwx = kruskalwallis(bpx); close; close;
resultsx = multcompare(stats,'CType','bonferroni'); close; close;
kwy = kruskalwallis(bpy); close; close;
resultsy = multcompare(stats,'CType','bonferroni'); close; close;
kwz = kruskalwallis(bpz); close; close;
resultsz = multcompare(stats,'CType','bonferroni'); close; close;

for i = 1 : 4
    for j = 1 : 4
        statsx(i,j) = ranksum(bpx(:,i),bpx(:,j));
        statsy(i,j) = ranksum(bpy(:,i),bpy(:,j));
        statsz(i,j) = ranksum(bpz(:,i),bpz(:,j));
    end
end

save Anatomy_BP_stats_cluster.mat  kwx kwy kwz statsx statsy statsz resultsx resultsy resultsz

%% boxplot for eu1 and eu2
clearvars
close all
load anatomy_position_eu.mat
eu2(7:9,:) = NaN;
bpx = [eu1(:,1) eu2(:,1)];
Boxplot_B(bpx,2,15,[.75 .75 .75; .75 .75 .75],{'eu1','eu2'},{'1','2'})
ylim([0 2344])
set(gcf,'position',[300 350 290 330])
title('xpos')
hold on
plot([0 5],[1172 1172],'--','Color',[.5 .5 .5 .3],'LineWidth',1.2)
for i = 1 : 2
    x = ones(size(bpx,1),1).*(1+(rand(size(bpx,1),1)*4-2)/10);
    x = ones(size(bpx,1),1);
    scatter(x+i-1,bpx(:,i),10,'filled','MarkerFaceColor',[.5 .5 .5])
end
% savefig('Anatomy_BP_xpos.fig')
% print('Anatomy_BP_xpos','-depsc','-r300','-tiff','-painters')

bpy = [eu1(:,2) eu2(:,2)];
Boxplot_B(bpy,2,15,[.75 .75 .75; .75 .75 .75],{'eu1','eu2'},{'1','2'})
ylim([0 1521])
set(gcf,'position',[700 350 290 330])
title('ypos')
hold on
plot([0 5],[760 760],'--','Color',[.5 .5 .5 .3],'LineWidth',1.2)
for i = 1 : 2
    x = ones(size(bpy,1),1).*(1+(rand(size(bpy,1),1)*4-2)/10);
    x = ones(size(bpy,1),1);
    scatter(x+i-1,bpy(:,i),10,'filled','MarkerFaceColor',[.5 .5 .5])
end
% savefig('Anatomy_BP_ypos.fig')
% print('Anatomy_BP_ypos','-depsc','-r300','-tiff','-painters')

bpz = [eu1(:,3) eu2(:,3)];
Boxplot_B(bpz,2,15,[.75 .75 .75; .75 .75 .75],{'eu1','eu2'},{'1','2'})
ylim([0 500])
set(gcf,'position',[1100 350 290 330])
title('zpos')
hold on
plot([0 5],[390-300 390-300],'--','Color',[.0 .75 .0 .3],'LineWidth',1.2)
plot([0 5],[624-300 624-300],'--','Color',[.0 .75 .0 .3],'LineWidth',1.2)
for i = 1 : 2
    x = ones(size(bpz,1),1).*(1+(rand(size(bpz,1),1)*4-2)/10);
    x = ones(size(bpz,1),1);
    scatter(x+i-1,bpz(:,i),10,'filled','MarkerFaceColor',[.5 .5 .5])
end
% savefig('Anatomy_BP_zpos.fig')
% print('Anatomy_BP_zpos','-depsc','-r300','-tiff','-painters')

% stats
kwx = kruskalwallis(bpx); close; close;
resultsx = multcompare(stats,'CType','bonferroni'); close; close;
kwy = kruskalwallis(bpy); close; close;
resultsy = multcompare(stats,'CType','bonferroni'); close; close;
kwz = kruskalwallis(bpz); close; close;
resultsz = multcompare(stats,'CType','bonferroni'); close; close;

for i = 1 : 2
    for j = 1 : 2
        statsx(i,j) = ranksum(bpx(:,i),bpx(:,j));
        statsy(i,j) = ranksum(bpy(:,i),bpy(:,j));
        statsz(i,j) = ranksum(bpz(:,i),bpz(:,j));
    end
end

save Anatomy_BP_stats_eu.mat  kwx kwy kwz statsx statsy statsz resultsx resultsy resultsz
