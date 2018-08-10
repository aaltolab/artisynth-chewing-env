% 1. Inverse simulation:
%   All muscles   
%   Target motion (preop)
%    
% 2. Forward simulation (to represent motor response)
%   Get incisor plots (this is the preop comparison path)
%
% 3. Cases for muscle removal:
%   Case 1: Deactivation of muscles attached to one-sided process
%   Case 2: Deactivation of one sided pterygoids muscles
%   Case 3: Deactivation of submental muscles
%   Case 4: 
%
% 4. Pertubation study with removed muscles inverse.
%

%--------------------CLEAR WORKSPACE AND SHUFFLE RNDGEN--------------------
clc;
clear;
close all;
rng('shuffle');

%-------------------------MUSCLE DEFINITIONS------------------------------
muscles = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24;...
           'lat','rat','lmt','rmt','lpt','rpt','lsm','rsm','ldm','rdm',...
           'lmp','rmp','lsp','rsp','lip','rip','lad','rad','lam','ram',...
           'lpm','rpm','lgh','rgh'};
       
deactivatemuscles = muscles(:,[3 5]);

invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';

outputfilename = strcat('Surgery Data_', datestr(now,'mmmm_dd_yyyy_HH_MM'));
mkdir(outputfilename);

simTime = 0.5; %s

%-----------------------------INVERSE SIM----------------------------------
%Load, run, and extract Inverse simulation data
% Inverse Simulation
[trackingExcitations,trackingICP,trackingICV] = ...
    inverseSim(simTime,invModelName);

%-----------------------------SMOOTH EXCIT----------------------------------
smoothExcitations = zeros(size(trackingExcitations));
smoothExcitations(:,1) = trackingExcitations(:,1);

for i = 2:size(trackingExcitations,2)
     smoothExcitations(:,i) = smoothdata(trackingExcitations(:,i));
end

%-----------------------------FORWARD PRE-OP-------------------------------
[preOpICP,preOpICV] = ...
    forwardSim(simTime,forwardModelName,smoothExcitations);

%-----------------------------FORWARD SIM----------------------------------
% Remove muscle at left proccess
[postOpICP,postOpICV] = ...
    forwardSim(simTime,forwardModelName,smoothExcitations,deactivatedmuscles);

%-----------------------------INCISOR PLOTS---------------------------------
% Generate pre simulation plots
[maxNumPreOp, maxIndexPreop] = min(preOpICP(:,4));
[maxNumPostOp, maxIndexPostOp] = min(postOpICP(:,4));
% Frontal view on ICP
figure;
 plot3(preOpICP(:,2),preOpICP(:,3),preOpICP(:,4),'LineWidth',1.2);
 view(0,0);
 hold on
 plot3(preOpICP(1,2),preOpICP(1,3),preOpICP(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
 hold on
 plot3(preOpICP(end,2),preOpICP(end,3),preOpICP(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
 hold on;
 plot3(preOpICP(maxIndexPreop,2),preOpICP(maxIndexPreop,3),maxNumPreOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
 hold on
 plot3(postOpICP(:,2),postOpICP(:,3),postOpICP(:,4),'LineWidth',1.2);
 view(0,0);
 hold on
 plot3(postOpICP(1,2),postOpICP(1,3),postOpICP(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
 hold on
 plot3(postOpICP(end,2),postOpICP(end,3),postOpICP(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
 hold on
 plot3(postOpICP(maxIndexPostOp,2),postOpICP(maxIndexPostOp,3),maxNumPostOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
 legend('Pre Op ICP', 'Pre Op  Initial ICP', 'Pre Op  Final ICP', 'Pre Op Max Opening ICP' ,'Post Op ICP', 'Post Op Initial ICP', 'Post Op Final ICP', 'Post Op Max Opening ICP');
 xlabel('X axis [mm]');
 zlabel('Z axis [mm]');
 title('Lower mid incisor path (Frontal View)');
%  xmax = max(postOpICP(:,2)) + 0.05*max(postOpICP(:,2));
%  xmin = min(postOpICP(:,2)) - 0.05*min(postOpICP(:,2));
%  xlim([xmin xmax]);    
     saveas(gcf,strcat(outputfilename, '\FrontalView.pdf'));
 
 % Transverse view on ICP
figure;
 plot3(preOpICP(:,2),preOpICP(:,3),preOpICP(:,4),'LineWidth',1.2);
 view(90,0)  % YZ
 hold on
 plot3(preOpICP(1,2),preOpICP(1,3),preOpICP(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
 hold on
 plot3(preOpICP(end,2),preOpICP(end,3),preOpICP(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
 hold on
 plot3(preOpICP(maxIndexPreop,2),preOpICP(maxIndexPreop,3),maxNumPreOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
 hold on
 plot3(postOpICP(:,2),postOpICP(:,3),postOpICP(:,4),'LineWidth',1.2);
 view(90,0)  % YZ
 hold on
 plot3(postOpICP(1,2),postOpICP(1,3),postOpICP(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
 hold on
 plot3(postOpICP(end,2),postOpICP(end,3),postOpICP(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
 hold on
 plot3(postOpICP(maxIndexPostOp,2),postOpICP(maxIndexPostOp,3),maxNumPostOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
 legend('Pre Op  ICP', 'Pre Op  Initial ICP', 'Pre Op  Final ICP', 'Pre Op Max Opening ICP' ,'Post Op ICP', 'Post Op Initial ICP', 'Post Op Final ICP', 'Post Op Max Opening ICP');
 ylabel('Y axis [mm]');
 zlabel('Z axis [mm]');
 title('Lower mid incisor path (Tansverse View)');
 saveas(gcf,strcat(outputfilename,'/TransverseView.pdf'));