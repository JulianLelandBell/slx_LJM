# slx_LJM

## About
slx_LJM is a simple toobox that enables interaction with LabJack T-series data acquisition interfaces from within Simulink. This toolbox aims to be as user-friendly as possible, so that users can quickly set up Simulink models to read inputs and command outputs with the LabJack. The toolbox is quite powerful, however, and can communicate with multiple LabJacks simultaneously, is compatible with both T7 and T4 devices, and provides access to Simulink & MATLAB's extensive library of control & processing functionality.

This toolbox is not intended for control purposes. Much of the functionality in this toolbox is implemented in base MATLAB, so speed/determinism is not guaranteed, and this has not been tested with Simulink real-time products.

slx_LJM is developed by Julian Bell and Gavin Williamson at [JTEC Energy](https://jtecenergy.com/). This blockset is licensed under the BSD 4-Clause license.

## Toolbox Installation
This repository contains a compiled MATLAB Toolbox here: [slx_LJM.mltbx](https://github.com/JulianLelandBell/slx_LJM/blob/76c818dbff9e8ad6e59ea5cc0bc723eb11026613/slx_LJM.mltbx). 

You will need to install both LabJack LJM and LabJack's MATLAB for LJM before use. slx_LJM is only available for Windows, because MATLAB for LJM (published by LabJack) is only developed for Windows systems.

For more information, please visit:  
* [T-series DAQs](https://labjack.com/pages/support?doc=/datasheets/t-series-datasheet/t-series-datasheet-overview/)
* [LabJack LJM](https://labjack.com/pages/support?doc=%2Fsoftware-driver%2Finstaller-downloads%2Fljm-software-installers-t4-t7-digit%2F)
* [MATLAB for LJM](https://labjack.com/pages/support?doc=%2Fsoftware-driver%2Fexample-codewrappers%2Fmatlab-for-ljm-windows%2F) 

## How it Works:
The core concept of the toolbox is that you start by adding a block (technically a
masked subsystem) that represents your LabJack, which takes care of connection to
your LabJack, and configuration of that LabJack for operation. Then for every function
you want your LabJack to perform, you add specialized blocks inside that LabJack
“block” with ports connecting out to the rest of your model. Simulink can be set up to run
at a certain pace, which allows you to control the rate of your data acquisition. Details
on how to set this up, along with an example model, can be found in the library’s help
documentation.

Example: Let's say you want to turn on an LED when an analog voltage exceeds a
certain level. You would first add a LabJack T7 masked subsystem to your model. Inside
of that subsystem, you would add an Analog Input block and a Digital Output block and
configure them to read/write to the correct ports. You would then connect the inputs and
outputs of these blocks to appropriate logic elsewhere in your Simulink model to
perform the level comparison.

Features:
* Talk to T4 and T7 devices. (Has not been tested with a T8 but several of the features would probably still work)
* Control multiple LabJacks simultaneously. 6 simultaneously connected devices have been consistently operated without issues
* Analog inputs:
  * Basic analog in, including differential measurement
  * Current measurement through LJTickCurrentShunt
  * RTD read
  * Thermistor read
  * Thermocouple read
* Analog outputs:
  * DACWrite through DAC0 and DAC1 ports
  * Digital inputs:
  * Digital input read
  * Frequency Read
* Digital outputs:
  * Digital output write
  * DAC write through LJTickDAC
  * PWM write
  * Heartbeat. A custom digital output function that turns output on and off manually from Simulink, enabling you to detect if Simulink has crashed
* An example model showing how to use the slx_LJM toolbox to collect data
  * Model includes automatic dataset generation scripts that will save the collected data to a .csv and .mat file automatically when a simulation is stopped.

## Repository Notes
This repository contains the MATLAB Project file where slx_LJM was originally developed. It is, to put it extremely generously, a giant mess. (This is Julian's fault). However, you can pull the repository and open up the MATLAB Project if you're interested in developing the toolbox further - it's not pretty, but it is functional.

## Roadmap
As of July 2025, there is no plan to add additional features to slx_LJM - it does what we need for our purposes at JTEC. However, community contributions are welcome and solicited! Please let us know if you make substantial improvements or expansions - we'd love to see them.

## Citation

Please cite this codebase if you find it useful!   [![DOI](https://zenodo.org/badge/727206724.svg)](https://zenodo.org/doi/10.5281/zenodo.10256471)

If you find this codebase REALLY useful, you can [buy Julian](https://www.paypal.com/paypalme/julianlelandbell) or [buy Gavin](https://paypal.me/GavinWilliamson255) a coffee!
