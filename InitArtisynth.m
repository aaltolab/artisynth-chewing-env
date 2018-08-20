% SUMMARY:
% MUST RUN BEFORE Pertubation.m on startup
% This script initialized artisynth and set the correct working directory
% ass artisynths root folder on your local machine and adds the dependencies to
% run the artisynth matlab plug in on your machine.

workingdir = 'C:\Users\kieran\develop\matlab\chewing-pertubation';
artisynthhome = 'C:\Users\kieran\develop\artisynth';
addpath(strcat(workingdir,'\Plot Functions'));
addpath(strcat(workingdir,'\Helper Functions'));
% 
% %----------------------------SETUP ARTISYNTH-------------------------------
% initArtisynth(workingdir,artisynthhome);

% MATLAB workspace settings
cd(workingdir);

% add matlab libararies to search path
addpath(strcat(artisynthhome,'\artisynth_core\matlab'));

%--------------------------ADD JAVA CLASSPATHS-----------------------------
% You must set this on your machine
setArtisynthClasspath (getenv ('ARTISYNTH_HOME')) 
javaaddpath(strcat(artisynthhome,'\artisynth_models\classes'));
javaaddpath(strcat(artisynthhome,'\artisynth_projects\classes'));
javaaddpath(strcat(artisynthhome,'\artisynth_core\matlab\javaclasspath.txt'));
disp('Artisynth java classes added. You can now run Pertubation.m');