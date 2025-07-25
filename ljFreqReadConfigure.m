function[] = ljFreqReadConfigure(handle, port, debug, efIdx,ljClock)
%LJFREQREADCONFIGURE Function to configure DIO for frequency read on
%LabJack T-series devices
%   
% ljFreqReadConfigure.m
% Julian Bell & Gavin Williamson, JTEC Energy
% 2025-04-16
% 
% This function configures LabJack T7-series DAQ digital inputs to read
% frequency inputs.
% Relevant links:
% - https://labjack.com/pages/support?doc=/datasheets/t-series-datasheet/1325-frequency-in-t-series-datasheet/

    % Disable EF to configure
    LabJack.LJM.eWriteName(handle,[port + "_EF_ENABLE"],0);
    LabJack.LJM.eWriteName(handle,"DIO_EF_CLOCK" + string(ljClock) + "_ENABLE",0);

    %Congiure Correct Clock
    if ljClock ~=0
        slx_eWriteName(handle, "DIO_EF_CLOCK0_ENABLE",0)
    else
        slx_eWriteName(handle, "DIO_EF_CLOCK1_ENABLE",0)
        slx_eWriteName(handle, "DIO_EF_CLOCK2_ENABLE",0)
    end

    
    numFrames = 4;
    aNames = NET.createArray("System.String", numFrames);
    aNames(1) = "DIO_EF_CLOCK" + string(ljClock) + "_ROLL_VALUE";
    aNames(2) = port + "_EF_INDEX";
    aNames(3) = "DIO_EF_CLOCK" + string(ljClock) + "_ENABLE";
    aNames(4) = port + "_EF_ENABLE";

    aValues = NET.createArray("System.Double", numFrames);
    aValues(1) = 0; % Set necessary roll value for reading frequency
    aValues(2) = efIdx;  % 3 = rising-rising, 4 = falling-falling
    aValues(3) = 1; 
    aValues(4) = 1;% Enables the feature

    LabJack.LJM.eWriteNames(handle, numFrames, aNames, aValues, 0);

    if debug
        disp("eWriteNames:");
        for i=1:numFrames
            disp(["  Name: " char(aNames(i)) ", Value: " num2str(aValues(i))])
        end
    end
end