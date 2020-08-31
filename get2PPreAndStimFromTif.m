% get2PPreAndStimFromTif will compute mean images of fluorescence during
% pre-stim and stimulus presentation for each trial in your experiment and
% save it on a file called "PreAndStim.mat" in the path where your tif
% files are. It will also save there the StimOrder that you gave it, the
% function does not actually use StimOrder, its just here so it gets saved
% with the other stuff.

function get2PPreAndStimFromTif(imgPath,CameraTimes,Stimtrig,StimOrder,Stimtime,ISI,ISItoSTIMDelay)

%Get frame start for each stimulus as the frame closest in time to stimulus
%triger time
for Trial=1:length(Stimtrig)
    [tmp FrameStart(Trial)]=min(abs(CameraTimes-Stimtrig(Trial)));
end

%% Open tif files, get info of which file and frame corresponds to each experiment frame

% Estimate AcqRate. This estimate is used to copute how many frames are
% used to get average stimulus and pre-stim images
AcqRate=1/mean(diff(CameraTimes));
% These following lines is for when physiology experiments are computed
% because there our triggers are done by cheeta and not spike 2 which
% records the triggers on a different temporal scale. Yes, I can probably
% code this better.
if AcqRate<1
AcqRate=1000000/mean(diff(CameraTimes));
end

% Get list of files in the provided path
warning off
files= dir(strcat(imgPath,'\*.tif'));
files={files.name}';
numberOfFiles = size(files, 1);
if(numberOfFiles ==0) 
    error('The Image path does not contain any tifs'); 
end

% Initiate FramesInfo with a [0 0] at the begening, I honest to god forgot
% why is was necessary to iniciate it like this but I must have run into
% some problem when assigning stuff on it otherwise. I'll cheack later if I
% can take it out cause it looks silly.
FramesInfo=zeros(1,2);

% Now lets open each file and check how many frames it contains, this info
% will populate FramesInfo. The way FramesInfo data is read is: Row X data
% refers to the frame X of your experiment. The first number in Row X is
% the file number (A) where tha frame is, the second number is the frame number
% whithin file A where frame X is. For example, if every file contains 1000
% frames, row 3500 will be [4 500] indicating that frame 3500 of your
% experiment is the 500th frame of file 4.
disp('Opening files and getting frame info')
for n = 1:numberOfFiles
    fileName{n}  = char(strcat(imgPath,'\',files(n)));
    imageInfo{n} = imfinfo(fileName{n});
    framesNumber=numel(imageInfo{n});
    FramesInfo(end+1:end+framesNumber,:)=[ones(framesNumber,1)*n [1:framesNumber]'];
end

% This silly line is to remove that [0 0] that wa used for initiating
% FramesInfo
FramesInfo=FramesInfo(2:end,:);

disp(['Found: ' num2str(size(FramesInfo,1)) ' frames'])
disp('Getting response images')

% Now we make a matrix indicating for each trial in the experiment the list
% of indeces of the frames that will be used to compute averae stim images
RespFrames=FrameStart+[1:round(AcqRate*Stimtime)]';

% Now we loop through every trial and every frame that we need to compute
% stim images and get the frames from the files using the information on
% FramesInfo. Average stim images are ultimately saved on StimImages. 
for Trial=1:length(Stimtrig)
    StimImage=[];
    for Fr=1:round(AcqRate*Stimtime)
        StimImage(:,:,Fr)=imread(fileName{FramesInfo(RespFrames(Fr,Trial),1)},FramesInfo(RespFrames(Fr,Trial),2),'Info',imageInfo{FramesInfo(RespFrames(Fr,Trial),1)});
    end
    StimImages(:,:,Trial)=mean(StimImage,3); % We
% could add here an option switch so you can opt to compute stim images
% using percentiles instead of mean.
end

% Same as before but for pre-stim images. 
disp('Getting pre-response images')
PreFrames=FrameStart-round(AcqRate*ISItoSTIMDelay)-[1:round(AcqRate*ISI)]';
for Trial=1:length(Stimtrig)
    PreImage=[];
    for Fr=1:round(AcqRate*ISI)
        PreImage(:,:,Fr)=imread(fileName{FramesInfo(PreFrames(Fr,Trial),1)},FramesInfo(PreFrames(Fr,Trial),2),'Info',imageInfo{FramesInfo(PreFrames(Fr,Trial),1)});
    end
    PreImages(:,:,Trial)=mean(PreImage,3); % This part could use an option
% switch that would allow for a percentile method of computing pre-stim
% images instead of doing average.
end

% We now save Pre and stim Images
save([imgPath 'PreAndStim.mat'],'PreImages','StimImages','StimOrder')