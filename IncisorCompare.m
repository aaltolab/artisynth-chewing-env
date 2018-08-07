%Code by: Kieran Arstrong
%-------------------------------SUMMARY------------------------------------
% 
% 
% 
%
% 
% 
% 
% 
% 
% 

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

%----------------------FULL MUSCLE NAMES FOR IPROBES-----------------------
lad     =  'Left Anterior Digastric';
lip     =  'Left Inferior Lateral Pterygoid';
lsp     =  'Left Superior Lateral Pterygoid';
lam     =  'Left Anterior Mylohyoid';
lgh     =  'Left Geniohyoid';
% lpd     =  'Left Posterior Digastric';
% lsh     =  'Left Stylohyoid';
% lsth    =  'Left Sternohyoid' ;
lat     =  'Left Anterior Temporal';
lmt     =  'Left Middle Temporal';
lpm     =  'Left Posterior Mylohyoid';
lpt     =  'Left Posterior Temporal';
ldm     =  'Left Deep Masseter';
lsm     =  'Left Superficial Masseter';
lmp     =  'Left Medial Pterygoid';
rad     =  'Right Anterior Digastric';
rip     =  'Right Inferior Lateral Pterygoid';
rsp     =  'Right Superior Lateral Pterygoid';
ram     =  'Right Anterior Mylohyoid';
rgh     =  'Right Geniohyoid';
% rpd     =  'Right Posterior Digastric';
% rsh     =  'Right Stylohyoid';
% rsteh   =  'Right Sternohyoid';
rat     =  'Right Anterior Temporal';
rmt     =  'Right Middle Temporal';
rpm     =  'Right Posterior Mylohyoid';
rpt     =  'Right Posterior Temporal';
rdm     =  'Right Deep Masseter';
rsm     =  'Right Superficial Masseter';
rmp     =  'Right Medial Pterygoid';
       
%-------------------------------VARIABLES----------------------------------
% Simulation variables
simTime = 0.5; %s
simTimeStep =  0.005; %s
fs = 1/simTimeStep; % Hz 200 from tracker and 1000 from emg

%Script variables
invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';
outputfilename = strcat('Output Data_Muscle_Compare', datestr(now,'mmmm_dd_yyyy_HH_MM'));

 mkdir(outputfilename);

%-------------------------------INVERSES-----------------------------------
%Load, run, and extract Inverse simulation data
% Inverse Simulation
[invExcitations,invICP,invICV] = ...
    inverseSim(simTime,invModelName);

%------------------------SMOOTH EXCITATION SIGNAL--------------------------
smoothExcitations = zeros(size(invExcitations(:,2:25)));
t = invExcitations(:,1);

for i = 2:size(smoothExcitations,2)
     smoothExcitations(:,i-1) = smoothdata(invExcitations(:,i));
end
%-----------------------FORWARDSIM W INV EXCIT------------------------------
%Load calculated excitations, run forward simulation, and collect position,
%velocity, and force

ah = artisynth('-noGui','-model',forwardModelName);

ah.setIprobeData (lat  ,horzcat(t,smoothExcitations(:,1)));
ah.setIprobeData (rat  ,horzcat(t,smoothExcitations(:,2)));
ah.setIprobeData (lmt  ,horzcat(t,smoothExcitations(:,3)));
ah.setIprobeData (rmt  ,horzcat(t,smoothExcitations(:,4)));
ah.setIprobeData (lpt  ,horzcat(t,smoothExcitations(:,5)));
ah.setIprobeData (rpt  ,horzcat(t,smoothExcitations(:,6)));
ah.setIprobeData (lsm  ,horzcat(t,smoothExcitations(:,7)));
ah.setIprobeData (rsm  ,horzcat(t,smoothExcitations(:,8)));
ah.setIprobeData (ldm  ,horzcat(t,smoothExcitations(:,9)));
ah.setIprobeData (rdm  ,horzcat(t,smoothExcitations(:,10)));
ah.setIprobeData (lmp  ,horzcat(t,smoothExcitations(:,11)));
ah.setIprobeData (rmp  ,horzcat(t,smoothExcitations(:,12)));
ah.setIprobeData (lsp  ,horzcat(t,smoothExcitations(:,13)));
ah.setIprobeData (rsp  ,horzcat(t,smoothExcitations(:,14)));
ah.setIprobeData (lip  ,horzcat(t,smoothExcitations(:,15)));
ah.setIprobeData (rip  ,horzcat(t,smoothExcitations(:,16)));
ah.setIprobeData (lad  ,horzcat(t,smoothExcitations(:,17)));
ah.setIprobeData (rad  ,horzcat(t,smoothExcitations(:,18)));
ah.setIprobeData (lam  ,horzcat(t,smoothExcitations(:,19)));
ah.setIprobeData (ram  ,horzcat(t,smoothExcitations(:,20)));
ah.setIprobeData (lpm  ,horzcat(t,smoothExcitations(:,21)));
ah.setIprobeData (rpm  ,horzcat(t,smoothExcitations(:,22)));
ah.setIprobeData (lgh  ,horzcat(t,smoothExcitations(:,23)));
ah.setIprobeData (rgh  ,horzcat(t,smoothExcitations(:,24))); 

ah.play(simTime);
ah.waitForStop();
% Check incisor path deviation is less that 1mm
icpFull = ah.getOprobeData('incisor_position');

ah.quit();

