# chewing-pertubation

Pre-requisites:
1. Clone ArtiSynth (https://github.com/artisynth/artisynth_core.git) and its dependent project (https://github.com/artisynth/artisynth_models.git). There is a 3rd project (artisynth_projects) that can only be accessed by getting user permission from the developers. You can find their contact information here (https://www.artisynth.org/Main/HomePage).

2. Follow the install guide for OSX and Windows to setup your environment (https://www.artisynth.org/Documentation/InstallGuide).

3. ArtiSynth must also be configured to work in MATLAB. Currently, ArtiSynth is recommended to be compiled with Java 8, therefore, to run ArtiSynth in MATLAB you must install MATLAB R2017b. Instructions for setup can be found here: https://www.artisynth.org/Documentation/MatlabAndJython

Project Overview:

There are two main scripts in the project.

1. Perturbation.m runs an inverse chewing simulation in ArtiSynth. A trajectory is programmed in ArtiSynth (https://www.artisynth.org/Main/HomePage), muscle excitations are calculated and then collected within this script. The simulation time, time step, sampling frequency, perturbation model parameters and the number of simulations can be set.

2. SugerySim.m  generates jaw depressor and elevator excitations plots and lower mid incisor trajectories for a specific surgery case. The muscles to be removed for surgery are selected from the muscles structure and its value set to the musclesToDeactivate variable. The simulation duration, time step and ArtiSynth model parameters can be adjusted here.

The suplementary code is located in the Plot Functions and Helper Function directories.

Plotting functions are defined in your workingdir/Plot Functions. Helper functions are defined in your workingdir/Helper Functions These functions are called within the main script. Saved simulations is an empty folder that you should fill with the contents of the Output folder which collects all of the simulation data and statistical data.
