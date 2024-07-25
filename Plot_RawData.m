
% clear all
% load('\\132.187.28.150\home\Data\Ephys\210422_A15\Recording01\210422_A15_R01.mat')
% load('\\132.187.28.171\home\Manuskript\I Optic flow\figures\figure1\A60\RawData.mat')


%% calcuate length of stimulus
temp = find(Ch13.values < -0.01);
j = 1; 
for i = 1 : length(find(Ch13.values < - 0.01))-1
    if (temp(i) - temp(i+1)) < -5
        a = temp(i);
        t(j) = Ch13.times(a);
        j = j + 1;
    end
end
l = 1;
for i = 1 : 4
    t_l(l) = t(i+1) - t(i);
    l = l + 1;
end
t_length = mean(t_l)*5;
stim_start(2) = t(1);
stim_start(4) = t(6);
stim_start(6) = t(11);
stim_start(8) = t(16);

%% to find arena2 values
clear temp a t t_l j l 
temp = find(Ch14.values < -0.02);
j = 1; 
for i = 1 : length(find(Ch14.values < - 0.02))-1
    if (temp(i) - temp(i+1)) < -5
        a = temp(i);
        t(j) = Ch14.times(a);
        j = j + 1;
    end
end
l = 1;
for i = 1 : 4
    t_l(l) = t(i+1) - t(i);
    l = l + 1;
end
stim_start(1) = t(1);
stim_start(3) = t(6);
stim_start(5) = t(11);
stim_start(7) = t(16);

%% end values
stim_end = stim_start + t_length;
% figure
% plot(Ch3.times,Ch3.values)

% s = 100000;
% n = 4;
% figure
% plot(Ch3.times(find(Ch3.times > stim_start(n),1)-s:find(Ch3.times > stim_end(n),1)+s),Ch3.values(find(Ch3.times > stim_start(n),1)-s:find(Ch3.times > stim_end(n),1)+s))

