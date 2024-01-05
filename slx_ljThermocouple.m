%SLX_LJTHERMOCOUPLE Mask initialization for lj_ThermocoupleRead block
%   
% slx_ljThermocouple.m
% Julian Bell, JTEC Energy
% 2023-12-06
% 
% This class definition configures & initializes the mask for the
% lj_Thermocouple block in slx_LJM
% 
% Relevant references:
% - XXX
%
% TODO:
% - Verify that valid input port is used (must be positive AIN)


classdef slx_ljThermocouple

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
                disp('Trying to configure thermocouple input...')
                % Get port numbers
                ljPort = mw.get('ljPort');
                ljPortNum = str2num(extractBetween(ljPort,strlength(ljPort),strlength(ljPort)))
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);
                ljNegPortNum = ljPortNum + 1

                % Get temp unit and thermocouple type
                tempUnit = mw.get('tempUnit');
                tempUnit = strip(tempUnit,"'");
                switch tempUnit
                    case 'K'
                        tempUnitIdx = 0;
                    case 'C'
                        tempUnitIdx = 1;
                    case 'F'
                        tempUnitIdx = 2;
                    otherwise
                        disp('Invalid temperature type - defaulting to C')
                        tempUnitIdx = 1;
                end
                disp(['The desired temperature output unit is ', num2str(tempUnit),' and the index is ', num2str(tempUnitIdx)]);

                tcType = mw.get('thermocoupleType');
                tcType = strip(tcType,"'");
                switch tcType
                    case 'E'
                        tcTypeIdx = 20;
                    case 'J'
                        tcTypeIdx = 21;
                    case 'K'
                        tcTypeIdx = 22;
                    case 'R'
                        tcTypeIdx = 23;
                    case 'T'
                        tcTypeIdx = 24;
                    case 'S'
                        tcTypeIdx = 25;
                    case 'N'
                        tcTypeIdx = 27;
                    case 'B'
                        tcTypeIdx = 28;
                    case 'C'
                        tcTypeIdx = 30;
                    otherwise
                        disp('Invalid thermocouple type - defaulting to K')
                        tcTypeIdx = 22;
                end
                disp(['The thermocouple type is ', num2str(tcType),' and the index is ', num2str(tcTypeIdx)]);
                
                % Get handles
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                disp('Set handles!')

                % Configure thermocouple
                ljThermocoupleConfigure(ljHandle,ljPort,true,tcTypeIdx,ljNegPortNum,tempUnitIdx);
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end 
        end

        % Use the code browser on the left to add the callbacks.

    end
end