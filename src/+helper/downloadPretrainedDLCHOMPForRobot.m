function data = downloadPretrainedDLCHOMPForRobot(robotName)
%downloadPretrainedDLCHOMPForRobot Downloads pretrained DLCHOMP network and
%planner for the specified supported robot having name ROBOTNAME
%
%   Example:
%       data = helper.downloadPretrainedDLCHOMPForRobot("kukaIiwa7");
%
    downloadFolderPath = fullfile('models',robotName);
    baseURL = "https://ssd.mathworks.com/supportfiles/rst/data/dlCHOMP/R2024a";
    supportedRobots = [...
        "abbYuMi";...
        "fanucLRMate200ib";...
        "fanucM16ib";...
        "frankaEmikaPanda";...
        "kinovaJacoJ2S7S300";...
        "kinovaGen3";...
        "kukaIiwa7";...
        "meca500r3";...
        "techmanTM5-700";...
        "universalUR5e"];
    isRobotSupported = ismember(robotName,supportedRobots);
    if isRobotSupported
        zipFileName = sprintf("%sDLCHOMPTrained.zip",robotName);
        zipFilePath = fullfile(downloadFolderPath,zipFileName);
        zipURL = fullfile(baseURL,zipFileName);
        matFileName = "trainedDLCHOMP.mat";
        matFilePath = fullfile(downloadFolderPath,matFileName);
        if ~exist(matFilePath,'file')
            fprintf('Downloading pretrained DLCHOMP network and planner for %s.\n', robotName);
            fprintf('This can take several minutes to download...\n');
            mkdir(fileparts(zipFilePath));
            websave(zipFilePath,zipURL);
            unzip(zipFilePath,downloadFolderPath);
        end
        data = load(matFilePath);
    else
        error("%s is not a supported robot. Please specify a supported robot.",robotName);
    end
end