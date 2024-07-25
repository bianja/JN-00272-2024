% analyse Arena data
% script to analyse optic flow responses for a quick overview. Load files 
% exported from spike2 before running. Gives velocity and temporal 
% frequency plot for translation and rotation for three spatial 
% frequencies.
%
% 1. load mat file containing spike information (exported from Spike2)
% 2. load mat file containing stimulus information
% 3. run script 
%
% Version 03-03-2023

%% load data
% close all
clc
clearvars -except Ch1 Ch2 Ch8 Ch9 Ch10 Ch11 Ch12 Ch13 Ch14 Ch15 Ch16 Ch17 Ch18 Ch19 Ch20 Ch21 Ch22 Ch23 Ch24 Ch25 Ch26 Ch27 Ch28 Ch29 Ch30 Ch31 Ch32 Ch33 Ch34 Ch35 file rec
vars = inputdlg({'Number of units','Channel number of first unit','Number of stimuli repetitions'},...
              'Customer', [1 30; 1 30; 1 30]); 
unitnbr = str2double(vars{1}); % number of channels containing spike information (unit)
firstunit = str2double(vars{2})-1; % channel containing spike information of the first unit
rep = str2double(vars{3}); % number of repetitions of each stimuli
len = 120; % length of one repetition (results of number of temporal and spatial frequencies)
num = 10; % number of temporal frequencies used
file.name(14:16) = '171'; % correct for new server (if data was exported as mat-file on old server it will keep old server as file name/path) 

%% calculate spike frequency for stmuli
% 1. find all pings arena1 and arena2
% 2. extract time of start and end ping (there is one ping for start of motion and one ping for end of motion in the same channel)
% 3. count number of spikes in time windows and divide by stimulus length to get counts s^-1

% if exist('Ch100')    
% %     stim_times_all = findTimes(Ch1.times, Ch1.values, -0.015, rec); % Ch14 or Ch1
%     stim_times_all = Ch14.times(find(Ch14.values < -0.015)); % 10 for other recordings 0.17; 14; 1; 0.015
% else
%     stim_times_all = Ch14.times(find(Ch14.values < -0.015)); % 10 for other recordings 0.17; 14; 1; 0.015
% %     stim_times_all = findTimes(Ch14.times, Ch14.values, -0.015, rec); % Ch14 or Ch1
% end
% 
% stim_times_temp = zeros(len*rep*2,1);
% j = 1; 
% stim_times_temp(1) = stim_times_all(1);
% for i = 1 : length(stim_times_all) - 1
%     if stim_times_all(i+1) > stim_times_all(i)+1
%         stim_times_temp(j+1) = stim_times_all(i+1);
%         j = j + 1;
%     end
% end
% 
% stim_times_temp = stim_times_temp(1:rep*len*2);
% 
% stim_times_start = zeros(1,len*rep);
% stim_times_end = zeros(1,len*rep);
% c = 1;
% for i = 0 : 2 : length(stim_times_temp)-2 % 0:4:x for other recordings
%     stim_times_start(c) = stim_times_temp(i+1);  
%     stim_times_end(c) = stim_times_temp(i+2); 
%     c = c + 1;
% end
% 
% start_diff = diff(stim_times_start);
% for i = 1 : length(start_diff)
%     if start_diff(i) > 20 || start_diff(i) < 10 %== 1
%         start_diff(i) = NaN;
%     end
% end
% 
% for i = 1 : length(stim_times_start)
%     if stim_times_start(i) == 0
%         stim_times_start(i) = NaN;
%     end
% end
% diffVal = nanmedian(diff(stim_times_start(1:len))); 
% 
% temp_times = stim_times_start(1):diffVal:stim_times_start(end)+0.5;

% stim_times_startTEMP = stim_times_start;
% for i = 1 : length(stim_times_start)-1
%     timesDiff = round(diff(stim_times_startTEMP));
%     if timesDiff(i) ~= 15 && sum(i ~= [120:120:120*rep]) ~= 4
%         timesDiffTemp = timesDiff;
%         timeVal = stim_times_startTEMP(i)+(timesDiff(i)/2);
%         stim_times_startTEMP = [stim_times_startTEMP(1:i) timeVal stim_times_startTEMP(i+1:end)];
%     end
% end
% 
% 
% [stim_times_start, stim_times_end] = findTimes(Ch1.times, Ch1.values, -0.015, rep, diffVal);
% if exist('Ch100')    
%     [stim_times_start, stim_times_end] = findTimes(Ch10.times, Ch10.values, -0.015, rep, 15); % Ch14 or Ch1
% else
%     [stim_times_start, stim_times_end] = findTimes(Ch14.times, Ch14.values, -0.015, rep, 15); % Ch14 or Ch1
% end

