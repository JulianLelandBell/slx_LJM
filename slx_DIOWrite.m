%SLX_DIOWRITE Mask initialization for lj_DIOWrite block
%   
% slx_DIOWrite.m
% Julian Bell & Gavin Williamson, JTEC Energy
% 2025-04-16
% 
% This class definition configures & initializes the mask for the
% lj_DIOWrite block in slx_LJM

classdef slx_DIOWrite

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
                LabJack.LJM.eWriteName(ljHandle,ljPort,defaultState);
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end
        end

        % Use the code browser on the left to add the callbacks.


        function Control2(callbackContext)
            web('https://support.labjack.com/docs/13-0-digital-i-o-t-series-datasheet')
        end
    end
end