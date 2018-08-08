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
lat     =  'Left Anterior Temporal';
rat     =  'Right Anterior Temporal';
lmt     =  'Left Middle Temporal';
rmt     =  'Right Middle Temporal';
lpt     =  'Left Posterior Temporal';
rpt     =  'Right Posterior Temporal';
lsm     =  'Left Superficial Masseter';
rsm     =  'Right Superficial Masseter';
ldm     =  'Left Deep Masseter';
rdm     =  'Right Deep Masseter';
lmp     =  'Left Medial Pterygoid';
rmp     =  'Right Medial Pterygoid';		
lsp     =  'Left Superior Lateral Pterygoid';
rsp     =  'Right Superior Lateral Pterygoid';
lip     =  'Left Inferior Lateral Pterygoid';
rip     =  'Right Inferior Lateral Pterygoid';
lad     =  'Left Anterior Digastric';
rad     =  'Right Anterior Digastric';
lam     =  'Left Mylohyoid';
ram     =  'Right Mylohyoid';
lpm     =  'Left Posterior Mylohyoid';
rpm     =  'Right Posterior Mylohyoid';
lgh     =  'Left Geniohyoid';
rgh     =  'Right Geniohyoid';	

%--------------------------SET MUSCLE ON OR OFF---------------------------
% 1 is on and 0 if off

latOn   = 0;
ratOn   = 1;
lmtOn   = 0;
rmtOn   = 1;
lptOn   = 0;
rptOn   = 1;
lsmOn   = 1;
rsmOn   = 1;
ldmOn   = 1;
rdmOn   = 1;
lmpOn   = 1;
rmpOn   = 1;
lspOn   = 1;
rspOn   = 1;
lipOn   = 1;
ripOn   = 1;
ladOn   = 1;
radOn   = 1;
lamOn   = 1;
ramOn   = 1;
lpmOn   = 1;
rpmOn   = 1;
lghOn   = 1;
rghOn   = 1;
       
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
%Load, run, and extrOn Inverse simulation data
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

if(latOn==1)
    ah.setIprobeData (lat  ,horzcat(t,smoothExcitations(:,1)));
else    
    ah.setIprobeData (lat  ,horzcat(t,zeros(size(smoothExcitations(:,1)))));
end
if(ratOn==1)
    ah.setIprobeData (rat  ,horzcat(t,smoothExcitations(:,2)));
else
    ah.setIprobeData (rat  ,horzcat(t,zeros(size(smoothExcitations(:,2)))));
end
if(lmtOn==1)
    ah.setIprobeData (lmt  ,horzcat(t,smoothExcitations(:,3)));
else
    ah.setIprobeData (lmt  ,horzcat(t,zeros(size(smoothExcitations(:,3)))));
end
if(rmtOn==1)
    ah.setIprobeData (rmt  ,horzcat(t,smoothExcitations(:,4)));
else
    ah.setIprobeData (rmt  ,horzcat(t,zeros(size(smoothExcitations(:,4)))));
end
if(lptOn==1)
    ah.setIprobeData (lpt  ,horzcat(t,smoothExcitations(:,5)));
else
    ah.setIprobeData (lpt  ,horzcat(t,zeros(size(smoothExcitations(:,5)))));
end
if(rptOn==1)
    ah.setIprobeData (rpt  ,horzcat(t,smoothExcitations(:,6)));
else
    ah.setIprobeData (rpt  ,horzcat(t,zeros(size(smoothExcitations(:,6)))));
end
if(lsmOn==1)
    ah.setIprobeData (lsm  ,horzcat(t,smoothExcitations(:,7)));
else
    ah.setIprobeData (lsm  ,horzcat(t,zeros(size(smoothExcitations(:,7)))));
end
if(rsmOn==1)
    ah.setIprobeData (rsm  ,horzcat(t,smoothExcitations(:,8)));

else
    ah.setIprobeData (rsm  ,horzcat(t,zeros(size(smoothExcitations(:,8)))));
end
if(ldmOn==1)
    ah.setIprobeData (ldm  ,horzcat(t,smoothExcitations(:,9)));
