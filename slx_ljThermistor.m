%SLX_LJTHERMISTOR Mask initialization for lj_ThermistorRead block
%   
% slx_ljThermistor.m
% Julian Bell, JTEC Energy
% 2024-01-04
% 
% This class definition configures & initializes the mask for the
% lj_ThermistorRead block in slx_LJM
% 
% Relevant references:
% - XXX
%
% TODO:
% - Add control of other thermistor configuration parameters to mask


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

                % Run thermistor configuration script
                ljThermistorConfigure(ljHandle,ljPort,false,50,tempUnitIdx,4,0,2.5,refResistanceVal,thermResVal,1.032e-3,2.387e-4,0,1.580e-7);
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end 
        end

        % Use the code browser on the left to add the callbacks.

    end
end