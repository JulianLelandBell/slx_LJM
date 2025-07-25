%SLX_LABJACKTSERIES Mask initialization for LabJack T-Series block
%   
% slx_LabJackTSeries.m
% Julian Bell, JTEC Energy
% 2025-04-16
% 
% This class definition configures & initializes the mask for the
% LabJack T-Series block in slx_LJM
classdef slx_LabJackTSeries

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
            ljmAsm = NET.addAssembly('LabJack.LJM');

            % Create mask contexts
            bh = maskInitContext.BlockHandle;
            mo = maskInitContext.MaskObject;
            mw = maskInitContext.MaskWorkspace;
            
            % Creating an object to nested class LabJack.LJM.CONSTANTS
            t = ljmAsm.AssemblyHandle.GetType('LabJack.LJM+CONSTANTS');
            LJM_CONSTANTS = System.Activator.CreateInstance(t);
            ljHandle = 0;
            ljID = get_param(bh,'ljIdentifier');
            ljID = strip(ljID,"'"); % Need to strip off leading and trailing single quotes
            assignin('base','id',ljID);

            % Connect to devices & configure inputs
            try
                switch mw.get('cnx_mth')
                    case 1
                        [ljmError, ljHandle] = LabJack.LJM.OpenS('ANY', 'USB', ljID, ljHandle);
                    case 2
                        [ljmError, ljHandle] = LabJack.LJM.OpenS('ANY', 'Ethernet', ljID, ljHandle);
                    otherwise
                        disp('Invalid connection method. Default set to USB')
                        [ljmError, ljHandle] = LabJack.LJM.OpenS('ANY', 'USB', ljID, ljHandle);
                end
                showDeviceInfo(ljHandle); 
                disp(['Handle = ',num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                disp(['Set ljHandle for block to ',num2str(ljHandle)]);
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end
        end

        % Use the code browser on the left to add the callbacks.


        function Control3(callbackContext)
            web("https://support.labjack.com/docs/opens-ljm-user-s-guide")
        end
    end
end