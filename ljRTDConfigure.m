function[] = ljRTDConfigure(handle, port, debug, efIdx,confA,confB,confC,confD,confE)
%LJRTDCONFIGURE Function to configure RTD inputs to LabJack T-series devices
%   
% ljRTDConfigure.m
% Julian Bell, JTEC Energy
% 2023-11-29
% 
% This function configures LabJack T-series DAQ analog inputs to read RTDs.
% Only works with the T-series devices.
%
% Read AIN#_EF_READ_A to get the temperature from the RTD. Can also read
% READ_B, READ_C and READ_D to get resistance, voltage, and current
% respectively. Must read A to update values on B, C & D.
% 
% Relevant references:
% - https://labjack.com/pages/support?doc=%2Fapp-notes%2Fsensor-types-app-note%2Frtd%2F
% - https://labjack.com/pages/support?doc=%2Fdatasheets%2Ft-series-datasheet%2F1413-rtd-t-series-datasheet%2F
% - (If using the LJTick-Resistance) https://labjack.com/pages/support?doc=%2Fdatasheets%2Faccessories%2Fljtick-resistance-datasheet%2F

    numFrames = 6;
    aNames = NET.createArray("System.String", numFrames);
    aNames(1) = port + "_EF_INDEX";
    aNames(2) = port + "_EF_CONFIG_A";
    aNames(3) = port + "_EF_CONFIG_B";
    aNames(4) = port + "_EF_CONFIG_C";
    aNames(5) = port + "_EF_CONFIG_D";
    aNames(6) = port + "_EF_CONFIG_E";
    aValues = NET.createArray("System.Double", numFrames);
    aValues(1) = efIdx;  % 40 = PT100, 41 = PT500, 42 = PT1000
    aValues(2) = confA; % 0 = K, 1 = C, 2 = F
    aValues(3) = confB; % Excitation circuit index. If using LJTick-Resistance, use circuit index 4
    aValues(4) = confC; % Extra AIN used to measure voltage. Only relevant for confB = 3 or 5
    aValues(5) = confD; % Excitation volts or amps. If confB = 2, fixed amps of current source. If confB = 4, fixed volts of voltage source. Otherwise ignored
    aValues(6) = confE; % Fixed resistor ohms

    LabJack.LJM.eWriteNames(handle, numFrames, aNames, aValues, 0);

    if debug
        disp("eWriteNames:");
        for i=1:numFrames,
            disp(["  Name: " char(aNames(i)) ", Value: " num2str(aValues(i))])
        end
    end
end