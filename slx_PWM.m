%SLX_PWM Mask initialization for lj_PWM block
%   
% slx_PWM.m
% Julian Bell & Gavin Williamson, JTEC Energy
% 2025-04-16
% 
% This class definition configures & initializes the mask for the
% lj_PWM block in slx_LJM

classdef slx_PWM

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
                disp('Trying to configure DIO Write')
                ljPort = mw.get('ljPort');
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                defaultState = mw.get('defaultState');
                ljClock = mw.get("ljClock");
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end
        end

        % Use the code browser on the left to add the callbacks.


        function pwm_data(callbackContext)
          web("https://support.labjack.com/docs/13-2-2-pwm-out-t-series-datasheet")  
        end

        function pwm_config(callbackContext)
           web("https://support.labjack.com/docs/configuring-a-pwm-output") 
        end

        function clock_web(callbackContext)
            web("https://support.labjack.com/docs/13-2-1-ef-clock-source-t-series-datasheet")
        end
    end
end