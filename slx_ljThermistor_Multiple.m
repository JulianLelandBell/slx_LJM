%SLX_LJTHERMISTOR Mask initialization for lj_ThermistorRead block
%   
% slx_ljThermistor.m
% Julian Bell, JTEC Energy
% 2024-01-04
% 
% This class definition configures & initializes the mask for the
% lj_ThermistorRead block in slx_LJM
% 
% Relevant references:
% - XXX
%
% TODO:
% - Add control of other thermistor configuration parameters to mask


classdef slx_ljThermistor_Multiple

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
                disp('Trying to configure thermistor input...')
                ljPort = mw.get('ljPort');
                ljPort = strip(ljPort,"'");
                disp(['I think the port is...', num2str(ljPort)]);
                ljHandle = get_param(parentID,'ljHandle');
                ljHandle = str2num(ljHandle);
                disp(['I think the handle is...', num2str(ljHandle)]);
                set_param(bh,'ljHandle',num2str(ljHandle));
                mw.set('ljHandle',ljHandle);
                ljThermistorConfigure(ljHandle,ljPort,false,50,1,4,0,2.5,10000,1,1.032e-3,2.387e-4,0,1.580e-7);
            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
            end 
        end

        % Use the code browser on the left to add the callbacks.

    end
end