[stim_times_start, stim_times_end] = findTimesCorrected(Ch1.times, Ch1.values, -0.015, rep, 5, 10, 120);

%% Calculate stimulus start and end times (find peaks, if distance between 
% % peak at pos i and i+1 larger 15 add time manually
% [pks,locs] = findpeaks(Ch14.values*-1,'MinPeakHeight',0.017,'MinPeakDistance',1);%,'MinPeakProminence',0.002);
% peakvalREP = Ch14.times(locs);
% clear tempPeakval 
% j = 1;
% for i = 1 : length(peakvalREP)-1 % remove double values
%     if round(peakvalREP(i+1)) == round(peakvalREP(i))
%     else
%         tempPeakval(j) = peakvalREP(i);
%         j = j + 1;
%     end
% end
% 
% clear peakvalREP
% peakvalREP = tempPeakval;
% if length(peakvalREP) < 120*rep*2
%     diffval = 120*rep*2 - length(peakvalREP);
%     for i = 1 : diffval
%         peakvalREP(end+1) = 1;
%     end
% end
% 
% peakLEN = length(peakvalREP);
% for i = 1 : peakLEN-1
%     if round(diff(peakvalREP(i:i+1))) == 25
%         peakvalREP = [peakvalREP(1:i) peakvalREP(i)+10 peakvalREP(i)+15 peakvalREP(i+1:length(peakvalREP)) ];
%     end
% end
% peakvalREP = peakvalREP(1:peakLEN);
% 
% % startvalues = [1 find(round(diff(tempPeakval)) > 100)+1 length(tempPeakval)];
% for i = 1 : rep
%     tempstart(i) = stim_times_start(i*120-120+1);
%     startvalues(i) = find(round(tempPeakval) == round(tempstart(i)));
% end
% clear stim_times_start stim_times_end
% %%
% j = 1; m = 0;
% for r = 1 : rep
%     clear peakval
%     peakval = peakvalREP(startvalues(r):startvalues(r)+120*2-1);
%     stim_times_start(r*120-120+1) = peakval(1);
%     j = j + 1; 
%     for i = 3 : 2 : length(peakval)-1
%         i = i - m;
%         m = 0;
%         if round(peakval(i)-stim_times_start(j-1)) == 15
%             stim_times_start(j) = peakval(i);
%             j = j + 1;
%         else
%             diffval = median(diff(stim_times_start));
%             stim_times_start(j) = stim_times_start(j-1)+diffval;
%             if ~isempty(find(round(peakval) == round(stim_times_start(j)+diffval)))
%                 m = i + 2 - find(round(peakval) == round(stim_times_start(j)+diffval));
%             else
%             end
%             j = j + 1;
%         end
%     end
% end
%      
% j = 1;m = 0;
% for r = 1 : rep
%     clear peakval
%     peakval = peakvalREP(startvalues(r):startvalues(r)+120*2-1);
%     stim_times_end(r*120-120+1) = peakval(2);
%     j = j + 1;
%     for i = 4 : 2 : length(peakval)
%         i = i - m;
%         m = 0;
%         if round(peakval(i)-stim_times_end(j-1)) == 15
%             stim_times_end(j) = peakval(i);
%             j = j + 1;
%         else
%             diffval = median(diff(stim_times_end));
%             stim_times_end(j) = stim_times_end(j-1)+diffval;
%             if ~isempty(find(round(peakval) == round(stim_times_end(j)+diffval)))
%                 m = i + 2 - find(round(peakval) == round(stim_times_end(j)+diffval));
%             else
%             end
%             j = j + 1;
%         end
%     end
% end

%% calculate spike count (per s), delay, and spike timings
for k = 1 : unitnbr
    count.(['unit0',num2str(k)]) = zeros(1,len*rep);
    f = 1;
        for i = 1 : len*rep
            temp = eval(['Ch',num2str(firstunit+k)]);
            count.(['unit0',num2str(k)])(i) = (sum((temp.times > stim_times_start(f)...
                & temp.times < stim_times_end(f)) == 1))/(stim_times_end(f) - stim_times_start(f));
            temp2 = find((temp.times > stim_times_start(f) & temp.times < stim_times_end(f)));
            temp3 = find((temp.times > stim_times_start(f)-5 & temp.times < stim_times_end(f)+5));
            if isempty(temp2) == 1
                temp2 = NaN;            
                delay.(['unit0',num2str(k)])(i) = NaN;
            else
                delay.(['unit0',num2str(k)])(i) = (temp.times(temp2(1)) - stim_times_start(f));
            end
            if isempty(temp3) == 1
                temp3 = NaN;            
                timings.(['unit0',num2str(k)]){i} = NaN;
            else
                timings.(['unit0',num2str(k)]){i} = (temp.times(temp3) - stim_times_start(f));
            end
            f = f + 1;
        end
