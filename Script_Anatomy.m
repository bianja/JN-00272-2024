
% x = imread('C:\Users\bij26uj\Downloads\snapshot.jpg');
% figure
% subplot(2,1,1)
% imshow(x);
% [r,c] = size (x);
% output=zeros(r,c);
% for i = 1 : r
%     for j = 1 : c
%         if x(i,j) > 50
%             output(i,j)=1;
%         else
%             output(i,j)=0;
%         end
%     end
% end
% subplot(2,1,2)
% imshow(output);

%%

% open schmetic brain

% mark position of recording 

% save coordinates for current brain

% open textfield to add depth (which is estimated by myself) in um

% plot schematic brain with all positions 


%%
% close all
IM4 = h.database(:,:,75)+20;
IM4 = imresize(IM4, 401/1024);
figure
IM4 = imshow(imbinarize(IM4,'adaptive','ForegroundPolarity','dark','Sensitivity',.4));
% IM4 = imshow(IM4);
IM4.AlphaData = .6;
figure
temp2 = standard(20:440,100:720,:);
temp3 = temp2(size(temp2,1)/2-200:size(temp2,1)/2+200,size(temp2,2)/2-200:size(temp2,2)/2+200,:);
IM3 = temp3(:,:,200);
IM3 = imshow(imbinarize(IM3,'adaptive','ForegroundPolarity','dark','Sensitivity',.4));
% IM3 = imshow(IM3);
IM3.AlphaData = .4;
C = imfuse(IM4.CData, IM3.CData,'blend');
figure
imshow(C)
% figure
% alpha = 0.8;
% IM4.CData = 255-IM4.CData;
% IM3.CData = 255-IM3.CData;
% D = alpha * IM4.CData + (1 - alpha) * IM3.CData;
% imshow(D);

%% check saved position
if zposS == 1
    zposS = zposSP;
end
% xs = xpos *(1024/645);
% ys = ypos *(1024/820);

% xs = xpos *(1024/378);
% ys = ypos *(1024/378);
xs = xpos+xshift+23/2+220/2;
ys = ypos+yshift+23/2+20/2;
xs = xpos+xshift+121.5+11.5;
ys = ypos+yshift+21.5+11.5;
xs = xpos+xshift+121.5;
ys = ypos+yshift+121.5;
figure
% imshow(imresize(database(:,:,zpos)+20, [400, 400]))
sc = 0.65;
% IM3 = imresize(standard(20+xshift:440+xshift,100+yshift:720+yshift,200),sc);
% imshow(IM3(size(IM3,1)/2-100:size(IM3,1)/2+100,size(IM3,2)/2-100:size(IM3,2)/2+100,1));
% set(gcf,'position',[10 10 800 600])
% set(gca,'position','Units','centimeters',[10 10 800 600])
% imshow(standard(20:440,100:720,zposSP))
% imshow(h.standard(:,:,zposS))
% imshow(IM3(:,:,1))
imshow(temp2(:,:,zposS))
hold on
scatter(xs,ys,'filled','r')
% scatter(xpos,ypos,'filled','r')

%% load data
clear vars
close all
folder = uigetdir; % choose folder with image batch
files = dir(folder); % list all files in folder

