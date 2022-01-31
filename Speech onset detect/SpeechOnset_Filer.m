%make Speech onset event file, "eventFile.txt", including 'Type(Index)',
%and 'Latency(time)' for handing to EEGLAB for epoch

%%
clear all
close all
%% XDF FILE CONVERTER
%Import the XDF data to cell
addpath('C:\\path\\to\\xdf_repo\\Matlab\\xdf')
streams = load_xdf('EEGdata_KIT/Togawa_2.xdf');
%% Data Variables
EEGDATA = streams{1,1};
TRIGGER = streams{1,2};
AUDIO = streams{1,3};
%% TRIGGER data and timeStamp
%get "response(Index)"
data_tri = TRIGGER.time_series; data_tri = double(data_tri);
%get "latency(time)"
dataStamp_tri = TRIGGER.time_stamps;

%% EEG data and timeStamp
data_eeg = EEGDATA.time_series; data_eeg = data_eeg(4:17,:); %Only for plotting
dataStamp_eeg = EEGDATA.time_stamps;

%% AUDIO data and timestamp  <THIS CAN BE A FUNCTION>
data_audio = AUDIO.time_series;
% info based dataStamp_audio
durtion_audio = str2num(AUDIO.info.last_timestamp) - str2num(AUDIO.info.first_timestamp);
fs_audio = 44100;
dataStamp_audio = 0:1/fs_audio:durtion_audio;
%Calculate the gap for line up the number of both data samples and time points
SampleGap = length(data_audio) - length(dataStamp_audio);

%Updata data_audio
%Remove some of the end samples from data sample(the last has none info)
if SampleGap >0
    data_audio = data_audio(1:end-SampleGap);
else
    dataStamp_audio = dataStamp_audio(1:end-abs(SampleGap));
end
%since this starts from zero, add the first_timestamp 
%This is important to same the timestamp as eeg and trigger
dataStamp_audio = dataStamp_audio + str2double(AUDIO.info.first_timestamp);

%% generate a sequence number for No of epoch
epoch_num = [1:length(data_tri)]; epoch_num = double(epoch_num);


%% Speech Onset
SpeechOnset = SpeechOnsetFinder(dataStamp_eeg,dataStamp_tri,dataStamp_audio,data_audio);

%% MAKE A EVENT FILE
%event file
eventFile = [data_tri' SpeechOnset'];

%make each header
header = {'Type','Latency'};

%add the header to eventhFile
eventFile = [header; num2cell(eventFile)];

%convert cell file to table file
T = cell2table(eventFile);
%table -> text file
writetable(T,'eventFile.txt','WriteVariableNames' ,false)

%% PLOT
SpeechOnsetPlot(dataStamp_eeg,dataStamp_audio,dataStamp_tri,data_audio,SpeechOnset,data_eeg)