end

if stim_times_end(1)-stim_times_start(1) < 6
else
    error('sth. wrong with start end times')
end

%% find positions and extract counts
pos.tp2 = find([rec(1:rep*len).vel] > 0 & [rec(1:rep*len).width] == 2 & contains({rec(1:rep*len).type},'translational'));
pos.tn2 = find([rec(1:rep*len).vel] < 0 & [rec(1:rep*len).width] == 2 & contains({rec(1:rep*len).type},'translational'));
pos.rp2 = find([rec(1:rep*len).vel] > 0 & [rec(1:rep*len).width] == 2 & contains({rec(1:rep*len).type},'rotational'));
pos.rn2 = find([rec(1:rep*len).vel] < 0 & [rec(1:rep*len).width] == 2 & contains({rec(1:rep*len).type},'rotational'));
pos.tp4 = find([rec(1:rep*len).vel] > 0 & [rec(1:rep*len).width] == 4 & contains({rec(1:rep*len).type},'translational'));
pos.tn4 = find([rec(1:rep*len).vel] < 0 & [rec(1:rep*len).width] == 4 & contains({rec(1:rep*len).type},'translational'));
pos.rp4 = find([rec(1:rep*len).vel] > 0 & [rec(1:rep*len).width] == 4 & contains({rec(1:rep*len).type},'rotational'));
pos.rn4 = find([rec(1:rep*len).vel] < 0 & [rec(1:rep*len).width] == 4 & contains({rec(1:rep*len).type},'rotational'));
pos.tp8 = find([rec(1:rep*len).vel] > 0 & [rec(1:rep*len).width] == 8 & contains({rec(1:rep*len).type},'translational'));
pos.tn8 = find([rec(1:rep*len).vel] < 0 & [rec(1:rep*len).width] == 8 & contains({rec(1:rep*len).type},'translational'));
pos.rp8 = find([rec(1:rep*len).vel] > 0 & [rec(1:rep*len).width] == 8 & contains({rec(1:rep*len).type},'rotational'));
pos.rn8 = find([rec(1:rep*len).vel] < 0 & [rec(1:rep*len).width] == 8 & contains({rec(1:rep*len).type},'rotational'));


% calculate background activity 
for i = 1 : unitnbr
    [background.sum.(['unit0',num2str(i)]), background.raw.(['unit0',num2str(i)]), spikes.(['unit0',num2str(i)]), exclude.(['unit0',num2str(i)])] = testData(stim_times_start, stim_times_end, eval(['Ch',num2str(i+firstunit)]), rep, len);
    [~, posexclude.tp2.(['unit0',num2str(i)])] = intersect(pos.tp2,exclude.(['unit0',num2str(i)]));  
    [~, posexclude.tp4.(['unit0',num2str(i)])] = intersect(pos.tp4,exclude.(['unit0',num2str(i)]));
    [~, posexclude.tp8.(['unit0',num2str(i)])] = intersect(pos.tp8,exclude.(['unit0',num2str(i)]));
end

for k = 1 : unitnbr % this loop is for the units
    tp2.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tp2);
    delpos.tp2.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.tp2);
    ttpb2.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tp2);
    
    tn2.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tn2);
    delpos.tn2.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.tn2);
    ttnb2.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tn2);
    
    rp2.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tp2);
    delpos.rp2.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.rp2);
    trpb2.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tp2);
    
    rn2.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tn2);
    delpos.rn2.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.rn2);
    trnb2.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tn2);
    
    tp4.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tp4);
    delpos.tp4.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.tp4);
    ttpb4.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tp4);
    
    tn4.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tn4);
    delpos.tn4.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.tn4);
    ttnb4.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tn4);
    
    rp4.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tp4);
    delpos.rp4.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.rp4);
    trpb4.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tp4);
    
    rn4.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tn4);
    delpos.rn4.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.rn4);
    trnb4.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tn4);
    
    tp8.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tp8);
    delpos.tp8.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.tp8);
    ttpb8.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tp8);
    
    tn8.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tn8);
    delpos.tn8.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.tn8);
    ttnb8.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tn8);
    
    rp8.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tp8);
    delpos.rp8.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.rp8);
    trpb8.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tp8);
    
    rn8.(['unit0',num2str(k)]) = count.(['unit0',num2str(k)])(pos.tn8);
    delpos.rn8.(['unit0',num2str(k)]) = delay.(['unit0',num2str(k)])(pos.rn8);
    trnb8.(['unit0',num2str(k)]) = background.raw.(['unit0',num2str(k)])(pos.tn8);
    
    j = 1;
    for i = 1 : rep*10
        tpST2.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tp2(j)};
        tnST2.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tn2(j)};
        rpST2.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tp2(j)};
        rnST2.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tn2(j)};
        tpST4.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tp4(j)};
        tnST4.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tn4(j)};
        rpST4.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tp4(j)};
        rnST4.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tn4(j)};
        tpST8.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tp8(j)};
        tnST8.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tn8(j)};
        rpST8.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tp8(j)};
        rnST8.(['unit0',num2str(k)]){j} = timings.(['unit0',num2str(k)]){pos.tn8(j)};
        j = j + 1;
    end