%-----------------------FORWARDSIM REMOVE MUSCLES-------------------------------
%Load calculated excitations, run forward simulation, and collect position,
%velocity, and force

ah = artisynth('-noGui','-model',forwardModelName);

ah.setIprobeData (lat  ,horzcat(t,smoothExcitations(:,1)));
ah.setIprobeData (rat  ,horzcat(t,smoothExcitations(:,2)));

ah.setIprobeData (lmt  ,horzcat(t,smoothExcitations(:,3)));
ah.setIprobeData (rmt  ,horzcat(t,smoothExcitations(:,4)));

ah.setIprobeData (lpt  ,horzcat(t,smoothExcitations(:,5)));
ah.setIprobeData (rpt  ,horzcat(t,smoothExcitations(:,6)));

ah.setIprobeData (lsm  ,horzcat(t,smoothExcitations(:,7)));
ah.setIprobeData (rsm  ,horzcat(t,smoothExcitations(:,8)));

ah.setIprobeData (ldm  ,horzcat(t,smoothExcitations(:,9)));
ah.setIprobeData (rdm  ,horzcat(t,smoothExcitations(:,10)));

% ah.setIprobeData (lmp  ,horzcat(t,smoothExcitations(:,11)));
ah.setIprobeData (lmp  ,horzcat(t,zeros(size(smoothExcitations(:,11)))));
ah.setIprobeData (rmp  ,horzcat(t,smoothExcitations(:,12)));

ah.setIprobeData (lsp  ,horzcat(t,smoothExcitations(:,13)));
% ah.setIprobeData (lsp  ,horzcat(t,zeros(size(smoothExcitations(:,13)))));
ah.setIprobeData (rsp  ,horzcat(t,smoothExcitations(:,14)));

ah.setIprobeData (lip  ,horzcat(t,smoothExcitations(:,15)));
% ah.setIprobeData (lip  ,horzcat(t,zeros(size(smoothExcitations(:,15)))));
% ah.setIprobeData (rip  ,horzcat(t,smoothExcitations(:,16)));
ah.setIprobeData (rip  ,horzcat(t,zeros(size(smoothExcitations(:,16)))));

ah.setIprobeData (lad  ,horzcat(t,smoothExcitations(:,17)));
ah.setIprobeData (rad  ,horzcat(t,smoothExcitations(:,18)));

ah.setIprobeData (lam  ,horzcat(t,smoothExcitations(:,19)));
ah.setIprobeData (ram  ,horzcat(t,smoothExcitations(:,20)));

ah.setIprobeData (lpm  ,horzcat(t,smoothExcitations(:,21)));
ah.setIprobeData (rpm  ,horzcat(t,smoothExcitations(:,22)));

ah.setIprobeData (lgh  ,horzcat(t,smoothExcitations(:,23)));
ah.setIprobeData (rgh  ,horzcat(t,smoothExcitations(:,24))); 

ah.play(simTime);
ah.waitForStop();
% Check incisor path deviation is less that 1mm
icpAdjusted = ah.getOprobeData('incisor_position');

ah.quit();

% Generate pre simulation plots
% Frontal view on ICP
figure;
 plot3(icpAdjusted(:,2),icpAdjusted(:,3),icpAdjusted(:,4),'LineWidth',1.2);
 view(0,0);
 hold on
 plot3(icpAdjusted(1,2),icpAdjusted(1,3),icpAdjusted(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
 hold on
 plot3(icpAdjusted(end,2),icpAdjusted(end,3),icpAdjusted(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
 hold on
 plot3(icpFull(:,2),icpFull(:,3),icpFull(:,4),'LineWidth',1.2);
 view(0,0);
 hold on
 plot3(icpFull(1,2),icpFull(1,3),icpFull(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
 hold on
 plot3(icpFull(end,2),icpFull(end,3),icpFull(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
 legend('Inverse ICP', 'Inverse Initial ICP', 'Inverse Final ICP', 'Forward ICP', 'Forward Initial ICP', 'Forward Final ICP');
 xlabel('X axis [mm]');
 zlabel('Z axis [mm]');
 title('Lower mid incisor path (Frontal View)');
%  xlim([-0.5 0.5]);
 saveas(gcf,strcat(outputfilename, '\FrontalView.png'));
 
 % Transverse view on ICP
figure;
 plot3(icpAdjusted(:,2),icpAdjusted(:,3),icpAdjusted(:,4),'LineWidth',1.2);
 view(90,0)  % YZ
 hold on
 plot3(icpAdjusted(1,2),icpAdjusted(1,3),icpAdjusted(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
 hold on
 plot3(icpAdjusted(end,2),icpAdjusted(end,3),icpAdjusted(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
 hold on
 plot3(icpFull(:,2),icpFull(:,3),icpFull(:,4),'LineWidth',1.2);
 view(90,0)  % YZ
 hold on
 plot3(icpFull(1,2),icpFull(1,3),icpFull(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
 hold on
 plot3(icpFull(end,2),icpFull(end,3),icpFull(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
 legend('Inverse ICP', 'Inverse Initial ICP', 'Inverse Final ICP', 'Forward ICP', 'Forward Initial ICP', 'Forward Final ICP');
 ylabel('Y axis [mm]');
 zlabel('Z axis [mm]');
 title('Lower mid incisor path (Tansverse View)');
%  ylim([-50 	-44]);
 saveas(gcf,strcat(outputfilename, '/TransverseView.png'));