%SLX_LJTHERMISTOR Mask initialization for lj_ThermistorRead block
%   
% slx_ljThermistor.m
% Julian Bell & Gavin Williamson, JTEC Energy
% 2025-04-16
% 
% This class definition configures & initializes the mask for the
% lj_ThermistorRead block in slx_LJM

classdef slx_ljThermistor

    properties
        ljHandle double
        ljID string
    end

    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle 
        %  - MaskObject 
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)

            % Create mask contexts
            bh = maskInitContext.BlockHandle;
            mo = maskInitContext.MaskObject;
            mw = maskInitContext.MaskWorkspace;

            % Get parent block ID
            parentID = get_param(bh,'Parent');

           try
                disp('Trying to configure thermistor input')

                % Get port & handle
                ljPort = mw.get('ljPort');
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);

                % Get temp unit, thermistor resistance, and reference
                % resistance
                tempUnit = mw.get('tempUnit'); % For reasons I don't understand, this is formatted as {'C'}?
                switch tempUnit
                    case 3
                        tempUnitIdx = 0;
                    case 1
                        tempUnitIdx = 1;
                    case 2
                        tempUnitIdx = 2;
                    otherwise
                        disp('Invalid temperature type - defaulting to C')
                        tempUnitIdx = 1;
                end
                disp(['The desired temperature output unit is ', num2str(tempUnit),' and the index is ', num2str(tempUnitIdx)]);

                thermResVal= mw.get('thermRes');
                disp(['The thermistor resistance value is ', num2str(thermResVal)]);
                
                refResistanceVal = mw.get('refResistance');
                disp(['The reference resistance value is ', num2str(refResistanceVal)]);

                % Get handles
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);

                %Configure AIN port
                if getDeviceType(ljHandle) == int32(4) %T4 Configuration
                    numFrames=3;
                    aNames = NET.createArray('System.String', numFrames);
                    aNames(1) = [char(ljPort),'_RANGE'];
                    aNames(2) = [char(ljPort),'_RESOLUTION_INDEX'];
                    aNames(3) = [char(ljPort),'_SETTLING_US'];
                    aValues = NET.createArray('System.Double',numFrames);
                    aValues(1) = 0;
                    aValues(2) = 0;
                    aValues(3) = 0;
                elseif getDeviceType(ljHandle) == int32(7) %T7 Configuration
                    numFrames=4;
                    aNames = NET.createArray('System.String', numFrames);
                    aNames(1) = [char(ljPort),'_NEGATIVE_CH'];
                    aNames(2) = [char(ljPort),'_RANGE'];
                    aNames(3) = [char(ljPort),'_RESOLUTION_INDEX'];
                    aNames(4) = [char(ljPort),'_SETTLING_US'];
                    aValues = NET.createArray('System.Double',numFrames);
                    aValues(1) = 199;
                    aValues(2) = 10;
                    aValues(3) = 0;
                    aValues(4) = 0;
                end
                LabJack.LJM.eWriteNames(ljHandle,numFrames,aNames,aValues,0);

                % Run thermistor configuration script
                a = mw.get('a');
                b = mw.get('b');
                c = mw.get('c');
                d = mw.get('d');
                ljThermistorConfigure(ljHandle,ljPort,false,50,tempUnitIdx,4,0,2.5,refResistanceVal,thermResVal,a,b,c,d);
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end 
        end

        % Use the code browser on the left to add the callbacks.


        function thermistor_doc(callbackContext)
            web('https://support.labjack.com/docs/14-1-5-thermistor-t-series-datasheet')
        end

        function ex_circ_4(callbackContext)
            web('https://support.labjack.com/docs/14-1-0-1-excitation-circuits-t-series-datasheet')        
        end

        function res_tick(callbackContext)
            web('https://support.labjack.com/docs/ljtick-resistance-datasheet')
        end
    end
end