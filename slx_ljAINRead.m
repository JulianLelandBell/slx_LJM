%SLX_LJAINREAD Mask initialization for lj_AINRead block
%   
% slx_ljAINRead.m
% Julian Bell, JTEC Energy
% 2023-12-06
% 
% This class definition configures & initializes the mask for the
% lj_AINRead block in slx_LJM
% 
% Relevant references:
% - XXX
%
% TODO:
% - Configure as single-ended or differential (make sure that this only
% works on the T7)
% - Configure voltage range
% - Configure resolution index
% - Set stream vs. single-read mode (maybe not applicable?)

classdef slx_ljAINRead

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
                disp('Trying to configure analog input...')
                ljPort = mw.get('ljPort');
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end 
        end

        % Use the code browser on the left to add the callbacks.

    end
end