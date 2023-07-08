# DisplayCalibrationML
This folder contains all the necessary files needed to display primary colors using MonkeyLogic(ML).

**ML needs following files:**

(1) Conditions file (MonitorCalibrationConditions) <br>
(2) Timing file (MonitorCalibrationTiming) <br>
(3) function to make the stimulus(makeStim.m) <br>

Associated files which need to be present in the task directory: <br>

(4) Alert function <br>
(5) Task related audio stimuli  <br>

**Note:**

Every time you run the task, a .cfg file is created in the task directory. This has all the configuration details <br>
which are set in the control GUI. <br>

**Disclaimer:**

For creating the following files we have adapted ML helper functions. Audio files were taken from the the Lablib. 
