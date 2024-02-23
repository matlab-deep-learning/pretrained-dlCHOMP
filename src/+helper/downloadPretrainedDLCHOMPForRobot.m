function data = downloadPretrainedDLCHOMPForRobot(robotName)
%downloadPretrainedDLCHOMPForRobot Downloads pretrained DLCHOMP network and
%planner for the specified supported robot having name ROBOTNAME
%
%   Example:
%       data = helper.downloadPretrainedDLCHOMPForRobot("kukaIiwa7");
%
    dataPath = fullfile('model',robotName);
    baseURL = "https://ssd.mathworks.com/supportfiles/rst/data/dlCHOMP/R2024a";
    switch robotName
        case 'abbYuMi'
            isRobotSupported = 1;
        case 'fanucLRMate200ib'
            isRobotSupported = 1;
        case 'fanucM16ib'
            isRobotSupported = 1;
        case 'frankaEmikaPanda'
            isRobotSupported = 1;
        case 'kinovaJacoJ2S7S300'
            isRobotSupported = 1;
        case 'kinovaGen3'
            isRobotSupported = 1;
        case 'kukaIiwa7'
            isRobotSupported = 1;
        case 'meca500r3'
            isRobotSupported = 1;
        case 'techmanTM5-700'
            isRobotSupported = 1;
        case 'universalUR5e'
            isRobotSupported = 1;
        otherwise
            isRobotSupported = 0;
    end
    if isRobotSupported
        zipFileName = sprintf("%sDLCHOMPTrained.zip",robotName);
        zipFilePath = fullfile(dataPath,zipFileName);
        zipURL = fullfile(baseURL,zipFileName);
        matFileName = "trainedDLCHOMP.mat";
        matFilePath = fullfile(dataPath,matFileName);
        if ~exist(matFilePath,'file')
            fprintf('Downloading pretrained DLCHOMP network and planner for %s.\n', robotName);
            fprintf('This can take several minutes to download...\n');
            mkdir(fileparts(zipFilePath));
            websave(zipFilePath,zipURL);
            unzip(zipFilePath,dataPath);
        end
        data = load(matFilePath);
    else
        error("%s is not a supported robot. Please specify a supported robot.",robotName);
    end
end