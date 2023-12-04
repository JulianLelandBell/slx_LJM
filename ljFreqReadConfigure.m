function[] = ljFreqReadConfigure(handle, port, debug, efIdx)
%LJFREQREADCONFIGURE Function to configure thermocouple inputs to LabJack
%T7-series devices
%   
% ljFreqReadConfigure.m
% Julian Bell, JTEC Energy
% 2023-11-09
% 
% This function configures LabJack T7-series DAQ digital inputs to read
% frequency inputs.
% Relevant links:
% - https://labjack.com/pages/support?doc=/datasheets/t-series-datasheet/1325-frequency-in-t-series-datasheet/
% 
% NOTE: Does not currently support alternative clock usage

    % Disable EF to configure
    LabJack.LJM.eWriteName(handle,[port + "_EF_ENABLE"],0);
    
    numFrames = 3;
    aNames = NET.createArray("System.String", numFrames);
    aNames(1) = "DIO_EF_CLOCK0_ENABLE";
    aNames(2) = port + "_EF_INDEX";
    aNames(3) = port + "_EF_ENABLE";

    aValues = NET.createArray("System.Double", numFrames);
    aValues(1) = 1;
    aValues(2) = efIdx;  % 3 = rising-rising, 4 = falling-falling
    aValues(3) = 1; % Enables the feature

    LabJack.LJM.eWriteNames(handle, numFrames, aNames, aValues, 0);

    if debug
        disp("eWriteNames:");
        for i=1:numFrames
            disp(["  Name: " char(aNames(i)) ", Value: " num2str(aValues(i))])
        end
    end
end