%SLX_LJAINREAD Mask initialization for lj_AINRead block
%   
% slx_ljAINRead.m
% Julian Bell & Gavin Williamson, JTEC Energy
% 2025-03-28
% 
% This class definition configures & initializes the mask for the
% lj_AINRead block in slx_LJM

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
                
                range_val = mw.get('ljRange');
                %Configure AIN port
                if getDeviceType(ljHandle) == int32(4) %T4 Configuration
                    numFrames=3;
                    aNames = NET.createArray('System.String', numFrames);
                    aNames(1) = [char(ljPort),'_RANGE'];
                    aNames(2) = [char(ljPort),'_RESOLUTION_INDEX'];
                    aNames(3) = [char(ljPort),'_SETTLING_US'];
                    aValues = NET.createArray('System.Double',numFrames);
                    aValues(1) = 0;
                    aValues(2) = 0;
                    aValues(3) = 0;
                elseif getDeviceType(ljHandle) == int32(7) %T7 Configuration
                    numFrames=4;
                    aNames = NET.createArray('System.String', numFrames);
                    aNames(1) = [char(ljPort),'_NEGATIVE_CH'];
                    aNames(2) = [char(ljPort),'_RANGE'];
                    aNames(3) = [char(ljPort),'_RESOLUTION_INDEX'];
                    aNames(4) = [char(ljPort),'_SETTLING_US'];
                    aValues = NET.createArray('System.Double',numFrames);
                    if mw.get('Diff_Rd_SW')==1
                        diff_ch = char(mw.get('Diff_Rd'));
                        diff_ch = strip(diff_ch,"'");
                        aValues(1) = str2double(diff_ch(4:end));
                    else
                        aValues(1) = 199;
                    end
                    aValues(2) = range_val;
                    aValues(3) = 0;
                    aValues(4) = 0;
                end
                LabJack.LJM.eWriteNames(ljHandle,numFrames,aNames,aValues,0);
                    
                    

            catch ljConnectErr
                showErrorMessage(ljConnectErr);
                disp(ljConnectErr)
                LabJack.LJM.CloseAll();
           end 

           %diable differential channel input if differential reading is
           %disabled
           if mw.get('Diff_Rd_SW')==0
               diff_rd = Simulink.Mask.get(gcb);
               param_diff_rd = diff_rd.getParameter('Diff_Rd');
               param_diff_rd.Enabled ='off';
           else
               diff_rd = Simulink.Mask.get(gcb);
               param_diff_rd = diff_rd.getParameter('Diff_Rd');
               param_diff_rd.Enabled ='on';
           end

 
        end

        % Use the code browser on the left to add the callbacks.


        function Control3(callbackContext)
        web('https://support.labjack.com/docs/14-0-analog-inputs-t-series-datasheet#id-14.0AnalogInputs[T-SeriesDatasheet]-Single-endedorDifferential-T7Only') 
        end
    end
end