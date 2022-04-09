% Receive EEG signals, and Display the experiment procedure, and predict a word by ESN (RDESN)
% 
% Condition: 
% Streamming and toolbox packages are above directories
%
%*This "toolbox" folder could be adressed to in MATLAB directory. it may be more clear.  
% 
% 
%
%% Starting screen
Screen('Preference', 'SkipSyncTests', 1);

% Choose a display
screens=Screen('Screens');
screenNumber=max(screens);


% Open window with default settings 
w=Screen('OpenWindow', screenNumber);

%Select a background colar
gray=GrayIndex(w,0.3); Screen(w,'FillRect',gray);

% Select specific text font, style and size:
%Screen('TextFont',w, 'Courier New');
Screen('TextSize',w, 120);
Screen('TextStyle', w, 0+1); %Normal and bold

%Draw text on screen
DrawFormattedText(w,'Setting up now. \n\n Please wait for seconds', 'center', 'center',[128,128,128,255]); Screen('Flip',w);


%% ESN setting and training (if there is a trained model, we can just call the function to predict; Do not need to train here)
%Load and prepare data
[trainX, targets] = data_prepare;
%reservoir size, i_scaling, leaky_rate, connectivity, spectral_radius,
%i_dimension, activation, lambda
esn = shoESN(100,1,0.009,0.9,0.9,14,"tanh",0); 

%train ESN
esn.train(trainX, targets);


%% Streaming
% add library path to search path
mfilepath=fileparts(which(mfilename));
%disp(mfilepath);
addpath(fullfile(mfilepath,'./liblsl-Matlab'));
% todo: check the below lines code called many times
if ismac
    % Code to run on Mac platform
    addpath(fullfile(mfilepath,'./bin/mac'));
    addpath(fullfile(mfilepath,'./liblsl-Matlab'));
elseif isunix
    % Code to run on Linux platform
    addpath(fullfile(mfilepath,'./bin/linux'));
elseif ispc
    % Code to run on Windows platform
    addpath(fullfile(mfilepath,'./bin/win64'));
else
    disp('Platform not supported');
end
% instantiate the library
try
    lib = lsl_loadlib(env_translatepath('dependencies:/liblsl-Matlab/bin'));
catch
    lib = lsl_loadlib();
end

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    streamName = 'EmotivDataStream-EEG'; % name of stream. the name is one of vale EmotivDataStream-Motion,
                                         % EmotivDataStream-EEG , 'EmotivDataStream-Performance Metrics'
    result = lsl_resolve_byprop(lib,'name', streamName); 
end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

% get the full stream info (including custom meta-data) and dissect it
inf = inlet.info();
fprintf('The stream''s XML meta-data is: \n');
fprintf([inf.as_xml() '\n']);
fprintf(['The manufacturer is: ' inf.desc().child_value('manufacturer') '\n']);
fprintf('The channel labels are as follows:\n');
ch = inf.desc().child('channels').child('channel');
for k = 1:inf.channel_count()
    fprintf(['  ' ch.child_value('label') '\n']);
    ch = ch.next_sibling();
end

disp('Now receiving data...');

%% Display
%Load words' csv file 
WordList = readtable( 'WordList.csv' );
WordList = WordList(:,1);
WordList = table2array(WordList);

%each text list **Remove randomness for now
fWordList=WordList(1:5,1);
bWordList=WordList(6:10,1);
pWordList=WordList(11:15,1);
mWordList=WordList(16:20,1);
sWordList=WordList(21:25,1);

%Loop is here
for count = 1:5

%shuffle elements for each
fWordList_shuffled = fWordList(randperm(numel(fWordList))) ;
bWordList_shuffled = bWordList(randperm(numel(bWordList))) ;
pWordList_shuffled = pWordList(randperm(numel(pWordList))) ;
mWordList_shuffled = mWordList(randperm(numel(mWordList))) ;
sWordList_shuffled = sWordList(randperm(numel(sWordList))) ;

%make text list for display: This is used as lable in the end
ChosenText = strings(5,1);
ChosenText(1,1) = fWordList_shuffled{1,1}; %If I want to make each one of word from the list show once in a round, we can change this argiremt to WordList_shuffled{idx,1}
ChosenText(2,1) = bWordList_shuffled(1,1); % This idx is in loop, and if idx becomes over 5, idx turns to 1 again.
ChosenText(3,1) = pWordList_shuffled(1,1); % But this is an option
ChosenText(4,1) = mWordList_shuffled(1,1);
ChosenText(5,1) = sWordList_shuffled(1,1);

%Text list for display
TextList0 = append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n\n',ChosenText{4,1},'        ',ChosenText{5,1});
TextList = append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n0\n',ChosenText{4,1},'        ',ChosenText{5,1});
TextList1= append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n1\n',ChosenText{4,1},'        ',ChosenText{5,1});
TextList2= append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n2\n',ChosenText{4,1},'        ',ChosenText{5,1});
TextList3= append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n3\n',ChosenText{4,1},'        ',ChosenText{5,1});
TextList4= append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n4\n',ChosenText{4,1},'        ',ChosenText{5,1});
TextList5= append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n5\n',ChosenText{4,1},'        ',ChosenText{5,1});



    %Draw text on screen
    DrawFormattedText(w,'\nClick one word to utter. \n ', 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    WaitSecs(2);
    DrawFormattedText(w,TextList0, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    %time to select
    GetClicks(w);

    %Draw word from list
    DrawFormattedText(w,TextList5, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    WaitSecs(1);
    DrawFormattedText(w,TextList4, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    WaitSecs(1);
    DrawFormattedText(w,TextList3, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    WaitSecs(1);
    DrawFormattedText(w,TextList2, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    WaitSecs(1);
    DrawFormattedText(w,TextList1, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    
    %timetrackA = datestr(datetime, 'dd-mmm-yyyy HH:MM:SS:FFF');
    
    %recording program here
    %initiation
    arr_vec = zeros(19,256); %need to specify the channels to 14
    inlet = lsl_inlet(result{1});
    
    %get time info
    gt = datetime;
    
    %receive stream data for one second
    for i = 1:256
        [vec,ts] = inlet.pull_sample();
        arr_vec(:,i) = vec';
        % and display it
        fprintf('%.2f\t',vec);
        fprintf('%.5f\n',ts);
    end
    
    %check whether this is real time stream or not
    if datetime - gt <duration(0,0,1)
        fprintf('Too fast. This is not real time');
    else
        fprintf('This is real time');
    end
    
    %timetrackB = datestr(datetime, 'dd-mmm-yyyy HH:MM:SS:FFF');
    
    %we can comment out this if we want 0 to apprear 
    %DrawFormattedText(w,TextList, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    
    % //// ESN word prediction ////
    testX = arr_vec(4:end-2,:);
    
    results = esn.predict(testX)';
    %Modify the format for Classificatioin (for confusion matrix)
    H = classifyOutput(results);
    
    %Display the hypothesis
    TextList6= append(ChosenText{1,1},'        ',ChosenText{2,1},'        ',ChosenText{3,1},'\n',ChosenText{H(1),1},'\n',ChosenText{4,1},'        ',ChosenText{5,1});
    DrawFormattedText(w,TextList6, 'center', 'center',[128,128,128,255]); Screen('Flip',w);
    WaitSecs(2);
    
end
    Screen('CloseAll');

%% time lag infomation
%lsl_inlet -> 0.02s
% recording time -> 1+0.024=1.024s
% check(if sentence) -> 0.006s
% 
% Total -> 1.043s