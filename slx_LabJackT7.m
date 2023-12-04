classdef slx_LabJackT7

    properties
        ljHandle double
    end
    
    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle 
        %  - MaskObject 
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            ljmAsm = NET.addAssembly('LabJack.LJM');
                
                % Creating an object to nested class LabJack.LJM.CONSTANTS
                t = ljmAsm.AssemblyHandle.GetType('LabJack.LJM+CONSTANTS');
                LJM_CONSTANTS = System.Activator.CreateInstance(t);
                ljHandle = 0;
    
                % Connect to devices & configure inputs
                try
                    [ljmError, ljHandle] = LabJack.LJM.OpenS('T7', 'USB', 'ANY', ljHandle); % Example - need to change this to T4 for different device
                    showDeviceInfo(ljHandle); 
                    disp(['Handle = ',num2str(ljHandle)]);
                    assignin('base','ljHandle',ljHandle)
                catch ljConnectErr
                    showErrorMessage(ljConnectErr);
                    disp(ljConnectErr)
                    LabJack.LJM.CloseAll();
                end    
        end

        % Use the code browser on the left to add the callbacks.

    end
end