%Code by: Kieran Arstrong
%-------------------------------SUMMARY------------------------------------
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

%--------------------CLEAR WORKSPACE AND SHUFFLE RNDGEN--------------------
clc;
clear all;
close all;
rng('shuffle');

%-------------------------MUSCLE DEFINITIONS------------------------------
muscles = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24;...
           'lad','lip','lsp','lam','lgh','lat','lmt','lpm','lpt','ldm',...
           'lsm','lmp','rad','rip','rsp','ram','rgh','rat','rmt','rpm',...
           'rpt','rdm','rsm','rmp'};
       
%-------------------------------VARIABLES----------------------------------
% Simulation variables
simTime = 0.5; %s
simTimeStep =  0.0001; %s
fs = 1/simTimeStep; % Hz 200 from tracker and 1000 from emg
% The key for al musles is in your workdingdir/Output folder
% start at 2 because excitation matrix from artisynth's first column is the
% time step
muscles = muscles(:,1:23); 
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
           