end

xtp2 = [rec(pos.tp2).vel];
xtn2 = [rec(pos.tn2).vel]*(-1);
xrp2 = [rec(pos.rp2).vel];
xrn2 = [rec(pos.rn2).vel]*(-1);
xtp4 = [rec(pos.tp4).vel];
xtn4 = [rec(pos.tn4).vel]*(-1);
xrp4 = [rec(pos.rp4).vel];
xrn4 = [rec(pos.rn4).vel]*(-1);
xtp8 = [rec(pos.tp8).vel];
xtn8 = [rec(pos.tn8).vel]*(-1);
xrp8 = [rec(pos.rp8).vel];
xrn8 = [rec(pos.rn8).vel]*(-1);
    
%% sort stimuli and plot
% sort stimuli
for k = 1 : unitnbr
    [x_t_p2,temp] = sort(xtp2);
    y_t_p2.(['unit0',num2str(k)]) = tp2.(['unit0',num2str(k)])(temp);
    y_t_p2_delay.(['unit0',num2str(k)]) = delpos.tp2.(['unit0',num2str(k)])(temp);
    tpb2.(['unit0',num2str(k)]) = ttpb2.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).translation.bw.w2 = tpST2.(['unit0',num2str(k)])(temp);
    
    [x_t_n2,temp] = sort(xtn2);
    y_t_n2.(['unit0',num2str(k)]) = tn2.(['unit0',num2str(k)])(temp);
    y_t_n2_delay.(['unit0',num2str(k)]) = delpos.tn2.(['unit0',num2str(k)])(temp);
    tnb2.(['unit0',num2str(k)]) = ttnb2.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).translation.fw.w2 = tnST2.(['unit0',num2str(k)])(temp);
    
    [x_r_p2,temp] = sort(xrp2);
    y_r_p2.(['unit0',num2str(k)]) = rp2.(['unit0',num2str(k)])(temp);
    y_r_p2_delay.(['unit0',num2str(k)]) = delpos.rp2.(['unit0',num2str(k)])(temp);
    rpb2.(['unit0',num2str(k)]) = trpb2.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).rotation.cw.w2 = rpST2.(['unit0',num2str(k)])(temp);
    
    [x_r_n2,temp] = sort(xrn2);
    y_r_n2.(['unit0',num2str(k)]) = rn2.(['unit0',num2str(k)])(temp);
    y_r_n2_delay.(['unit0',num2str(k)]) = delpos.rn2.(['unit0',num2str(k)])(temp);
    rnb2.(['unit0',num2str(k)]) = trnb2.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).rotation.ccw.w2 = rnST2.(['unit0',num2str(k)])(temp);
    
    [x_t_p4,temp] = sort(xtp4);
    y_t_p4.(['unit0',num2str(k)]) = tp4.(['unit0',num2str(k)])(temp);
    y_t_p4_delay.(['unit0',num2str(k)]) = delpos.tp4.(['unit0',num2str(k)])(temp);
    tpb4.(['unit0',num2str(k)]) = ttpb4.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).translation.bw.w4 = tpST4.(['unit0',num2str(k)])(temp);
    
    [x_t_n4,temp] = sort(xtn4);
    y_t_n4.(['unit0',num2str(k)]) = tn4.(['unit0',num2str(k)])(temp);
    y_t_n4_delay.(['unit0',num2str(k)]) = delpos.tn4.(['unit0',num2str(k)])(temp);
    tnb4.(['unit0',num2str(k)]) = ttnb4.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).translation.fw.w4 = tnST4.(['unit0',num2str(k)])(temp);
    
    [x_r_p4,temp] = sort(xrp4);
    y_r_p4.(['unit0',num2str(k)]) = rp4.(['unit0',num2str(k)])(temp);
    y_r_p4_delay.(['unit0',num2str(k)]) = delpos.rp4.(['unit0',num2str(k)])(temp);
    rpb4.(['unit0',num2str(k)]) = trpb4.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).rotation.cw.w4 = rpST4.(['unit0',num2str(k)])(temp);
    
    [x_r_n4,temp] = sort(xrn4);
    y_r_n4.(['unit0',num2str(k)]) = rn4.(['unit0',num2str(k)])(temp);
    y_r_n4_delay.(['unit0',num2str(k)]) = delpos.rn4.(['unit0',num2str(k)])(temp);
    rnb4.(['unit0',num2str(k)]) = trnb4.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).rotation.ccw.w4 = rnST4.(['unit0',num2str(k)])(temp);

    [x_t_p8,temp] = sort(xtp8);
    y_t_p8.(['unit0',num2str(k)]) = tp8.(['unit0',num2str(k)])(temp);
    y_t_p8_delay.(['unit0',num2str(k)]) = delpos.tp8.(['unit0',num2str(k)])(temp);
    tpb8.(['unit0',num2str(k)]) = ttpb8.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).translation.bw.w8 = tpST8.(['unit0',num2str(k)])(temp);
    
    [x_t_n8,temp] = sort(xtn8);
    y_t_n8.(['unit0',num2str(k)]) = tn8.(['unit0',num2str(k)])(temp);
    y_t_n8_delay.(['unit0',num2str(k)]) = delpos.tn8.(['unit0',num2str(k)])(temp);
    tnb8.(['unit0',num2str(k)]) = ttnb8.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).translation.fw.w8 = tnST8.(['unit0',num2str(k)])(temp);
    
    [x_r_p8,temp] = sort(xrp8);
    y_r_p8.(['unit0',num2str(k)]) = rp8.(['unit0',num2str(k)])(temp);
    y_r_p8_delay.(['unit0',num2str(k)]) = delpos.rp8.(['unit0',num2str(k)])(temp);
    rpb8.(['unit0',num2str(k)]) = trpb8.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).rotation.cw.w8 = rpST8.(['unit0',num2str(k)])(temp);
    
    [x_r_n8,temp] = sort(xrn8);
    y_r_n8.(['unit0',num2str(k)]) = rn8.(['unit0',num2str(k)])(temp);
    y_r_n8_delay.(['unit0',num2str(k)]) = delpos.rn8.(['unit0',num2str(k)])(temp);
    rnb8.(['unit0',num2str(k)]) = trnb8.(['unit0',num2str(k)])(temp);
    times.(['unit0',num2str(k)]).rotation.ccw.w8 = rnST8.(['unit0',num2str(k)])(temp);
