% PatchData_smr2mat will make a mat file from your .smr spike 2 file and
% get your timestamps for the frames (CameraTimes) and stimuls start
% (Stimtrig).If you have other/better function to get these two things you
% can replace it here.
[CameraTimes,Stimtrig]=PatchData_smr2mat('I:\Fits Lab Data\Patch\2020-07-07\t00005\');%Input here the folder where your spike2 file is
% Seems like PatchData_smr2mat gives you an extra Stimtrig that corresponds
% to the experiment start instead of an actual stim start. This line
% removes it.
Stimtrig=Stimtrig(2:end);
% getStimOrder gets you the order of your stims from the stimOrder txt file
% (Assuming your stimulus code does this). There are ways of getting this
% straight from spike2 (though when I was using this it would sometimes not
% give you the accurate number for some reason). If you would rather use
% that just replace here.
StimOrder=getStimOrder('I:\Fits Lab Data\Patch\2020-07-07\t00005\');%Input here the folder where your spike2 file is



%% get2PPreAndStimFromTif: Now to the meaty part, once you have your Stim 
% trigers, frame trigers and stimulus order these get inputed to get2PPreAndStimFromTif
% along with some other inputs you need to provide:
% In argument 1 input: the folder where your 2P tif files are, 
% in argument 5 input: how long (in seconds) will be the time window for which
% the stimulus average response will be calculated, it should be equal or
% less than stimulus presentation time. This window will start when
% stimulus starts if argument 7 is 0 (see below) or some time after
% stimulus start if argument 7 is >0.
% In argument 6 input: how long (in seconds) will be the time window for which
% the pre-stimulus average response will be calculated, it should be equal or
% less than ISI. This window will end right when stimuls start.
% In argument 7 input: how long (in seconds) will be the delay between stimulus 
% start and the start of the window for which stimulus response will be computed.
% You most likely want this to be 0 but it was added for analysis of an
% atractor network experiment.
% get2PPreAndStimFromTif will then compute mean images of fluorescence during
% pre-stim and stimulus presentation for each trial in your experiment and
% save it on a file called "PreAndStim.mat" in the path where your tif
% files are.

get2PPreAndStimFromTif('I:\Fits Lab Data\PatchWF\F2447_07_07_2020\2P_6\',CameraTimes,Stimtrig,StimOrder,1,1,0)