function[] = ljThermistorConfigure(handle, port, debug, efIdx,confA,confB,confC,confD,confE,confF,confG,confH,confI,confJ)
%LJTHERMISTORCONFIGURE Function to configure thermistor inputs to LabJack
%T-series devices
%   
% ljThermistorConfigure.m
% Julian Bell, JTEC Energy
% 2023-10-13
% 
% This function configures LabJack T-series DAQ analog outputs to read
% thermistors.
% 
% Relevant references:
% - https://labjack.com/pages/support?doc=%2Fdatasheets%2Ft-series-datasheet%2F1415-thermistor-t-series-datasheet%2F
% - https://labjack.com/pages/support?doc=%2Fdatasheets%2Ft-series-datasheet%2F14101-excitation-circuits-t-series-datasheet%2F
% - (If using the LJTick-Resistance) https://labjack.com/pages/support?doc=%2Fdatasheets%2Faccessories%2Fljtick-resistance-datasheet%2F

    numFrames = 11;
    aNames = NET.createArray("System.String", numFrames);
    aNames(1) = port + "_EF_INDEX";
    aNames(2) = port + "_EF_CONFIG_A";
    aNames(3) = port + "_EF_CONFIG_B";
    aNames(4) = port + "_EF_CONFIG_C";
    aNames(5) = port + "_EF_CONFIG_D";
    aNames(6) = port + "_EF_CONFIG_E";
    aNames(7) = port + "_EF_CONFIG_F";
    aNames(8) = port + "_EF_CONFIG_G";
    aNames(9) = port + "_EF_CONFIG_H";
    aNames(10) = port + "_EF_CONFIG_I";
    aNames(11) = port + "_EF_CONFIG_J";
    aValues = NET.createArray("System.Double", numFrames);
    aValues(1) = efIdx;  % 50 for Steinhart-Hart eqn, 51 for beta equation
    aValues(2) = confA; % 0 = K, 1 = C, 2 = F
    aValues(3) = confB; % Excitation circuit index
    aValues(4) = confC; % Extra AIN used to measure voltage. Only relevant for confB = 3 or 5
    aValues(5) = confD; % Excitation volts or amps. If confB = 2, fixed amps of current source. If confB = 4, fixed volts of voltage source. Otherwise ignored
    aValues(6) = confE; % Fixed resistor ohms
    aValues(7) = confF; % Normal resistance in ohms of thermistor at 25 C
    aValues(8) = confG; % Steinhart-Hart: A  |  Beta: Beta
    aValues(9) = confH; % Steinhart-Hart: B  |  Beta: deg C at which Beta determined
    aValues(10) = confI; % Steinhart-Hart: C  |  Beta: N/A
    aValues(11) = confJ; % Steinhart-Hart: D  |  Beta: N/A

    LabJack.LJM.eWriteNames(handle, numFrames, aNames, aValues, 0);

    if debug
        disp("eWriteNames:");
        for i=1:numFrames,
            disp(["  Name: " char(aNames(i)) ", Value: " num2str(aValues(i))])
        end
    end
end