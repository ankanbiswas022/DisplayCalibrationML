% script to display the luminance profile of the Monitor

% file paths:
driveSourcePath = 'G:\.shortcut-targets-by-id\0B3it2YnTGM9gSVdVc3RDM09fSE0\RayLabCNS';
folderSourcePath = 'Instructions\MonitorCalibrationLogs';
cd(fullfile(driveSourcePath,folderSourcePath));

[rigName,dateOfCreation,fileExtension] = alllDisplayProfilingLog;

index=4; 
rigName  = rigName{index};
dateOfCreation = dateOfCreation{index};
fileExtension = fileExtension{index};

% load File:
fileName = [rigName '_' dateOfCreation fileExtension];
filePath = fullfile(driveSourcePath,folderSourcePath,rigName,fileName);

if strcmp(fileExtension,'.mat')
    load(filePath);
    % get lum Values
    for i = 1:length(LumValues)     
        Yvals(1,i) = LumValues(i).xyYJudd(3);
    end
elseif strcmp(fileExtension,'.csv')
    data=readtable(filePath);
    Yvals = table2array(data(3,2:end));
else
    disp('Unable to load; unknown file type');
end

% plot gun Vs lum Values:
colors      = {'k', 'r', 'g','b'};
startIndexS = [1,12,23,34];
numValues   = 10;
textLocation = [0.1 1];

for i=1:length(colors)
    startIndex = startIndexS(i);
    endIndex = startIndex+numValues;

    ydataold = Yvals(startIndex:endIndex);
    xdataold = 0:0.1:1;

    ydata = ydataold./max(ydataold);
    xdata = xdataold./max(xdataold);

    % define start params and fit
    p0 = [min(ydata) 1 2.2]; % starting values for [a/p(1), b/p(2), gamma/p(3)]
    fun = @(p, x) p(1)+p(2)*x.^p(3); % better evaluation of gamma than just x.^gamma

    pfit = lsqcurvefit(fun, p0, xdata, ydata);
    yfit = feval(fun, pfit, xdata);
    residuals = yfit - ydata;
    RMS = sqrt(mean(residuals.^2)); %evaluate fit

    % plot Data
    plot(xdata, ydata, '.', 'color', colors{i}, 'MarkerSize', 30);
    hold on
    plot(xdata, feval(fun, pfit, xdata), colors{i});

    textString = (sprintf('%s gun - Max Lum = %3.1f - Gamma = %3.2f',colors{i}, ...
        max(ydataold),pfit(3)));
    text(textLocation(1),textLocation(2),textString,'Color',colors{i},'FontWeight','bold');
    xlabel('input proportion of gun value','FontWeight','bold');
    ylabel('output proportion of Luminance max','FontWeight','bold');
    textLocation(2)=textLocation(2)-0.06;
end