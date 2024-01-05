%SLX_LJDACTICK Mask initialization for lj_DACTickWrite block
%   
% slx_ljDACTick.m
% Julian Bell, JTEC Energy
% 2024-01-03
% 
% This class definition configures & initializes the mask for the
% lj_DACTick block in slx_LJM. This block is intended for use with the
% LabJack LJTick-DAC external device.
% 
% Relevant references:
% - XXX
%
% TODO:
% - XXX

classdef slx_ljDACTick
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
                disp('Trying to configure DAC through LJTick-DAC...')
                ljPort = mw.get('ljPort');
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                LabJack.LJM.eWriteName(ljHandle,ljPort,0); % Initially start output low
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end
        end

        % Use the code browser on the left to add the callbacks.

    end
end