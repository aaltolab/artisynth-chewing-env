%Code by: Kieran Arstrong
%-------------------------------READ ME------------------------------------
% This script runs a inverse chewing simulation in artisynth. A trajectory
% is programmed in artisynth, muscle excitations are calculated and then
% collected within this script. The simulation time, time step, sampling
% frequency, and pertubation model paramters, and number of simulations can
% be set.
%
% Plotting functions are defined in your workingdir/Plot Functions
% Helper functions are defined in your workingdir/Helper Functions
% These functions are called within the main script.
% Saved simulations is an empty folder that you should fill with the
% contents of the Output folder which collects all of the simulation data
% and statistical data.

%----------------------------SETUP ARTISYNTH-------------------------------
workingdir = 'C:\Users\kieran\develop\matlab\chewing-pertubation';
artisynthhome = 'C:\Users\kieran\develop\artisynth';
initArtisynth(workingdir,artisynthhome);

%-------------------------------INCLUDES-----------------------------------
addpath(strcat(workingdir,'\Plot Functions'));
addpath(strcat(workingdir,'\Helper Functions'));

%----------- --------CLEAR WORKSPACE AND SHUFFLE RNDGEN--------------------
clc;
clear;
close all;
rng('shuffle');

%-------------------------------VARIABLES----------------------------------
% Simulation variables
simTime = 0.5; %s
simTimeStep =  0.0001; %s
fs = 1/simTimeStep; % Hz 200 from tracker and 1000 from emg
% The key for al musles is in your workdingdir/Output folder
% start at 2 because excitation matrix from artisynth's first column is the
% time step
muscles = [2:25]; 
numSim = 10;
t0PertWindow = 0; %s
tfPertWindow = 0.05; %s
pertModelType = ["additive", "multiplicative"];
pertShapeType = ["unitstep", "ramp"];

%Script variables
invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';

%-------------------------------INVERSES-----------------------------------
%Load, run, and extract Inverse simulation data
% Inverse Simulation
[invExcitations,invICP,invICV] = ...
    inverseSim(simTime,invModelName);

%------------------------SMOOTH EXCITATION SIGNAL--------------------------
smoothExcitations = zeros(size(invExcitations));
smoothExcitations(:,1) = invExcitations(:,1);

for i = 2:size(invExcitations,2)
     smoothExcitations(:,i) = sgolayfilt(invExcitations(:,i), 5, 211);
end

%------------------------------PERTUBATION---------------------------------
% Create local pertubation window and shape function
openWindow = createLocalPertWindow(invExcitations,t0PertWindow,tfPertWindow, fs);

% Create local pertubation shape function
openPertShape = createPertShape(pertShapeType(1),openWindow);

% Get excitation matrix and pick small random pertubations
% [smallPertExcitations] = ...
%     performExcitationAnalysis(openWindow,smoothExcitations,...
%                               openPertShape,muscles,pertModelType(1));

%------------------------------FORWARDSIM----------------------------------
%Load calculated excitations, run forward simulation, and collect position,
%velocity, and force

% Forward Simulation
[simulationParamTable, statvarTable] = ...
     forwardSim(  smoothExcitations...
                 ,openWindow...
                 ,openPertShape...
                 ,muscles...
                 ,pertModelType(1)...
                 ,forwardModelName...
                 ,invModelName...
                 ,pertShapeType(1)...
                 ,invICP...
                 ,numSim...
                );
            
%-------------------------SAVE DATA TO FILE--------------------------------
writetable(simulationParamTable,'Output/simulationParamTable.txt','Delimiter',',')  
writetable(statvarTable,'Output/statvarTable.txt','Delimiter',',')  


