# chewing-env

This is a quick setup. The full guide for installing artisynth can be found [here](https://www.artisynth.org/manuals/index.jsp?nav=%2F0).

## System Requirements:
1. 64 but Windows, MacOS, or Linux.
2. Java Development Kit (JDK) 8 installed [Java JDK 8](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html).
3. To verify Java is installed run `javac -version` returns the version you downloaded.

## Code Management Requirements:
1. Install git on your machine and create an account [GitHub Setup](https://help.github.com/en/github/getting-started-with-github/set-up-git).
2. Install subversion on your machine [Subversion Setup](https://sourceforge.net/projects/win32svn/). 

## Setting Up Enviroemnt Variables:

### MacOS:
All enviroment variables are setup in your <HOMEDIR>/.bash_profile.
  
```
# JAVA
export JAVA_HOME=‘/usr/libexec/java_home -v 1.8.0_221'

#MATLAB
export PATH=$PATH:/Applications/MATLAB_R2017b.app/bin/

# set ARTISYNTH_HOME to the appropriate location ...
export HOME=/Users/<USERNAME>
export ARTISYNTH_HOME=$HOME/<PATH_TO_ARTISYNTH_CORE>
export ARTISYNTH_PATH=.":"$HOME":"$ARTISYNTH_HOME
export CLASSPATH="$ARTISYNTH_HOME/classes:$ARTISYNTH_HOME/lib/*:$CLASSPATH:$HOME/<PATH_TO_ARTISYNTH_MODELS>/classes:$HOME/PATH_TO_ARTISYNTH_PROJECTS/classes"
export PATH=$ARTISYNTH_HOME/bin:$ARTISYNTH_HOME/lib/MacOS64":"$PATH
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ARTISYNTH_HOME/lib/MacOS64

# Set to the number of cores on your machine:
export OMP_NUM_THREADS=2
```

### Windows 10:
1. Open the Start and search **"env"** and choose **"Edit the system environment variables"**.
2. Click on **Environment Variables**.
3. Choose one of the following options:
  * Click **New** to add a new environment variable name and value.
  * Click an existing variable, and **Edit** to change its name or value.
  * Click an existing variable, and **Delete** to remove it.
4. To reference, other environment variables use the % sign. For example %HOME%.

```
# Typical environment variables

ARTISYNTH_HOME c:\users\joe\artisynth_core
ARTISYNTH_PATH .;c:\users\joe;%ARTISYNTH_HOME%
CLASSPATH %ARTISYNTH_HOME%\classes;%ARTISYNTH_HOME%\lib\*
PATH %ARTISYNTH_HOME%\bin;%PATH%
OMP_NUM_THREADS 2
```

## Installing Artisnynth:
1. Clone [artisynth_core](https://github.com/artisynth/artisynth_core.git) and its class extension project [artisynth_models](https://github.com/artisynth/artisynth_models.git). There is a 3rd project (artisynth_projects) that can only be accessed by getting user permission from the developers. You can find their contact information here [Artisynth home page](https://www.artisynth.org/Main/HomePage).

2. Download libraries
  * Because the jar files are large they need to be downloaded separately. Located in <ARTISYNTH_HOME>\bin there is a updateArtisynthLibs command that will install the libs.
  
## Setup VSCode:
VSCode is a cross-platform lightweight code editor and manager. We suggest that you set up with vscode as the developers that support this project have the most experience with it. You can download [here](https://www.artisynth.org/manuals/index.jsp?nav=%2F0).

1. Install the **Java Extension Pack** from vscode.
2. Create a folder called artisynth on your system and make sure all of the projects are underneath it.

```
-artisynth
--artisynth_core
--artisynth_models
--artisynth_projects
```

3. Setup your launch.json configuration to be able to debug in artisynth.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "java",
            "name": "Debug",
            "request": "launch",
            "cwd": "${workspaceFolder}",
            "mainClass": "artisynth.core.driver.Launcher",
            "console": "internalConsole",
            "stopOnEntry": false,
            "projectName": "artisynth_core",
            "shortenCommandLine": "auto"
        }
    ]
}  
```

4. Build artisynth from the command line:
```
~ cd /artisynth_core
~ make

~ cd /artisynth_models
~ make

~ cd /artisynth_projects
~ make
```

5. Run from debugger click **the green play button** in vscode.

## Setup With MATLAB:

1. ArtiSynth must also be configured to work in MATLAB. Currently, ArtiSynth is recommended to be compiled with Java 8, therefore, to run ArtiSynth in MATLAB you must install MATLAB R2017b. Detailed instructions for setup can be found [here] (https://www.artisynth.org/Documentation/MatlabAndJython).

2. Clone [this](https://github.com/aaltolab/artisynth-chewing-env) project to set up the environment. 

# Environment Overview:

There are two main parts of the project. The first is surgery simulation and the second is a **WORK IN PROGRESS** perturbation section.

## General:

1. Edit your startup.m to set change the working dir to the location you cloned this repository: `cd '/Users/PATH_TO/artisynth-chewing-env'`

2. IniArtisynth.m must be run before launching a script. This script initializes artisynth and adds the correct dependencies. You will need to change the workingdir and artisynthhome variables.

3. clean.m will reboot matlab if scripts will not run.

## Surgery and Chewing Simulation Pipeline:

1. SugerySim.m  generates jaw depressor and elevator excitations plots and lower mid incisor trajectories for a specific surgery case. The muscles to be removed for surgery are selected from the muscles structure and its value set to the musclesToDeactivate variable. The simulation duration, time step and ArtiSynth model parameters can be adjusted here.

2. The supplementary code is located in the Plot Functions and Helper Function directories.

3. Plotting functions are defined in your workingdir/Plot Functions. Helper functions are defined in your workingdir/Helper Functions These functions are called within the main script. Saved simulations is an empty folder that you should fill with the contents of the Output folder which collects all of the simulation data and statistical data.

4. TuneInverseSim.m launches the inverse simulation and opens tuning panels to adjust for smooth excitations or accurate jaw tracking.

5. RepeatabilityStudy.m is the ongoing work to investigate the repeatability of building artisynth jaw models by hand.

## Perturbation Script:

1. Perturbation.m runs an inverse chewing simulation in ArtiSynth. A trajectory is programmed in ArtiSynth, muscle excitations are calculated and then collected within this script. The simulation time, time step, sampling frequency, perturbation model parameters and the number of simulations can be set.
