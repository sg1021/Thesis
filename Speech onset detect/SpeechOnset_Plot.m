function SpeechOnsetPlot(dataStamp_eeg,dataStamp_audio,dataStamp_tri,data_audio,SpeechOnset,data_eeg)

%This function gives the plot of EEG with speech onset xlines

%Find the starting point
real_start_eeg = dataStamp_eeg(1); 

%Adjust x (time) axis to start 0 (s) by subtracting the starting point
t_audio = dataStamp_audio-real_start_eeg;
% <NEW> Trigger info too   
t_tri = dataStamp_tri - real_start_eeg;
%% <<Plot audio data>>
%Plot
% subplot(2,1,2);
plot(t_audio,data_audio)
xlim([-5 t_audio(end)+5])
hold on
for i = 1:length(SpeechOnset)
xline(SpeechOnset(i),'LineWidth',0.01)
xline(t_tri(i),'LineWidth',0.01,'Color','red')
end

title('Audio')
xlabel("time (s)")


%% <<EEG PLOT>>
% %Adjust x (time) axis by subtracting the audio starting point
% t_eeg = dataStamp_eeg - real_start_eeg;
% 
% %plot
% subplot(2,1,1);
% plot(t_eeg,data_eeg(6,:))
% xlim([-5 t_audio(end)+5])
% 
% hold on
% for i = 1:length(SpeechOnset)
% xline(SpeechOnset(i),'LineWidth',0.01)
% end
% 
% title('eeg (1 channel)')
% xlabel("time (s)")

end
