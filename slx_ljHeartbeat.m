%SLX_LJHEARTBEAT Mask initialization for lj_Heartbeat block
%   
% slx_ljHeartbeat.m
% Julian Bell, JTEC Energy
% 2023-12-06
% 
% This class definition configures & initializes the mask for the
% lj_Heartbeat block in slx_LJM
% 
% Relevant references:
% - XXX
%
% TODO:
% - Figure out inconsistency in timing bug. When running at a period
% similar to the model sample period, this block produces a duty cycle that
% isn't 50%. This is almost certainly a discretization issue - but still
% need to figure it out...

classdef slx_ljHeartbeat

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
                disp('Trying to configure heartbeat output')
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