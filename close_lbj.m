function close_lbj(block)
%close_lbj: Level-2 S function which closes the connection to a LabJack when
% a Simulink simulation is stopped based on the handle that is passed into
% its input. It will also diable all the DIO ports on the LabJack to
% prevent continual processes from happening and enable them to be
% configured in any way thhe next time the simulation is run.
%
% Inputs:
%   1: Handle of Labjack to be closed [int32]
%
% Outputs:
%   1: Handle of Labjack to be closed [int32]
%
% Author: Gavin Williamson
% Company: JTEC Energy
% Email: gwilliamson@jtecenergy.com
% Date: 2025-04-16

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C MEX counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions        = 1;
block.InputPort(1).DatatypeID  = 6;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

% Override output port properties
block.OutputPort(1).Dimensions       = 1;
block.OutputPort(1).DatatypeID  = 6; % double
block.OutputPort(1).Complexity  = 'Real';

% Register parameters
block.NumDialogPrms     = 0;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate);

%end setup

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C MEX counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
block.NumDworks = 1;
  
  block.Dwork(1).Name            = 'x1';
  block.Dwork(1).Dimensions      = 1;
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;


%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)

%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C MEX counterpart: mdlStart
%%
function Start(block)

block.Dwork(1).Data = 0;

%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C MEX counterpart: mdlOutputs
%%
function Outputs(block)

block.OutputPort(1).Data = block.InputPort(1).Data;

%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlUpdate
%%
function Update(block)


%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlDerivatives
%%
function Derivatives(block)

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : No
%%   C MEX counterpart: mdlTerminate
%%
function Terminate(block)
%disable DIO ports
for i = 0:22
    try
    cmmd = "DIO"+ string(i) + "_EF_ENABLE";
    LabJack.LJM.eWriteName(block.InputPort(1).Data,cmmd,0);
    end
end
%reset clock configuration
try
    LabJack.LJM.eWriteName(block.InputPort(1).Data,"DIO_EF_CLOCK1_ENABLE",0);
    LabJack.LJM.eWriteName(block.InputPort(1).Data,"DIO_EF_CLOCK2_ENABLE",0);
    LabJack.LJM.eWriteName(block.InputPort(1).Data,"DIO_EF_CLOCK0_ENABLE",1);
    LabJack.LJM.eWriteName(block.InputPort(1).Data,"DIO_EF_CLOCK0_ROLL_VALUE",0);
    LabJack.LJM.eWriteName(block.InputPort(1).Data,"DIO_EF_CLOCK1_ROLL_VALUE",0);
    LabJack.LJM.eWriteName(block.InputPort(1).Data,"DIO_EF_CLOCK2_ROLL_VALUE",0);
catch
    disp("Unable to set LabJack Clocks to default settings")
end
try
    LabJack.LJM.Close(block.InputPort(1).Data);
    disp(['Labjack Connection with handle ', int2str(block.InputPort(1).Data),  ' closed succesfully'])
catch
    warning(['Labjack Connection with handle ', int2str(block.InputPort(1).Data), ' did not close'])
end

%end Terminate

