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
           'lat','rat','lmt','rmt','lpt','rpt','lsm','rsm','ldm','rdm',...
           'lmp','rmp','lsp','rsp','lip','rip','lad','rad','lam','ram',...
           'lpm','rpm','lgh','rgh'};
       
%-------------------------------VARIABLES----------------------------------
% Simulation variables
simTime = 0.5; %s
simTimeStep =  0.005; %s
fs = 1/simTimeStep; % Hz 200 from tracker and 1000 from emg
% time step; 
numSim = 100;
t0PertWindow = 0.0; %s
tfPertWindow = 0.05; %s
pertModelType = ["additive", "multiplicative"];
pertShapeType = ["unitstep", "ramp"];

%Script variables
invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';
outputfilename = strcat('Output Data_', datestr(now,'mmmm_dd_yyyy_HH_MM'));

 mkdir(outputfilename);

%-------------------------------INVERSES-----------------------------------
%Load, run, and extract Inverse simulation data
% Inverse Simulation
[invExcitations,invICP,invICV] = ...
    inverseSim(simTime,invModelName);

%------------------------PERTUBATION WINDOW GEN----------------------------
% Create local pertubation window and shape function
openWindow = createLocalPertWindow(invExcitations,t0PertWindow,tfPertWindow, fs);

% Create local pertubation shape function
openPertShape = createPertShape(pertShapeType(1),openWindow);

%----------------------PLOT AND SAVE RAW EXCITATIONS-----------------------
% %Mylohyiod [4 16 ], digastric [1 13], and geniohyoid [5 17]
plotExcitations(invExcitations,0, muscles(:, [17 18 19 20 21 22 23 24]),'InvHyoids-Digastrics',outputfilename,openWindow);

% Pterygoids [3 14 3 15 12 24]
plotExcitations(invExcitations,0, muscles(:, [11 12 13 14 15 16]),'InvPterygoids',outputfilename,openWindow);

% Temperols [6 18 7 19 9 21]
plotExcitations(invExcitations,0, muscles(:, [1 2 3 4 5 6]),'InvTemperols',outputfilename,openWindow);

% Masseters [10 22 11 23]
plotExcitations(invExcitations,0, muscles(:, [7 8 9 10]),'InvMasseters',outputfilename,openWindow);

%------------------------SMOOTH EXCITATION SIGNAL--------------------------
smoothExcitations = zeros(size(invExcitations));
smoothExcitations(:,1) = invExcitations(:,1);

for i = 2:size(invExcitations,2)
     smoothExcitations(:,i) = smoothdata(invExcitations(:,i));
end
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
                 ,outputfilename...\\
                );
% Write smooth excitations to excitation probe input files for forward sim.            
writeToExcitFiles("C:\Users\kieran\develop\artisynth\artisynth_projects\src\artisynth\models\kieran\tmjsurgery\data",0,0.5,smoothExcitations,muscles);