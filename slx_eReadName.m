function [ljmError, output] = slx_eReadName(ljHandle, portName)
%SLX_EREADNAME Function to be called from within Simulink MATLAB Code block
%to avoid requirement to declare LabJack functions as extrinsic. See
%https://www.mathworks.com/matlabcentral/answers/122471-attempt-to-extract-field-value-from-mxarray
%for background

[ljmError, output] = LabJack.LJM.eReadName(ljHandle,portName,0);
end