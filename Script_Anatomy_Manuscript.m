%% 4 %% plot whole group
% specify group to plot
group = 'ib';

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
for i = 1 : size(folder,1)
    if contains(folder(i).name,'.mat')
        load([group,'/',folder(i).name])
        tempz(i) = zpos; 
        zpos = zpos - 127 + 1; % lower limit of colormap
        plot(xpos*1.6429,ypos*1.6429,'o','Color',zposCol(zpos,:),'MarkerSize',3,'MarkerFaceColor',zposCol(zpos,:))
    end
end

% save figures
% savefig(['Anatomy_',group,'.fig'])
% print(['Anatomy_',group],'-depsc','-r300','-tiff','-painters')

%% 3 %% check position
load ColormapZPos
figure
imshow(IM2)
hold on
plot(xpos*1.6429,ypos*1.6429,'.','Color',zposCol(zpos,:),'MarkerSize',20)
save ib/A46 xpos ypos zpos

%% 1 %% load data
clearvars
close all

% load standard brain grey data (as nifti, convert to uint8)
im = niftiread('X:\für Bianca\von Keram\Bombus_Standard_brain\average.nii');
standard = imrotate(uint8(im),270);
N_images = size(standard,3); % 384

%% 2 %% open user interface
close all

%prepare figure and guidata struct
h = struct;
h.f = figure;
h.f.Position = [200 250 452 470];
h.ax2 = axes('Parent',h.f,'Units','centimeters','Position',[1 1.75 10 10]);
h.slider2 = uicontrol('Parent',h.f,'Units','centimeters','Position',[1 1 10 .5],...
    'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',1,'Max',N_images,'Value',200,...
    'Callback',@sliderCallback2);
h.buttonP = uicontrol('Parent',h.f,'Units','centimeters','Position',[1 .25 2 .5],...
    'Style','push','BackgroundColor',[.7 .7 .7],'String','Position','Callback',@pushCallbackP);


%store image database to the guidata struct as well
h.standard = standard(1:621,100:720,:);
temp = 255-standard;
h.standardI = temp(1:621,100:720,:);
temp2 = h.standardI;
h.standardI = temp2(size(temp2,1)/2-300:size(temp2,1)/2+300,size(temp2,2)/2-300:size(temp2,2)/2+300,:);
guidata(h.ax2,h)

IM2 = h.standard(:,:,200);
IM2 = permute(IM2,[1 2 4 3]); 
montage(IM2,'Parent',h.ax2);

function sliderCallback2(hObject,eventdata)
h = guidata(hObject);
count = round(get(hObject,'Value'));
IM2 = h.standard(:,:,count);
IM2 = permute(IM2,[1 2 4 3]); 
montage(IM2,'Parent',h.ax2);
assignin('base','IM2',IM2)
assignin('base','zpos',count)
end

function pushCallbackP(hObject, eventdata, handles)
% set(gcf,'Pointer','arrow')
% drawnow;
hf = get(hObject,'parent');
b = get(hf,'selectiontype');
xy = get(gca,'CurrentPoint');
if strcmpi(b,'normal') % left click on recording position
    [x,y] = ginput(1);
    hold on
    scatter(x,y,'filled','MarkerEdgeColor',[.12 .5 .18],'MarkerFaceColor',[.12 .5 .18])
    assignin('base','xpos',x)
    assignin('base','ypos',y)
    text(x,y,sprintf([' x = ',num2str(round(x)),',\n y = ',num2str(round(y))]),'Color',[.9 .9 .9])
end
end


