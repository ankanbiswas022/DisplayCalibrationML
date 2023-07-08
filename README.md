# DisplayCalibrationML
This folder contains all the necessary files needed to display primary colors using MonkeyLogic(ML).

ML needs following files:

(1) Conditions file (MonitorCalibrationConditions)
(2) Timing file (MonitorCalibrationTiming)
(3) function to make the stimulus(makeStim.m)

Associated files which need to be present in the task directory:

(4) Alert function 
(5) Task related audio stimuli 

Note: 

Every time you run the task, a .cfg file is created in the task directory. This has all the configuration details 
which are set in the control GUI. 

Disclaimer: 

For creating the following files we have adapted ML helper functions. Audio files were taken from the the Lablib. 
