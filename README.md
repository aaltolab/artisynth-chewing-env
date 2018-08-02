# chewing-pertubation

Pre-requisites:
1. Clone Artisynth (https://github.com/artisynth/artisynth_core.git) and its dependencies.
2. Follow the install guide for OSX and Windows to setup your enviroment (https://www.artisynth.org/Documentation/InstallGuide).
3. Artisynth must also be configured to work in MATLAB. Currently, Artisynth is recommended to be compiled with Java 8 therefore to run Artinsyht in MATLAB you must install MATLAB R2017b. Instructions for setup can be found here: https://www.artisynth.org/Documentation/MatlabAndJython

Script Overview:
This script runs a inverse chewing simulation in artisynth. A trajectory is programmed in Artisynth (https://www.artisynth.org/Main/HomePage), muscle excitations are calculated and then collected within this script. The simulation time, time step, sampling frequency, and pertubation model paramters, and the number of simulations can be set.

Plotting functions are defined in your workingdir/Plot Functions. Helper functions are defined in your workingdir/Helper Functions These functions are called within the main script. Saved simulations is an empty folder that you should fill with the contents of the Output folder which collects all of the simulation data and statistical data.
