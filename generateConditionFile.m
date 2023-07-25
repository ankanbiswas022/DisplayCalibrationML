
fid = fopen( 'demoConditions.txt', 'wt' );


TaskObject(1).Type = 'Fix';
TaskObject(1).Arg{1} = 0;
TaskObject(1).Arg{2} = 0;

TaskObject(2).Type = 'Mov';
TaskObject(2).Arg{1} = 'Grating.AVI';
TaskObject(2).Arg{2} = 3;
TaskObject(2).Arg{3} = 0;

TaskObject(3).Type = 'Crc';
TaskObject(3).Arg{1} = 2;
TaskObject(3).Arg{2} = [0 1 0];
TaskObject(3).Arg{3} = 1;
TaskObject(4).Arg{4} = 0;
TaskObject(5).Arg{5} = 0;

Info.Stim1 = 'Grating';
Info.Stim2 = 'Green Circle';

% Then feeding these into the generate_condition function as:
textline = generate_condition('Header', fid);
 fprintf(fid, '%f\n',textline);
textline = generate_condition('Condition', 3, 'Block', [1 2 3], 'Frequency', 1, 'TimingFile', 'MyTF', 'Info', Info, 'TaskObject', TaskObject);