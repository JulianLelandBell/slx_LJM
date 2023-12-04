# slx_LJM

## About
slx_LJM is a simple blockset that enables interaction with LabJack T-series data acquisition interfaces from within Simulink. This blockset aims to be as user-friendly as possible, so that users can quickly set up Simulink models to read inputs and command outputs with the LabJack.

You will need to install both LabJack LJM and LabJack's MATLAB for LJM before use. slx_LJM is only available for Windows, because MATLAB for LJM (published by LabJack) is only developed for Windows systems.

This blockset is not intended for control purposes. Much of the functionality in this blockset is implemented in base MATLAB, so speed/determinism is not guaranteed, and this has not been tested with Simulink real-time products.

For more information, please visit:  
* [T-series DAQs](https://labjack.com/pages/support?doc=/datasheets/t-series-datasheet/t-series-datasheet-overview/)
* [LabJack LJM](https://labjack.com/pages/support?doc=%2Fsoftware-driver%2Finstaller-downloads%2Fljm-software-installers-t4-t7-digit%2F)
* [MATLAB for LJM](https://labjack.com/pages/support?doc=%2Fsoftware-driver%2Fexample-codewrappers%2Fmatlab-for-ljm-windows%2F) 

## Roadmap
Next items to be added to this package:
* Basic analog input
* Additional precongfigured special analog inputs: thermocouple, RTD, current sensor
* Frequency input (digital input)
* Additional preconfigured special digital outputs: PWM, heartbeat
* Helper functions: find all connected LabJacks & get IDs, <other>
* Examples: basic "Hello World", multiple LabJack
* Documentation: introduction to using the blockset, background on how LabJack handle data is passed between model layers, background on Simulink's weird penchant for typing data the wrong way when you bring it into a block...

## Citation

Please cite this codebase if you find it useful!   [![DOI](https://zenodo.org/badge/727206724.svg)](https://zenodo.org/doi/10.5281/zenodo.10256471)

If you find this codebase REALLY useful, you can [buy me a coffee](https://www.paypal.com/paypalme/julianlelandbell)!
