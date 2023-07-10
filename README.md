# DisplayCalibrationML
This folder contains all the necessary files needed to display colors: RGB and Gray at 11 intensity levels between 0 to 1 using MonkeyLogic(ML).

**ML needs following files:**

(1) Conditions file (MonitorCalibrationConditions) <br>
(2) Timing file (MonitorCalibrationTiming) <br>
(3) function to make the stimulus(makeStim.m) <br>

Associated files which need to be present in the task directory: <br>

(4) Alert function <br>
(5) Task related audio stimuli  <br>

**Note:** <br>
Every time you run the task, a .cfg file is created in the task directory. This has all the configuration details <br>
which are set in the control GUI. <br>

**Testing:** <br>
The task was tested on MonkeyLogic Version 2.2.32(Jan7,2023). <br>
If you are facing any issue while running the task, it might be related to the version of the monkeyLogic yiu are using. <br>
kindly update the monkeyLogic and use the version on which the task was tested. <br> 

**Use:** <br>
Fork this Repository to have your own copy of this Repo. <br>
Note that this Repo is under active development. <br> 
In case you have any are facing any problem or have any particular development in mind, kindly create issue in the Repo. <br>


**Disclaimer:** <br>
For creating the following files we have adapted ML helper functions. Audio files were taken from the Lablib. 

