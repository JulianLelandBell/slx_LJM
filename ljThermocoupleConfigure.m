function[] = ljThermocoupleConfigure(handle, port, debug, efIdx, negPort, tempUnits)
%LJTHERMOCOUPLECONFIGURE Function to configure thermocouple inputs to LabJack
%T7-series devices
%   
% ljThermocoupleConfigure.m
% Julian Bell, JTEC Energy
% 2023-10-30
% 
% This function configures LabJack T7-series DAQ analog inputs to read
% thermocouples.
% 
% Relevant references:
% - https://labjack.com/pages/support?doc=%2Fdatasheets%2Ft-series-datasheet%2F1411-thermocouple-t7-only-t-series-datasheet%2F

    numFrames = 3;
    aNames = NET.createArray("System.String", numFrames);
    aNames(1) = port + "_EF_INDEX";
    aNames(2) = port + "_EF_CONFIG_A";
    aNames(3) = port + "_NEGATIVE_CH";

    aValues = NET.createArray("System.Double", numFrames);
    aValues(1) = efIdx;  % 21 for Type J, 22 for Type K. See datasheet for other types
    aValues(2) = tempUnits; % 0 = K, 1 = C, 2 = F
    aValues(3) = negPort; % Negative channel for input

    LabJack.LJM.eWriteNames(handle, numFrames, aNames, aValues, 0);

    if debug
        disp("eWriteNames:");
        for i=1:numFrames
            disp(["  Name: " char(aNames(i)) ", Value: " num2str(aValues(i))])
        end
    end
end