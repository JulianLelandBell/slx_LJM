%SLX_LJRTD Mask initialization for lj_RTDRead block
%   
% slx_ljRTD.m
% Julian Bell, JTEC Energy
% 2023-12-06
% 
% This class definition configures & initializes the mask for the
% lj_RTDRead block in slx_LJM
% 
% Relevant references:
% - XXX
%
% TODO:
% - XXX

classdef slx_ljRTD

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
                disp('Trying to configure RTD input...')

                % Get port and handle
                ljPort = mw.get('ljPort');
                ljPortNum = str2num(extractBetween(ljPort,strlength(ljPort),strlength(ljPort)));
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);

                % Get temp unit, RTD type, and reference resistance
                tempUnit = mw.get('tempUnit'); % For reasons I don't understand, this is formatted as {'C'}?
                tempUnit = strip(tempUnit,"{");
                tempUnit = strip(tempUnit,"}");
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

                rtdType = mw.get('rtdType');
                rtdType = strip(rtdType,"'");
                switch rtdType
                    case 'PT100'
                        rtdTypeIdx = 40;
                    case 'PT500'
                        rtdTypeIdx = 41;
                    case 'PT1000'
                        rtdTypeIdx = 42;
                    otherwise
                        disp('Invalid RTD type - defaulting to PT100')
                        rtdTypeIdx = 40;
                end
                disp(['The RTD type is ', num2str(rtdType),' and the index is ', num2str(rtdTypeIdx)]);
                

                refResistance = mw.get('refResistance');
                refResistance = strip(refResistance,"'");
                switch refResistance
                    case '1K'
                        refResistanceVal = 1000;
                    case '10K'
                        refResistanceVal = 10000;
                    case '100K'
                        refResistanceVal = 100000;
                    case '1M'
                        refResistanceVal = 1000000;
                    otherwise
                        disp('Invalid reference resistance - defaulting to 1K')
                        refResistanceVal = 1000;
                end
                disp(['The reference resistance type is ', num2str(refResistance),' and the value is ', num2str(refResistanceVal)]);
                
                % Get handles
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                disp('Set handles!')
                
                % Run RTD configuration script
                ljRTDConfigure(ljHandle,ljPort,false,rtdTypeIdx,tempUnitIdx,4,0,2.5,refResistanceVal);
            
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
                
            end
        end

    end
end