%%
s = 5;
stim_start(1:7) = [504.4191 729.82886 759.8887 985.27879 1075.4488 549.48973 0];
stim_end(1:7) = [0 509.42063 734.83009 764.88907 990.27946 1080.4515 554.49165];
n1 = 5;
n2 = n1 + 1;
figure
subplot(11,1,1)
hold on;
% plot([stim_start(n1) stim_start(n1)],[-4.0000e-04 4.0000e-04],'Color',[230/255 115/255 184/255])
% plot([stim_end(n2) stim_end(n2)],[-4.0000e-04 4.0000e-04],'Color',[230/255 115/255 184/255])
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [1.0e-03*-0.5 1.0e-03*-0.5, 1.0e-03*0.5 1.0e-03*0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch3.times(find(Ch3.times > stim_start(n1)-s,1):find(Ch3.times > stim_end(n2)+s,1)),Ch3.values(find(Ch3.times > stim_start(n1)-s,1):find(Ch3.times > stim_end(n2)+s,1)),'Color',[.25 .25 .25])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,2)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [1.0e-03*-0.5 1.0e-03*-0.5, 1.0e-03*0.5 1.0e-03*0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch4.times(find(Ch4.times > stim_start(n1)-s,1):find(Ch4.times > stim_end(n2)+s,1)),Ch4.values(find(Ch4.times > stim_start(n1)-s,1):find(Ch4.times > stim_end(n2)+s,1)),'Color',[.25 .25 .25])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,3)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [1.0e-03*-0.5 1.0e-03*-0.5, 1.0e-03*0.5 1.0e-03*0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch5.times(find(Ch5.times > stim_start(n1)-s,1):find(Ch5.times > stim_end(n2)+s,1)),Ch5.values(find(Ch5.times > stim_start(n1)-s,1):find(Ch5.times > stim_end(n2)+s,1)),'Color',[.25 .25 .25])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,4)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [1.0e-03*-0.5 1.0e-03*-0.5, 1.0e-03*0.5 1.0e-03*0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch6.times(find(Ch6.times > stim_start(n1)-s,1):find(Ch6.times > stim_end(n2)+s,1)),Ch6.values(find(Ch6.times > stim_start(n1)-s,1):find(Ch6.times > stim_end(n2)+s,1)),'Color',[.25 .25 .25])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,5)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [1.0e-03*-0.5 1.0e-03*-0.5, 1.0e-03*0.5 1.0e-03*0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch7.times(find(Ch7.times > stim_start(n1)-s,1):find(Ch7.times > stim_end(n2)+s,1)),Ch7.values(find(Ch7.times > stim_start(n1)-s,1):find(Ch7.times > stim_end(n2)+s,1)),'Color',[.25 .25 .25])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[-0.0005 0 0.0005],'YTickLabels',{'-0.0005', '0', '0.0005'},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,6)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [-0.5 -0.5, 0.5 0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
% plot(Ch16.times(find(Ch16.times > stim_start(n1)-s,1):find(Ch16.times > stim_end(n2)+s,1)),zeros(length(Ch16.times(find(Ch16.times > stim_start(n1)-s,1):find(Ch16.times > stim_end(n2)+s,1))),1),'|','Color',[.25 .25 .25])
plot(Ch17.times(find(Ch17.times > stim_start(n1)-s,1):find(Ch17.times > stim_end(n2)+s,1)),zeros(length(Ch17.times(find(Ch17.times > stim_start(n1)-s,1):find(Ch17.times > stim_end(n2)+s,1))),1),'|','Color',[128/255 0 128/255])
plot(Ch18.times(find(Ch18.times > stim_start(n1)-s,1):find(Ch18.times > stim_end(n2)+s,1)),zeros(length(Ch18.times(find(Ch18.times > stim_start(n1)-s,1):find(Ch18.times > stim_end(n2)+s,1))),1),'|','Color',[87/255 87/255 87/255])
plot(Ch19.times(find(Ch19.times > stim_start(n1)-s,1):find(Ch19.times > stim_end(n2)+s,1)),zeros(length(Ch19.times(find(Ch19.times > stim_start(n1)-s,1):find(Ch19.times > stim_end(n2)+s,1))),1),'|','Color',[0 128/255 192/255])
plot(Ch20.times(find(Ch20.times > stim_start(n1)-s,1):find(Ch20.times > stim_end(n2)+s,1)),zeros(length(Ch20.times(find(Ch20.times > stim_start(n1)-s,1):find(Ch20.times > stim_end(n2)+s,1))),1),'|','Color',[192/255 64/255 255/255])
plot(Ch21.times(find(Ch21.times > stim_start(n1)-s,1):find(Ch21.times > stim_end(n2)+s,1)),zeros(length(Ch21.times(find(Ch21.times > stim_start(n1)-s,1):find(Ch21.times > stim_end(n2)+s,1))),1),'|','Color',[128/255 128/255 0])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,7)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [-0.5 -0.5, 0.5 0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch17.times(find(Ch17.times > stim_start(n1)-s,1):find(Ch17.times > stim_end(n2)+s,1)),zeros(length(Ch17.times(find(Ch17.times > stim_start(n1)-s,1):find(Ch17.times > stim_end(n2)+s,1))),1),'|','Color',[128/255 0 128/255])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,8)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [-0.5 -0.5, 0.5 0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch18.times(find(Ch18.times > stim_start(n1)-s,1):find(Ch18.times > stim_end(n2)+s,1)),zeros(length(Ch18.times(find(Ch18.times > stim_start(n1)-s,1):find(Ch18.times > stim_end(n2)+s,1))),1),'|','Color',[87/255 87/255 87/255])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,9)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [-0.5 -0.5, 0.5 0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch19.times(find(Ch19.times > stim_start(n1)-s,1):find(Ch19.times > stim_end(n2)+s,1)),zeros(length(Ch19.times(find(Ch19.times > stim_start(n1)-s,1):find(Ch19.times > stim_end(n2)+s,1))),1),'|','Color',[0 128/255 192/255])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,10)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [-0.5 -0.5, 0.5 0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch20.times(find(Ch20.times > stim_start(n1)-s,1):find(Ch20.times > stim_end(n2)+s,1)),zeros(length(Ch20.times(find(Ch20.times > stim_start(n1)-s,1):find(Ch20.times > stim_end(n2)+s,1))),1),'|','Color',[192/255 64/255 255/255])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'XTick',[],'XTickLabels',{},'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])

subplot(11,1,11)
hold on;
patch([stim_start(n1) stim_end(n2) stim_end(n2) stim_start(n1)], [-0.5 -0.5, 0.5 0.5], [0.85 0.85 0.85],'EdgeColor','none','FaceAlpha',.5)
plot(Ch21.times(find(Ch21.times > stim_start(n1)-s,1):find(Ch21.times > stim_end(n2)+s,1)),zeros(length(Ch21.times(find(Ch21.times > stim_start(n1)-s,1):find(Ch21.times > stim_end(n2)+s,1))),1),'|','Color',[128/255 128/255 0])
set(gca,'color',[1 1 1],'Box','off','YLim',[1.0e-03*-0.5 1.0e-03*0.5],'YTick',[],'YTickLabels',{},'XLim',[stim_start(n1)-s stim_end(n2)+s])
