% concatenate stim mat files (containing stimulus order as presented during
% experiment)
% for analysing repetitions and looking at averaged response, stim file
% for all repetitions needs to be concatenated. To concatenate stim files,
% save all stim files to concatenate in one folder (no other mat-files are
% allowed to be in that folder), run the script, and choose the folder. The
% script will save the concatenated file as a new mat-file in the chosen
% folder. This script works for optic flow stimuli as well as for receptive
% field stimuli. Optic flow stimuli should contain 'Arena' in its name
% while receptive field stimuli should contain 'test'. This labeling
% assigns the stim file to one of those stimuli type for the output label.
%
% Version 03-03-2023

folder = uigetdir;
listing = dir(folder);

all = [];
for i = 1 : size(listing, 1)
    if contains(listing(i).name, 'Arena') == 1
        load([folder, '\', listing(i).name])
        all = [all rec]; %#ok<*AGROW>
        t = 1;
    elseif contains(listing(i).name, 'test') == 1
        load([folder, '\', listing(i).name])
        all = [all rec];
        t = 2;
    end
end

rec = all;

if t == 1    
    save([folder, '\Arena_A', folder(42:43)],'rec')
elseif t == 2
    save([folder, '\TestStim_A', folder(42:44)],'rec')
end