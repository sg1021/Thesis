function SpeechOnset = SpeechOnsetFinder(dataStamp_eeg,dataStamp_tri,dataStamp_audio,data_audio)

%This function detects the speech onsets and returns the timings


%define the starting point as the first eeg timeStamp
real_start_eeg = dataStamp_eeg(1); 
%fix the trigger timeStamp by subtracting by real_start_eeg
lined_dataStamp_tri = dataStamp_tri - real_start_eeg;
%fix the audio timeStamp too
lined_dataStamp_audio = dataStamp_audio - real_start_eeg; 

%pick each psk and locs
[pks,locs] = findpeaks(double(data_audio),lined_dataStamp_audio,'MinPeakHeight',5000,'MinPeakDistance',1.5);

%set two counters
i = 1; j = 1;
%make new arrays
new_locs = zeros(1,length(lined_dataStamp_tri));
new_pks = zeros(1,length(lined_dataStamp_tri));

%filtering the locs&psk values, and appending the appropriate locs&pks into new_locs and new_pks.
while 1
    if j == length(lined_dataStamp_tri)+1
        break
    %Trigger starts when the WORD apprears, and SPEECHCUE shows after 2s.
    %So, we guess the speechonset apprears during (trigger+2)-(trigger+5)
    elseif locs(i) > lined_dataStamp_tri(j)+0 && locs(i) < lined_dataStamp_tri(j)+7
        new_locs(1,j) = locs(i);
        new_pks(1,j) = pks(i);
        %increase both counters
        i = i+1; j = j+1;
        disp(new_pks)
    else i = i+1;
    end
end

% Each Speech onset point
SpeechOnset = new_locs;
end