end

for k = 1 : unitnbr
    c = 1;
    for i = 1 : 10
        for j = 1 : rep
            stimTimes.(['unit0',num2str(k)]).translation.bw.w2(j,i) = times.(['unit0',num2str(k)]).translation.bw.w2(c);
            stimTimes.(['unit0',num2str(k)]).translation.fw.w2(j,i) = times.(['unit0',num2str(k)]).translation.fw.w2(c);
            stimTimes.(['unit0',num2str(k)]).rotation.cw.w2(j,i) = times.(['unit0',num2str(k)]).rotation.cw.w2(c);
            stimTimes.(['unit0',num2str(k)]).rotation.ccw.w2(j,i) = times.(['unit0',num2str(k)]).rotation.ccw.w2(c);
            stimTimes.(['unit0',num2str(k)]).translation.bw.w4(j,i) = times.(['unit0',num2str(k)]).translation.bw.w4(c);
            stimTimes.(['unit0',num2str(k)]).translation.fw.w4(j,i) = times.(['unit0',num2str(k)]).translation.fw.w4(c);
            stimTimes.(['unit0',num2str(k)]).rotation.cw.w4(j,i) = times.(['unit0',num2str(k)]).rotation.cw.w4(c);
            stimTimes.(['unit0',num2str(k)]).rotation.ccw.w4(j,i) = times.(['unit0',num2str(k)]).rotation.ccw.w4(c);
            stimTimes.(['unit0',num2str(k)]).translation.bw.w8(j,i) = times.(['unit0',num2str(k)]).translation.bw.w8(c);
            stimTimes.(['unit0',num2str(k)]).translation.fw.w8(j,i) = times.(['unit0',num2str(k)]).translation.fw.w8(c);
            stimTimes.(['unit0',num2str(k)]).rotation.cw.w8(j,i) = times.(['unit0',num2str(k)]).rotation.cw.w8(c);
            stimTimes.(['unit0',num2str(k)]).rotation.ccw.w8(j,i) = times.(['unit0',num2str(k)]).rotation.ccw.w8(c);
            c = c + 1;
        end
    end
end

