%% this scripts adds all the receptive field spike information to the table
% containing responses to wide field motion stimuli

% clear all
% close all
% clc
% 
% % load table and add receptive field information
% cd \\132.187.28.171\home\Data\Analysis\matlab\scripts
% load('AllResults_OF_T.mat')

% change path to data folder
% opath = '\\132.187.28.171\home\Data\Analysis\matlab';

for k = 84 : size(AllAni,2)
    
    if AllAni(k).Animal < 52
    else
        
        cd(['\\132.187.28.171\home\rest\data\Ephys\',AllAni(k).File(34:57)])
        foldpath = cd;
        
        folder = foldpath;
        listing = dir(folder);
        
        for i = 1 : size(listing,1)
            if contains(listing(i).name,'T01.mat') == 1 %yes
                T01 = load([listing(i).folder,'\',listing(i).name]);
            elseif contains(listing(i).name,'T02.mat') == 1
                T02 = load([listing(i).folder,'\',listing(i).name]);
            end
        end
        
        c = 1;
        for i = 1 : size(listing,1)
            if contains(listing(i).name,'test_Arena.mat') == 1 %yes
                S{c} = load([listing(i).folder,'\',listing(i).name]);
                c = c + 1;
            end
        end
        
        cd(foldpath)
        
        if exist('S')
            for i = 1 : size(S,2)
                for s = 1 : size(S{i}.rec,2)
                    tAll = [];
                    for r = 1 : 5
                        stimval = find_spikes_RF(T01,AllAni(k).UnitNbr,S{1,i}.rec);
                    end
                end
                AllAni(k).(['RF',num2str(i)]) = stimval;
            end
        end
        clear S
    end
end

% save AllResultsRF_Add.mat AllAni


