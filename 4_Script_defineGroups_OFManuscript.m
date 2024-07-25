clear
clc
load Results_all_manuskript
data = AllAni;   
group = zeros(size(AllAni,2),1);
CItemp(size(AllAni,2),2) = NaN;
for k = 1 : size(AllAni,2)
    temp = [data(k).R01.background.rawmean.translation.fw.w2 data(k).R01.background.rawmean.translation.fw.w4 data(k).R01.background.rawmean.translation.fw.w8...
        data(k).R01.background.rawmean.translation.bw.w2 data(k).R01.background.rawmean.translation.bw.w4 data(k).R01.background.rawmean.translation.bw.w8...
        data(k).R01.background.rawmean.rotation.cw.w2 data(k).R01.background.rawmean.rotation.cw.w4 data(k).R01.background.rawmean.rotation.cw.w8...
        data(k).R01.background.rawmean.rotation.ccw.w2 data(k).R01.background.rawmean.rotation.ccw.w4 data(k).R01.background.rawmean.rotation.ccw.w8];
    meanBG = median(temp);
    
%     CItemp(k,:) = confidence_interval(temp);
    
    % assign groups based on bg right before stimulus 
    diffBW = AllAni(k).R01.yfreq.mean.translation.bw.w8 - AllAni(k).R01.background.rawmean.translation.bw.w8;
    diffFW = AllAni(k).R01.yfreq.mean.translation.fw.w8 - AllAni(k).R01.background.rawmean.translation.fw.w8;
    CItemp(k,:) = [abs(min([diffBW diffFW])*0.1) max([diffBW diffFW])*0.1];
    BG(k) = meanBG;
    
    BWEXC = find(diff(find([true, diff(find(diffBW > max([diffBW diffFW])*0.1)) ~= 1, true])) > 3);  % if ~isempty -> 4 successive TF are greater median+10%of max [btf ftb]
    BWINH = find(diff(find([true, diff(find(diffBW < min([diffBW diffFW])*0.1)) ~= 1, true])) > 3);  
    FWEXC = find(diff(find([true, diff(find(diffFW > max([diffBW diffFW])*0.1)) ~= 1, true])) > 3);  
    FWINH = find(diff(find([true, diff(find(diffFW < min([diffBW diffFW])*0.1)) ~= 1, true])) > 3);  
    if ~isempty(BWEXC) && ~isempty(FWEXC) % exc exc
        group(k) = 1;
    elseif ~isempty(BWEXC) && ~isempty(FWINH) % exc inh
        group(k) = 2;
    elseif ~isempty(FWEXC) && ~isempty(BWINH) % exc inh
        group(k) = 3;
    elseif ~isempty(BWINH) && ~isempty(FWINH) % inh inh
        group(k) = 4;
    elseif ~isempty(BWEXC) % exc uni
        group(k) = 5;
    elseif ~isempty(FWEXC) % exc uni
        group(k) = 6;
    elseif ~isempty(BWINH) % inh uni
        group(k)= 7;
    elseif ~isempty(FWINH) % inh uni
        group(k)= 8;
    end
    
end

% figure1 = data(1:5);
% CI.figure1 = CItemp(1:5,:);

excbi = data(group==1);
excinh1 = data(group==2);
excinh2 = data(group==3);
inhbi = data(group==4);
excuni1 = data(group==5);
excuni2 = data(group==6);
inhuni1 = data(group==7);
inhuni2 = data(group==8);

CI.excbi = CItemp(group==1,:);
CI.excinh1 = CItemp(group==2,:);
CI.excinh2 = CItemp(group==3,:);
CI.inhbi = CItemp(group==4,:);
CI.excuni1 = CItemp(group==5,:);
CI.excuni2 = CItemp(group==6,:);
CI.inhuni1 = CItemp(group==7,:);
CI.inhuni2 = CItemp(group==8,:);

save Results_groups_manuscript_new excbi excinh1 excinh2 inhbi excuni1 excuni2 inhuni1 inhuni2 CI
