classdef slx_ljThermistor
    
    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle 
        %  - MaskObject 
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            try
                disp('Trying to configure thermistor input')
                maskWorkspace = maskInitContext.MaskWorkspace;
                ljPort = maskWorkspace.get('ljPort');
                ljHandle = evalin('base','ljHandle');
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