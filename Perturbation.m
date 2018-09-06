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
muscles = createmusclestruct('musclekey.txt'); 

% Muscle Groups to be deactivated
leftsidecorprocess = muscles([3 5]);
rightsidecorprocess = muscles([4 6]);
bothcorprocess = muscles([3 4 5 6]);
leftpterygoids = muscles([11 13 15]);
righttpterygoids = muscles([12 14 16]);
allpterygoids = muscles([11 12 13 14 15 16]);
leftsubmentalmuscles = muscles([17 19 21 23]);
rightsubmentalmuscles = muscles([18 20 22 24]);
submentalmuscles = muscles([17 18 19 20 21 22 23 24]);

deactivateMuscles = leftpterygoids;
       
%-------------------------------VARIABLES----------------------------------
% Simulation variables
simDur = 0.5; %s
simTimeStep =  0.005; %s
fs = 1/simTimeStep; % Hz 200 from tracker and 1000 from emg
% time step; 
numSim = 2;
t0PertWindow = [0:0.05:0.45]; %s
tfPertWindow = [0.05:0.05:0.5]; %s
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
[invExcitations,invICP,invICV] = inversesim(simDur,invModelName);

%------------------------SMOOTH EXCITATION SIGNAL--------------------------
smoothExcitations = smoothexcitationsignal(invExcitations(:,2:25));

for w = 1:length(t0PertWindow)
    outputfilename = strcat('Output Data_', datestr(now,'mmmm_dd_yyyy_HH_MM_'),num2str(w));
    mkdir(outputfilename);

    %------------------------PERTUBATION WINDOW GEN----------------------------
    % Create local pertubation window and shape function
    window = createlocalpertwindow(simDur,t0PertWindow(w),tfPertWindow(w),fs);

    % Create local pertubation shape function
    openPertShape = createpertshape(pertShapeType(1),window);

    %------------------------------FORWARDSIM----------------------------------
    %Load calculated excitations, run forward simulation, and collect position,
    %velocity, and force

    % Pertubation Study
    [simulationParamTable, statvarTable] = ...
         pertstudy(  simDur...
                     ,smoothExcitations...
                     ,window...
                     ,openPertShape...
                     ,muscles...
                     ,pertModelType(1)...
                     ,forwardModelName...
                     ,invModelName...
                     ,pertShapeType(1)...
                     ,invICP...
                     ,numSim...
                     ,outputfilename...
                    );
end
% Write smooth excitations to excitation probe input files for forward sim.            
% writeToExcitFiles("C:\Users\kieran\develop\artisynth\artisynth_projects\src\artisynth\models\kieran\tmjsurgery\data",0,0.5,smoothExcitations,muscles);