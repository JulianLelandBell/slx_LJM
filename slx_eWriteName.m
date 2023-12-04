function [] = slx_eWriteName(ljHandle, portName, value)
%SLX_EWRITENAME Function to be called from within Simulink MATLAB Code block
%to avoid requirement to declare LabJack functions as extrinsic. See
%https://www.mathworks.com/matlabcentral/answers/122471-attempt-to-extract-field-value-from-mxarray
%for background

LabJack.LJM.eWriteName(ljHandle,portName,value);
end