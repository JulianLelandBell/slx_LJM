%SLX_FREQUENCYREAD Mask initialization for lj_FrequencyRead block
%   
% slx_FrequencyRead.m
% Julian Bell, JTEC Energy
% 2024-02-20
% 
% This class definition configures & initializes the mask for the
% lj_FrequencyRead block in slx_LJM
% 
% Relevant references:
% - XXX
%
% TODO:
% - XXX

classdef slx_FrequencyRead

    properties
        ljHandle double
        ljID string
        ljPort string
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
                disp('Trying to configure frequency Read');
                ljPort = mw.get('ljPort');
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                ljFreqReadConfigure(ljHandle, ljPort, false, 3);

            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end
            
        end

        % Use the code browser on the left to add the callbacks.

    end
end