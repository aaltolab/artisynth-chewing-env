function [] = initArtisynth(workingdir,artisynthhome)
% SUMMARY:
% This function accepts the matlab working directory and the location of
% artisynths root folder on your local machine and adds the dependencies to
% run the artisynth matlab plug in on your machine.

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
disp('Artisynth java classes added');

end