% for loop to load image batch and save in database
c = 1; % counter
database = uint8.empty; % create empty image batch array
for i = 1 : size(files,1)
    if contains(files(i).name,'jpeg')
        a = imread(([folder,'\',files(i).name])); % read image
        database(:,:,c) = a;
        N_images = size(database,3);
        c = c + 1;
    end
end

% load standard brain grey data (as nifti, convert to uint8)
im = niftiread('X:\für Bianca\von Keram\Bombus_Standard_brain\average.nii');
standard = imrotate(uint8(im),270);
S_images = size(standard,3);

%% open user interface
close all
valor = 0;
zposS = 200;
zposSP = 200;
z = 1;
xshift = 0;
yshift = 0;

%prepare figure and guidata struct
h = struct;
h.f = figure;
h.f.Position = [200 250 1400 550];
h.ax = axes('Parent',h.f,'Units','centimeters','Position',[1 4 10 10]);
h.slider = uicontrol('Parent',h.f,'Units','centimeters','Position',[1 1.5 10 .5],...
    'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',1,'Max',S_images,'Value',200,...
    'Callback',@sliderCallback);
h.ax2 = axes('Parent',h.f,'Units','centimeters','Position',[13 4 10 10]);
h.slider2 = uicontrol('Parent',h.f,'Units','centimeters','Position',[13 1.5 10 .5],...
    'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',1,'Max',N_images,'Value',50,...
    'Callback',@sliderCallback2);

h.ax3 = axes('Parent',h.f,'Units','centimeters','Position',[25 4 10 10]);
% h.slider3 = uicontrol('Parent',h.f,'Units','centimeters','Position',[25 1.5 10 .5],...
%     'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',1,'Max',S_images,'Value',zposS,...
%     'Callback',@sliderCallback3);
h.sliderZ = uicontrol('Parent',h.f,'Units','centimeters','Position',[25 3 2 .35],...
    'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',1,'Max',3,'Value',1,...
    'Callback',@sliderCallbackZ);
h.sliderX = uicontrol('Parent',h.f,'Units','centimeters','Position',[29 3 2 .35],...
    'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',2,'Max',102,'Value',52,...
    'Callback',@sliderCallbackX);
h.sliderY = uicontrol('Parent',h.f,'Units','centimeters','Position',[35.5 8 .35 2],...
    'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',2,'Max',102,'Value',52,...
    'Callback',@sliderCallbackY);

h.sliderB = uicontrol('Parent',h.f,'Units','centimeters','Position',[13 2.5 10 .5],...
    'Style','Slider','BackgroundColor',[.7 .7 .7],'Min',-100,'Max',100,'Value',0,...
    'Callback',@sliderCallbackB);

h.buttonP = uicontrol('Parent',h.f,'Units','centimeters','Position',[13 .5 2 .5],...
    'Style','push','BackgroundColor',[.7 .7 .7],'String','Position','Callback',@pushCallbackP);


%store image database to the guidata struct as well
h.database = database;
h.standard = standard(1:621,100:720,:);
temp = 255-standard;
% h.standardI = temp(20:440,200:620,:);
h.standardI = temp(1:621,100:720,:);
temp2 = h.standardI;
h.standardI = temp2(size(temp2,1)/2-300:size(temp2,1)/2+300,size(temp2,2)/2-300:size(temp2,2)/2+300,:);
% h.standardI = 255-h.standard;
guidata(h.ax,h)
guidata(h.ax2,h)
guidata(h.ax3,h)

%trigger a callback
sliderCallback(h.slider)
sliderCallback(h.slider2)
sliderCallback(h.sliderX)
sliderCallback(h.sliderY)
sliderCallback(h.sliderZ)

IM = h.standard(:,:,200);
IM = permute(IM,[1 2 4 3]); 
montage(IM,'Parent',h.ax);

IM2 = h.database(:,:,50);
IM2 = permute(IM2,[1 2 4 3]); 
montage(IM2,'Parent',h.ax2);

IM3 = h.standardI(:,:,200);
% IM3 = imshow(IM3);
% IM3.AlphaData = .1;
% temp2 = standard(20:440,100:720,:);
% temp3 = temp2(size(temp2,1)/2-200:size(temp2,1)/2+200,size(temp2,2)/2-200:size(temp2,2)/2+200,:);
% IM3 = temp3(:,:,200);
% % IM3 = imshow(imbinarize(IM3,'adaptive','ForegroundPolarity','dark','Sensitivity',.4));
% IM3 = imshow(IM3);
% IM3.AlphaData = .4;
% hold on
IM3 = permute(IM3,[1 2 4 3]); 
% IM3 = imoverlay(IM4,IM2);
% J = imresize(IM3, 0.5);
montage(IM3,'Parent',h.ax3);

% IM4 = h.database(:,:,50);
% IM4 = imshow(IM4);
% IM4.AlphaData = .9;
% IM4 = h.database(:,:,75)+20;
% IM4 = imresize(IM4, 401/1024);
% % figure
% % IM4 = imshow(imbinarize(IM4,'adaptive','ForegroundPolarity','dark','Sensitivity',.4));
% IM4 = imshow(IM4);
% IM4.AlphaData = .6;

% FG = IM2;
% BG = IM4;
% montage({FG BG})
% a = 0.6; % foreground opacity
% C = a*FG + (1-a)*BG;
% imshow(C)
% figure
% FG = IM2;
% BG = IM4;
% montage({FG BG})
% a = 0.6; % foreground opacity
% C = a*FG + (1-a)*BG;
% imshow(C)
% C = imblend(FG,BG,1,'overlay'); % THIS IS A MIMT-ONLY TOOL (see file exchange)

function sliderCallback(hObject,eventdata)
h = guidata(hObject);
z = evalin('base','z');
xshift = evalin('base','xshift');
yshift = evalin('base','yshift');
count = round(get(hObject,'Value'));
IM = h.standard(:,:,count);
IM = permute(IM,[1 2 4 3]); % montage needs the 3rd dim to be the color channel
montage(IM,'Parent',h.ax);
IM3 = h.standardI(:,:,count);
IM3 = imresize(IM3,z);
IM3 = IM3(size(IM3,1)/2-300+yshift:size(IM3,1)/2+300+yshift,size(IM3,2)/2-300+xshift:size(IM3,2)/2+300+xshift,1);
% IM3 = imshow(IM3);
% IM3.AlphaData = .1;
% IM3 = uint8(im3);
IM3 = permute(IM3,[1 2 4 3]); 
montage(IM3,'Parent',h.ax3);
assignin('base','IM3',IM3)
assignin('base','zposS',count)
end

function sliderCallback2(hObject,eventdata)
h = guidata(hObject);
valor = evalin('base','valor');
count = round(get(hObject,'Value'));
IM2 = h.database(:,:,count);
IM2 = permute(IM2,[1 2 4 3]); 
% IM = get(h.ax2,'CData')+valor;
% set(h.ax2,'CData',IM)
% IM = imadjust(IM,[0 1],[0.1 1]);
montage(IM2+valor,'Parent',h.ax2);
assignin('base','IM2',IM2)
assignin('base','zpos',count)
end

% function sliderCallback3(hObject,eventdata)
% h = guidata(hObject);
% count = round(get(hObject,'Value'));
% IM3 = h.standardI(:,:,count);
% IM3 = permute(IM3,[1 2 4 3]); 
% montage(IM3,'Parent',h.ax3);
% assignin('base','IM3',IM3)
% assignin('base','zposS',count)
% end

% zoom
function sliderCallbackZ(hObject,eventdata)
zposS = evalin('base','zposS');
xshift = evalin('base','xshift');
yshift = evalin('base','yshift');
IM3 = evalin('base','IM3');
h = guidata(hObject);
count = get(hObject,'Value');
IM3 = h.standardI(:,:,zposS);
IM3 = imresize(IM3,count);
IM3 = IM3(size(IM3,1)/2-300+yshift:size(IM3,1)/2+300+yshift,size(IM3,2)/2-300+xshift:size(IM3,2)/2+300+xshift,1);
% IM3 = imshow(IM3);
% IM3.AlphaData = .1;
IM3 = permute(IM3,[1 2 4 3]); 
montage(IM3,'Parent',h.ax3);
assignin('base','z',count)
assignin('base','IM3',IM3)
end

% movement on x and y
function sliderCallbackX(hObject,eventdata)
zposS = evalin('base','zposS');
yshift = evalin('base','yshift');
xshift = evalin('base','xshift');
z = evalin('base','z');
IM3 = evalin('base','IM3');
h = guidata(hObject);
count = (get(hObject,'Value')-52)*-1; % range 2 to 102
IM3 = h.standardI(:,:,zposS);
IM3 = imresize(IM3,z);
if size(IM3,1)/2-200+count <= 0 
    count = xshift;
elseif size(IM3,1)/2+200+count >= size(IM3,2)
    count = xshift;
end
IM3 = IM3(size(IM3,1)/2-300+yshift:size(IM3,1)/2+300+yshift,size(IM3,2)/2-300+count:size(IM3,2)/2+300+count,1);
% IM3 = imshow(IM3);
% IM3.AlphaData = .1;
IM3 = permute(IM3,[1 2 4 3]);
montage(IM3,'Parent',h.ax3);
assignin('base','IM3',IM3)
assignin('base','xshift',count)
end

function sliderCallbackY(hObject,eventdata)
zposS = evalin('base','zposS');
xshift = evalin('base','xshift');
yshift = evalin('base','yshift');
z = evalin('base','z');
IM3 = evalin('base','IM3');
h = guidata(hObject);
count = get(hObject,'Value')-52; % range 2 to 102
IM3 = h.standardI(:,:,zposS);
IM3 = imresize(IM3,z);
if size(IM3,1)/2-200+count <= 0 
    count = yshift;
elseif size(IM3,1)/2+200+count >= size(IM3,2)
    count = yshift;
end
IM3 = IM3(size(IM3,1)/2-301+count:size(IM3,1)/2+300+count,size(IM3,2)/2-300+xshift:size(IM3,2)/2+300+xshift,1);
% IM3 = imshow(IM3);
% IM3.AlphaData = .1;
IM3 = permute(IM3,[1 2 4 3]);
montage(IM3,'Parent',h.ax3);
assignin('base','IM3',IM3)
assignin('base','yshift',count)
end

% function sliderCallbackXU(hObject,eventdata)
% xl = evalin('base','xl');
% zposS = evalin('base','zposS');
% IM3 = evalin('base','IM3');
% h = guidata(hObject);
% count = round(get(hObject,'Value'));
% IM3 = h.standardI(:,:,zposS);
% IM3 = zoom(IM3,count);
% IM3 = permute(IM3,[1 2 4 3]); 
% montage(IM3,'Parent',h.ax3);
% assignin('base','xu',count)
% end



function varargout = sliderCallbackB(hObject, eventdata, handles)
IM2 = evalin('base','IM2');
h = guidata(hObject);
valor = get(hObject, 'value');
assignin('base','valor',valor)
montage(IM2+valor,'Parent',h.ax2);
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


