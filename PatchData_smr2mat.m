function [CameraTimes,Stimtrig]=PatchData_smr2mat(Path)
cedpath = 'C:\Users\Augusto\Documents\MATLAB\FitzCode\CEDMATLAB\CEDS64ML';
addpath( cedpath );
CEDS64LoadLib( cedpath );
[ fhand ] = CEDS64Open([Path 'Spike2Data.smr'],1);

maxTimeTicks = CEDS64ChanMaxTime( fhand, 1 )+1;
[ fRead, fVals, fTime ] = CEDS64ReadWaveF( fhand, 1, maxTimeTicks, 0, maxTimeTicks );
CEDS64TicksToSecs(fhand,maxTimeTicks)
AcqRate=round(length(fVals)/CEDS64TicksToSecs(fhand,CEDS64ChanMaxTime(fhand,1)));
[iEv Stimtrig]=CEDS64ReadEvents(fhand,22,10000,0);
[iEv CameraTimes]=CEDS64ReadEvents(fhand,23,100000,0);
Stimtrig=CEDS64TicksToSecs(fhand,Stimtrig);
CameraTimes=CEDS64TicksToSecs(fhand,CameraTimes);
Waveform.interval=1/AcqRate;
Waveform.values=fVals;
save([Path 'Spike2Data.mat'],'Waveform','Stimtrig','CameraTimes')