else
    ah.setIprobeData (ldm  ,horzcat(t,zeros(size(smoothExcitations(:,10)))));
end
if(rdmOn==1)
    ah.setIprobeData (rdm  ,horzcat(t,smoothExcitations(:,10)));

else
    ah.setIprobeData (rdm  ,horzcat(t,zeros(size(smoothExcitations(:,10)))));
end
if(lmpOn==1)
    ah.setIprobeData (lmp  ,horzcat(t,smoothExcitations(:,11)));
else
    ah.setIprobeData (lmp  ,horzcat(t,zeros(size(smoothExcitations(:,11)))));
end
if(rmpOn==1)
    ah.setIprobeData (rmp  ,horzcat(t,smoothExcitations(:,12)));
else
    ah.setIprobeData (rmp  ,horzcat(t,zeros(size(smoothExcitations(:,12)))));
end
if(lspOn==1)
    ah.setIprobeData (lsp  ,horzcat(t,smoothExcitations(:,13)));
else
    ah.setIprobeData (lsp  ,horzcat(t,zeros(size(smoothExcitations(:,13)))));
end
if(rspOn==1)
    ah.setIprobeData (rsp  ,horzcat(t,smoothExcitations(:,14)));
else
    ah.setIprobeData (rsp  ,horzcat(t,zeros(size(smoothExcitations(:,14)))));
end
if(lipOn==1)
    ah.setIprobeData (lip  ,horzcat(t,smoothExcitations(:,15)));

else
    ah.setIprobeData (lip  ,horzcat(t,zeros(size(smoothExcitations(:,15)))));
end
if(ripOn==1)
    ah.setIprobeData (rip  ,horzcat(t,smoothExcitations(:,16)));

else
    ah.setIprobeData (rip  ,horzcat(t,zeros(size(smoothExcitations(:,16)))));
end
if(ladOn==1)
    ah.setIprobeData (lad  ,horzcat(t,smoothExcitations(:,17)));

else
    ah.setIprobeData (lad  ,horzcat(t,zeros(size(smoothExcitations(:,17)))));
end
if(radOn==1)
    ah.setIprobeData (rad  ,horzcat(t,smoothExcitations(:,18)));

else
    ah.setIprobeData (rad  ,horzcat(t,zeros(size(smoothExcitations(:,18)))));
end
if(lamOn==1)
    ah.setIprobeData (lam  ,horzcat(t,smoothExcitations(:,19)));

else
    ah.setIprobeData (lam  ,horzcat(t,zeros(size(smoothExcitations(:,19)))));
end
if(ramOn==1)
    ah.setIprobeData (ram  ,horzcat(t,smoothExcitations(:,20)));

else
    ah.setIprobeData (ram  ,horzcat(t,zeros(size(smoothExcitations(:,20)))));
end
if(lpmOn==1)
    ah.setIprobeData (lpm  ,horzcat(t,smoothExcitations(:,21)));
else
    ah.setIprobeData (lpm  ,horzcat(t,zeros(size(smoothExcitations(:,21)))));
end
if(rpmOn==1)
    ah.setIprobeData (rpm  ,horzcat(t,smoothExcitations(:,22)));
else
    ah.setIprobeData (rpm  ,horzcat(t,zeros(size(smoothExcitations(:,22)))));
end
if(lghOn==1)
    ah.setIprobeData (lgh  ,horzcat(t,smoothExcitations(:,23)));
else
    ah.setIprobeData (lgh  ,horzcat(t,zeros(size(smoothExcitations(:,23)))));
end
if(rghOn==1)
    ah.setIprobeData (rgh  ,horzcat(t,smoothExcitations(:,24))); 

else
    ah.setIprobeData (rgh  ,horzcat(t,zeros(size(smoothExcitations(:,24)))));
end


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
 xlim([-0.5 0.5]);
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
 title('Lower mid incisor path (Transverse View)');
%  ylim([-50 	-44]);
 saveas(gcf,strcat(outputfilename, '/TransverseView.png'));