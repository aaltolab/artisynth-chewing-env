% SUMMARY:
% MUST RUN BEFORE you can use the workspace
% This script initialized artisynth and set the correct working directory
% ass artisynths root folder on your local machine and adds the dependencies to
% run the artisynth matlab plug in on your machine.

workingdir = 'C:\develop\matlab\chewing-pertubation';
artisynthhome = 'C:\develop\artisynth';
addpath(strcat(workingdir,'\Plot Functions'));
addpath(strcat(workingdir,'\Helper Functions'));
addpath(strcat(workingdir,'\Muscle Info'));
% 
% %----------------------------SETUP ARTISYNTH-------------------------------
% initArtisynth(workingdir,artisynthhome);

% MATLAB workspace settings
cd(workingdir);

% add matlab libararies to search path
addpath(strcat(artisynthhome,'\artisynth_core\matlab'));

%--------------------------ADD JAVA CLASSPATHS-----------------------------
% You must set this on your machine
setArtisynthClasspath (getenv ('ARTISYNTH_HOME'));
javaaddpath(strcat(artisynthhome,'\artisynth_models\classes'));
javaaddpath(strcat(artisynthhome,'\artisynth_projects\classes'));
javaaddpath(strcat(artisynthhome,'\artisynth_core\matlab\javaclasspath.txt'));
disp('Artisynth java classes added. Enviroment Configured.');