x_t_p2_plot = zeros(length(1 : rep : num*rep)); x_t_n2_plot = zeros(length(1 : rep : num*rep)); x_r_p2_plot = zeros(length(1 : rep : num*rep)); x_r_n2_plot = zeros(length(1 : rep : num*rep));
x_t_p4_plot = zeros(length(1 : rep : num*rep)); x_t_n4_plot = zeros(length(1 : rep : num*rep)); x_r_p4_plot = zeros(length(1 : rep : num*rep)); x_r_n4_plot = zeros(length(1 : rep : num*rep));
x_t_p8_plot = zeros(length(1 : rep : num*rep)); x_t_n8_plot = zeros(length(1 : rep : num*rep)); x_r_p8_plot = zeros(length(1 : rep : num*rep)); x_r_n8_plot = zeros(length(1 : rep : num*rep));
j = 1;
for i = 1 : rep : num*rep % size(rec,2)/(3*rep)
    x_t_p2_plot(j) = x_t_p2(i);
    x_t_n2_plot(j) = x_t_n2(i);
    x_r_p2_plot(j) = x_r_p2(i);
    x_r_n2_plot(j) = x_r_n2(i);  
    x_t_p4_plot(j) = x_t_p4(i);
    x_t_n4_plot(j) = x_t_n4(i);
    x_r_p4_plot(j) = x_r_p4(i);
    x_r_n4_plot(j) = x_r_n4(i);
    x_t_p8_plot(j) = x_t_p8(i);
    x_t_n8_plot(j) = x_t_n8(i);
    x_r_p8_plot(j) = x_r_p8(i);
    x_r_n8_plot(j) = x_r_n8(i);
   
    for k = 1 : unitnbr
        for c = 1 : rep
            raw.y_t_p2.(['unit0',num2str(k)])(c,j) = y_t_p2.(['unit0',num2str(k)])(i+c-1);
            raw.y_t_n2.(['unit0',num2str(k)])(c,j) = y_t_n2.(['unit0',num2str(k)])(i+c-1);
            raw.y_r_p2.(['unit0',num2str(k)])(c,j) = y_r_p2.(['unit0',num2str(k)])(i+c-1);
            raw.y_r_n2.(['unit0',num2str(k)])(c,j) = y_r_n2.(['unit0',num2str(k)])(i+c-1);
            raw.y_t_p4.(['unit0',num2str(k)])(c,j) = y_t_p4.(['unit0',num2str(k)])(i+c-1);
            raw.y_t_n4.(['unit0',num2str(k)])(c,j) = y_t_n4.(['unit0',num2str(k)])(i+c-1);
            raw.y_r_p4.(['unit0',num2str(k)])(c,j) = y_r_p4.(['unit0',num2str(k)])(i+c-1);
            raw.y_r_n4.(['unit0',num2str(k)])(c,j) = y_r_n4.(['unit0',num2str(k)])(i+c-1);
            raw.y_t_p8.(['unit0',num2str(k)])(c,j) = y_t_p8.(['unit0',num2str(k)])(i+c-1);
            raw.y_t_n8.(['unit0',num2str(k)])(c,j) = y_t_n8.(['unit0',num2str(k)])(i+c-1);
            raw.y_r_p8.(['unit0',num2str(k)])(c,j) = y_r_p8.(['unit0',num2str(k)])(i+c-1);
            raw.y_r_n8.(['unit0',num2str(k)])(c,j) = y_r_n8.(['unit0',num2str(k)])(i+c-1);
        end
        y_t_p2_plot.(['unit0',num2str(k)])(j) = nanmedian(y_t_p2.(['unit0',num2str(k)])(i:i+rep-1)); %#ok<*NANMEDIAN>
        y_t_n2_plot.(['unit0',num2str(k)])(j) = nanmedian(y_t_n2.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_p2_plot.(['unit0',num2str(k)])(j) = nanmedian(y_r_p2.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_n2_plot.(['unit0',num2str(k)])(j) = nanmedian(y_r_n2.(['unit0',num2str(k)])(i:i+rep-1));
        y_t_p4_plot.(['unit0',num2str(k)])(j) = nanmedian(y_t_p4.(['unit0',num2str(k)])(i:i+rep-1)); %#ok<*NANMEDIAN>
        y_t_n4_plot.(['unit0',num2str(k)])(j) = nanmedian(y_t_n4.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_p4_plot.(['unit0',num2str(k)])(j) = nanmedian(y_r_p4.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_n4_plot.(['unit0',num2str(k)])(j) = nanmedian(y_r_n4.(['unit0',num2str(k)])(i:i+rep-1));
        y_t_p8_plot.(['unit0',num2str(k)])(j) = nanmedian(y_t_p8.(['unit0',num2str(k)])(i:i+rep-1)); %#ok<*NANMEDIAN>
        y_t_n8_plot.(['unit0',num2str(k)])(j) = nanmedian(y_t_n8.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_p8_plot.(['unit0',num2str(k)])(j) = nanmedian(y_r_p8.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_n8_plot.(['unit0',num2str(k)])(j) = nanmedian(y_r_n8.(['unit0',num2str(k)])(i:i+rep-1));
        
        
        y_t_p2_sd.(['unit0',num2str(k)])(j) = nanstd(y_t_p2.(['unit0',num2str(k)])(i:i+rep-1)); %#ok<*NANSTD>
        y_t_n2_sd.(['unit0',num2str(k)])(j) = nanstd(y_t_n2.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_p2_sd.(['unit0',num2str(k)])(j) = nanstd(y_r_p2.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_n2_sd.(['unit0',num2str(k)])(j) = nanstd(y_r_n2.(['unit0',num2str(k)])(i:i+rep-1));
        y_t_p4_sd.(['unit0',num2str(k)])(j) = nanstd(y_t_p4.(['unit0',num2str(k)])(i:i+rep-1)); %#ok<*NANSTD>
        y_t_n4_sd.(['unit0',num2str(k)])(j) = nanstd(y_t_n4.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_p4_sd.(['unit0',num2str(k)])(j) = nanstd(y_r_p4.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_n4_sd.(['unit0',num2str(k)])(j) = nanstd(y_r_n4.(['unit0',num2str(k)])(i:i+rep-1));
        y_t_p8_sd.(['unit0',num2str(k)])(j) = nanstd(y_t_p8.(['unit0',num2str(k)])(i:i+rep-1)); %#ok<*NANSTD>
        y_t_n8_sd.(['unit0',num2str(k)])(j) = nanstd(y_t_n8.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_p8_sd.(['unit0',num2str(k)])(j) = nanstd(y_r_p8.(['unit0',num2str(k)])(i:i+rep-1));
        y_r_n8_sd.(['unit0',num2str(k)])(j) = nanstd(y_r_n8.(['unit0',num2str(k)])(i:i+rep-1));
        
        delpos.y_t_p2_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.tp2.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_t_n2_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.tn2.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_r_p2_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.rp2.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_r_n2_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.rn2.(['unit0',num2str(k)])(i:i+rep-1));      
        delpos.y_t_p4_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.tp4.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_t_n4_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.tn4.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_r_p4_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.rp4.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_r_n4_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.rn4.(['unit0',num2str(k)])(i:i+rep-1));      
        delpos.y_t_p8_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.tp8.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_t_n8_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.tn8.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_r_p8_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.rp8.(['unit0',num2str(k)])(i:i+rep-1));
        delpos.y_r_n8_plot.(['unit0',num2str(k)])(j) = nanmedian(delpos.rn8.(['unit0',num2str(k)])(i:i+rep-1));      
        
        background.rawmean.(['unit0',num2str(k)]).translation.bw.w2(j) = nanmean(tpb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).translation.fw.w2(j) = nanmean(tnb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).rotation.cw.w2(j) = nanmean(rpb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).rotation.ccw.w2(j) = nanmean(rnb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).translation.bw.w4(j) = nanmean(tpb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).translation.fw.w4(j) = nanmean(tnb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).rotation.cw.w4(j) = nanmean(rpb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).rotation.ccw.w4(j) = nanmean(rnb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).translation.bw.w8(j) = nanmean(tpb8.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).translation.fw.w8(j) = nanmean(tnb8.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).rotation.cw.w8(j) = nanmean(rpb8.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawmean.(['unit0',num2str(k)]).rotation.ccw.w8(j) = nanmean(rnb8.(['unit0',num2str(k)])(i:i+rep-1));
        
        background.rawsd.(['unit0',num2str(k)]).translation.bw.w2(j) = nanstd(tpb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).translation.fw.w2(j) = nanstd(tnb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).rotation.cw.w2(j) = nanstd(rpb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).rotation.ccw.w2(j) = nanstd(rnb2.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).translation.bw.w4(j) = nanstd(tpb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).translation.fw.w4(j) = nanstd(tnb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).rotation.cw.w4(j) = nanstd(rpb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).rotation.ccw.w4(j) = nanstd(rnb4.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).translation.bw.w8(j) = nanstd(tpb8.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).translation.fw.w8(j) = nanstd(tnb8.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).rotation.cw.w8(j) = nanstd(rpb8.(['unit0',num2str(k)])(i:i+rep-1));
        background.rawsd.(['unit0',num2str(k)]).rotation.ccw.w8(j) = nanstd(rnb8.(['unit0',num2str(k)])(i:i+rep-1));
    end
    j = j + 1;
end

%% calculate receptive field data
for i = 1 : unitnbr
    RF.(['unit0',num2str(i)]) = receptiveFieldData(file.name(1:strfind(file.name, 'Recording01')+10),i,firstunit,unitnbr);
end

%% analyse freq
figure 
% tr, bw, freq
[half.tp(2,:), width.tp(2,:)] = plotFreq(x_t_p2_plot, y_t_p2_plot,[1/255 102/255 94/255],'x:',y_t_p2_sd,background.sum);

% tr, bw, freq
[half.tp(2,:), width.tp(2,:)] = plotFreq(x_t_p4_plot, y_t_p4_plot,[1/255 102/255 94/255],'x--',y_t_p4_sd,background.sum);

% tr, bw, freq
[half.tp(2,:), width.tp(2,:)] = plotFreq(x_t_p8_plot, y_t_p8_plot,[1/255 102/255 94/255],'x-',y_t_p8_sd,background.sum);
createLegend({'bw2','bw4','bw8'},[1/255 102/255 94/255; 1/255 102/255 94/255; 1/255 102/255 94/255],{':','--','-'},'best',1.5)

figure 
% tr, fw, freq
[half.tn(2,:), width.tn(2,:)] = plotFreq(x_t_n2_plot, y_t_n2_plot,[140/255 81/255 10/255],'x:',y_t_n2_sd,background.sum);

% tr, fw, freq
[half.tn(2,:), width.tn(2,:)] = plotFreq(x_t_n4_plot, y_t_n4_plot,[140/255 81/255 10/255],'x--',y_t_n4_sd,background.sum);

% tr, fw, freq
[half.tn(2,:), width.tn(2,:)] = plotFreq(x_t_n8_plot, y_t_n8_plot,[140/255 81/255 10/255],'x-',y_t_n8_sd,background.sum);
createLegend({'fw2','fw4','fw8'},[140/255 81/255 10/255; 140/255 81/255 10/255; 140/255 81/255 10/255],{':','--','-'},'best',1.5)

figure 
% rot, cw, freq
[half.rp(2,:), width.rp(2,:)] = plotFreq(x_r_p2_plot, y_r_p2_plot,[1/255 102/255 94/255],'x:',y_r_p2_sd,background.sum);

% rot, cw, freq
[half.rp(2,:), width.rp(2,:)] = plotFreq(x_r_p4_plot, y_r_p4_plot,[1/255 102/255 94/255],'x--',y_r_p4_sd,background.sum);

% rot, cw, freq
[half.rp(2,:), width.rp(2,:)] = plotFreq(x_r_p8_plot, y_r_p8_plot,[1/255 102/255 94/255],'x-',y_r_p8_sd,background.sum);
createLegend({'cw2','cw4','cw8'},[1/255 102/255 94/255; 1/255 102/255 94/255; 1/255 102/255 94/255],{':','--','-'},'best',1.5)

figure 
% rot, ccw, freq
[half.rn(2,:), width.rn(2,:)] = plotFreq(x_r_n2_plot, y_r_n2_plot,[140/255 81/255 10/255],'x:',y_r_n2_sd,background.sum);

% rot, ccw, freq
[half.rn(2,:), width.rn(2,:)] = plotFreq(x_r_n4_plot, y_r_n4_plot,[140/255 81/255 10/255],'x--',y_r_n4_sd,background.sum);

% rot, ccw, freq
[half.rn(2,:), width.rn(2,:)] = plotFreq(x_r_n8_plot, y_r_n8_plot,[140/255 81/255 10/255],'x-',y_r_n8_sd,background.sum);
createLegend({'ccw2','ccw4','ccw8'},[140/255 81/255 10/255; 140/255 81/255 10/255; 140/255 81/255 10/255],{':','--','-'},'best',1.5)


%% analyse velocity

% calculate values for x axis
x = [0.5, 1, 5, 10, 20, 40, 60, 80, 100, 120];
x2 = calcVelocity(x,2);
x4 = calcVelocity(x,4);
x8 = calcVelocity(x,8);

figure % tr, bw
plotVelocity(x2, y_t_p2_plot,[1/255 102/255 94/255],'x:')
plotVelocity(x4, y_t_p4_plot,[1/255 102/255 94/255],'x--')
plotVelocity(x8, y_t_p8_plot,[1/255 102/255 94/255],'x-')
createLegend({'bw2','bw4','bw8'},[1/255 102/255 94/255; 1/255 102/255 94/255; 1/255 102/255 94/255],{':','--','-'},'best',1.5)

figure % tr, fw
plotVelocity(x2, y_t_n2_plot,[140/255 81/255 10/255],'x:')
plotVelocity(x4, y_t_n4_plot,[140/255 81/255 10/255],'x--')
plotVelocity(x8, y_t_n8_plot,[140/255 81/255 10/255],'x-')
createLegend({'fw2','fw4','fw8'},[140/255 81/255 10/255; 140/255 81/255 10/255; 140/255 81/255 10/255],{':','--','-'},'best',1.5)


