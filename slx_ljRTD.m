%SLX_LJRTD Mask initialization for lj_RTDRead block
%   
% slx_ljRTD.m
% Julian Bell & Gavin Williamson, JTEC Energy
% 2025-04-16
% 
% This class definition configures & initializes the mask for the
% lj_RTDRead block in slx_LJM

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
                tempUnitIdx = mw.get('tempUnit');
                switch tempUnitIdx
                    case 0
                        tempUnit = 'K';
                    case 1
                        tempUnit = 'C';
                    case 2
                        tempUnit = 'F';
                    otherwise
                        disp('Invalid temperature type - defaulting to C')
                        tempUnit = 'C';
                        tempUnitIdx = 1;
                end
                %}
                disp(['The desired temperature output unit is ', tempUnit,' and the index is ', num2str(tempUnitIdx)]);

                rtdTypeIdx = mw.get('rtdType');
                switch rtdTypeIdx
                    case 40
                        rtdType = 'PT100';
                    case 41'
                        rtdType = 'PT500';
                    case 42
                        rtdType = 'PT1000';
                    otherwise
                        disp('Invalid RTD type - defaulting to PT100');
                        rtdType = 'PT100';
                        rtdTypeIdx = 40;
                end
                disp(['The RTD type is ', rtdType,' and the index is ', num2str(rtdTypeIdx)]);
                

                refResistanceVal = mw.get('refResistance');
                switch refResistanceVal
                    case 1000
                        refResistance = '1K';
                    case 10000
                        refResistance = '10K';
                    case 100000
                        refResistance = '100K';
                    case 1000000
                        refResistance = '1M';
                    otherwise
                        disp('Invalid reference resistance - defaulting to 1K')
                        refResistance = '1K';
                        refResistanceVal = 1000;
                end
                disp(['The reference resistance type is ', num2str(refResistance),' and the value is ', num2str(refResistanceVal)]);
                
                % Get handles
                try
                    ljHandle = get_param(parentID,'ljHandle');
                catch ME
                    ljHandle = '-1';
                    disp('Could not get handle - setting dummy handle!');
                    disp(ME)
                end
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                disp('Set handles!')

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
                
                % Run RTD configuration script
                ljRTDConfigure(ljHandle,ljPort,false,rtdTypeIdx,tempUnitIdx,4,0,2.5,refResistanceVal);
            
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                %LabJack.LJM.CloseAll();
                
            end
        end


        function RTD_doc(callbackContext)
            web ('https://support.labjack.com/docs/14-1-3-rtd-t-series-datasheet')
        end

        function Ex_circ_4(callbackContext)
            web('https://support.labjack.com/docs/14-1-0-1-excitation-circuits-t-series-datasheet')
        end

        function res_tick(callbackContext)
            web('https://support.labjack.com/docs/ljtick-resistance-datasheet')            
        end
    end
end