% MonitorCalibrationTiming file

% Note:
% Using the scene based framework to display the stimuli. If this
% does not work on your PC, please update the Monkeylogic.
% Tested on MonkeyLogic Version 2.2.32 (Jan7, 2023)

% Dependency alert: Make sure the alert function and the relevant audio
% files are present in the same folder as the conditions file.

hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
set_bgcolor([0.5 0.5 0.5]);                                         % sets subject screen background color to Gray
editable('pulseDuration','stimulus_duration','fix_radius');         % adds the variables on the Control screen to make on the fly changes

if strcmp(MLConfig.ExperimentName,'DCM')
    % Display Calibration Mode
    global PRport fileroot LumValues

    MLConfig.CondLogic=3;  
    stimulus = 2;
    stimDurForMeasure = 3000;    
    tc = TimeCounter(null_);
    tc.Duration = stimDurForMeasure;         % in milliseconds
    sceneMeasure = create_scene(tc,stimulus);
    run_scene(sceneMeasure);

    if  TrialRecord.CurrentCondition==1
        % Init folder
        LumValues = [];
        thisCalibName = MLConfig.FormattedName;
        thisCalibFolder = fullfile('..', 'DisplayCalibrationML','measurements');
        fileroot = fullfile(thisCalibFolder, filesep, thisCalibName);
        % Init PR655
        addpath(genpath(fullfile(pwd,'PR655connPTB')));
        PRport = FindSerialPort([], 1, 1);
        PR655init(PRport);
    end
    % Take Measurements and save them
    currCond = TrialRecord.CurrentCondition;
    value = TrialRecord.CurrentConditionInfo.v;
    [xyYcie, xyYJudd, Spectrum] = getSpectraValPR655;
    LumValues(currCond,1).gunValue=value;
    LumValues(currCond,1).xyYcie=xyYcie;
    LumValues(currCond,1).xyYJudd=xyYJudd;
    LumValues(currCond,1).Spectrum=Spectrum;
    if isempty(TrialRecord.ConditionsThisBlock)
        PR655close()
        save([fileroot, '.mat'], 'LumValues');
    end
    idle(50);  % clear screen
    error_type = 0;
    trialerror(error_type);
    set_iti(1000);
else
    % Task Mode
    % detect an available tracker
    if exist('eye_','var'), tracker = eye_;
    else, error('This task requires eye input. Please set it up or turn on the simulation mode.');
    end

    % Mapping to the TaskObjects defined in the conditions file
    fixation_point = 1;
    stimulus = 2;

    % time intervals (in ms):
    wait_for_fix = 1000;
    initial_fix = 1000;
    stimulus_duration = 10000;
    pulseDuration = 50;

    % fixation window (in degrees):
    fix_radius = [4 4];
    hold_radius = fix_radius ;

    % creating Scenes
    % Adapter to play audio at the start of the trial
    sndTrialStart = AudioSound(null_);
    sndTrialStart.List = 'trialStart.wav';   % wav file
    sndTrialStart.PlayPosition = 0;    % play from 0 sec

    % Adapter to play audio when the fixation is acquired
    sndAquireStart = AudioSound(null_);
    sndAquireStart.List = 'acquireStart.wav';   % wav file
    sndAquireStart.PlayPosition = 0;    % play from 0 sec

    % scene 1: wait for fixation
    fix1 = SingleTarget(tracker);   % We use eye signals (eye_) for tracking. The SingleTarget adapter examines if the gaze is in the Threshold window around the Target.
    fix1.Target = fixation_point;   % The Target can be either TaskObject# or [x y] (in degrees).
    fix1.Threshold = fix_radius;

    wth1 = WaitThenHold(fix1);      % The WaitThenHold adapter waits for WaitTime until the fixation
    wth1.WaitTime = wait_for_fix;   % is acquired and then checks whether the fixation is held for HoldTime.
    wth1.HoldTime = 1;              % Since WaitThenHold gets the fixation status from SingleTarget, SingleTarget (fix1) must be the input argument of WaitThenHold (wth1).
    wth1.AllowEarlyFix = false;     % End the scene if the monkey is fixating before the scene starts

    con1 = Concurrent(wth1);
    con1.add(sndTrialStart);        % Start the trial and concurrently play the trialStart audio
    scene1 = create_scene(con1,fixation_point);  % In this scene, we will present the fixation_point (TaskObject #1) and wait for fixation.

    % scene 2: hold fixation
    fix2 = SingleTarget(tracker);
    fix2.Target = fixation_point;
    fix2.Threshold = hold_radius;
    wth2 = WaitThenHold(fix1);
    wth2.WaitTime = 0;              % We already know the fixation is acquired, so we don't wait.
    wth2.HoldTime = initial_fix;    % hold the fixation for the specified time
    con2 = Concurrent(wth2);
    con2.add(sndAquireStart);

    scene2 = create_scene(con2,fixation_point); % In this scene, we will present the fixation_point (TaskObject #1) and hold fixation.

    % scene 3: sample [A full scne consist of 1.acquire, 2. sound and then 3. stimulus]
    fix3 = SingleTarget(tracker);
    fix3.Target = stimulus;
    fix3.Threshold = hold_radius;
    wth3 = WaitThenHold(fix3);
    wth3.WaitTime = 0;             % We already know the fixation is acquired, so we don't wait.
    wth3.HoldTime = stimulus_duration;
  
    sceneMeasure = create_scene(wth3,[fixation_point stimulus]);

    % TASK:
    error_type = 0;

    run_scene(scene1,10);        % Run the first scene (eventmaker 10)
    if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
        if wth1.Waiting          % check whether we were waiting for fixation.
            error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
        else
            error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        end                      % so this is a "break fixation (3)" error.
    end

    if 0==error_type
        run_scene(scene2,10);    % Run the second scene (eventmarker 20)
        if ~wth2.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the stimulus.
            error_type = 3;      % So it is a "break fixation (3)" error.
        end
    end

    if 0==error_type
        run_scene(sceneMeasure,20);     % Run the second scene (eventmarker 20)
        if ~wth3.Success                % The failure of WithThenHold indicates that the subject didn't maintain fixation on the stimulus.
            error_type = 3;             % So it is a "break fixation (3)" error.
        end
    end

    % reward
    if 0==error_type
        idle(0);                 % Clear screens
        goodmonkey(pulseDuration, 'juiceline',1, 'numreward',1, 'pausetime',0, 'eventmarker',50); % used-defined amount of juice
    else
        idle(700);               % Clear screens
    end

    trialerror(error_type);      % Add the result to the trial history
    set_iti(1000);
end