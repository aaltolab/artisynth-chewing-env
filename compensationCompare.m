% Compare baseline inverse trajectory to the compensaed trajectory
% Select a muscle deactive case and match the outputfile name
% Script generate raw and smooth excitations after filtering
% Finally Generates Trajecoty plots that compare the forward results

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

%-------------------------MUSCLE DEACTIVE CASES----------------------------
leftsidecorprocess = muscles(:,[3 5]);
rightsidecorprocess = muscles(:,[4 6]);
bothcorprocess = muscles(:,[3 4 5 6]);
leftpterygoids = muscles(:,[11 13 15]);
righttpterygoids = muscles(:,[12 14 16]);
allpterygoids = muscles(:,[11 12 13 14 15 16]);
leftsubmentalmuscles = muscles(:,[17 19 21 23]);
rightsubmentalmuscles = muscles(:,[18 20 22 24]);
submentalmuscles = muscles(:,[17 18 19 20 21 22 23 24]);

deactivatedmuscles = submentalmuscles;


invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';

outputfilename = strcat('submentalmuscles', datestr(now,'mmmm_dd_yyyy_HH_MM'));
mkdir(outputfilename);

simTime = 0.5; %s
simTimeStep =  0.005; %s
fs = 1/simTimeStep; % Hz 200 from tracker and 1000 from emg
% time step; 
numSim = 5;
t0PertWindow = 0; %s
tfPertWindow = 0.5; %s
%-----------------------------BASELINE MODEL-------------------------------
[preopExcit,preOpICP,preOpICV] = ...
    inverseSim(simTime,invModelName);

window = createLocalPertWindow(preopExcit,t0PertWindow,tfPertWindow,fs);

preOpsmoothExcitations = zeros(size(preopExcit));
preOpsmoothExcitations(:,1) = preopExcit(:,1);

for i = 2:size(preopExcit,2)
     preOpsmoothExcitations(:,i) = smoothdata(preopExcit(:,i));
end

%-----------------------------COMP MODEL----------------------------------
[postopExcit,postOpICP,postOpICV] = ...
    inverseSim(simTime,invModelName,deactivatedmuscles);

postOpsmoothExcitations = zeros(size(postopExcit));
postOpsmoothExcitations(:,1) = postopExcit(:,1);

for i = 2:size(postopExcit,2)
     postOpsmoothExcitations(:,i) = smoothdata(postopExcit(:,i));
end

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
 xlim([-5 0.25]); 
 title('Lower mid incisor path (Frontal View)');
 
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

%-----------------------------PREOP EXCIT PLOTS----------------------------
% %Mylohyiod, digastric, and geniohyoid
plotExcitations(preopExcit,0, muscles(:, [17 18 19 20 21 22 23 24]),'Preop Hyoids-Digastrics',outputfilename,window,preOpICP);
plotExcitations(preOpsmoothExcitations,0, muscles(:, [17 18 19 20 21 22 23 24]),'Preop Smooth Hyoids-Digastrics',outputfilename,window,preOpICP);
% Pterygoids
plotExcitations(preopExcit,0, muscles(:, [11 12 13 14 15 16]),'Preop Pterygoids',outputfilename,window,preOpICP);
plotExcitations(preOpsmoothExcitations,0, muscles(:, [11 12 13 14 15 16]),'Preop Smooth Pterygoids',outputfilename,window,preOpICP);
% Temperols
plotExcitations(preopExcit,0, muscles(:, [1 2 3 4 5 6]),'Preop Temperols',outputfilename,window,preOpICP);
plotExcitations(preOpsmoothExcitations,0, muscles(:, [1 2 3 4 5 6]),'Preop Smooth Temperols',outputfilename,window,preOpICP);
% Masseters
plotExcitations(preopExcit,0, muscles(:, [7 8 9 10]),'Preop Masseters',outputfilename,window,preOpICP);
plotExcitations(preOpsmoothExcitations,0, muscles(:, [7 8 9 10]),'Preop Smooth Masseters',outputfilename,window,preOpICP);
%-----------------------------POST OP PLOTS--------------------------------
% %Mylohyiod, digastric, and geniohyoid
plotExcitations(postopExcit,0, muscles(:, [17 18 19 20 21 22 23 24]),'Postop Hyoids-Digastrics',outputfilename,window,postOpICP);
plotExcitations(postOpsmoothExcitations,0, muscles(:, [17 18 19 20 21 22 23 24]),'Postop Smooth Hyoids-Digastrics',outputfilename,window,postOpICP);
% Pterygoids
plotExcitations(postopExcit,0, muscles(:, [11 12 13 14 15 16]),'Postop Pterygoids',outputfilename,window,postOpICP);
plotExcitations(postOpsmoothExcitations,0, muscles(:, [11 12 13 14 15 16]),'Postop Smooth Pterygoids',outputfilename,window,postOpICP);
% Temperols
plotExcitations(postopExcit,0, muscles(:, [1 2 3 4 5 6]),'Postop Temperols',outputfilename,window,postOpICP);
plotExcitations(postOpsmoothExcitations,0, muscles(:, [1 2 3 4 5 6]),'Postop Smooth Temperols',outputfilename,window,postOpICP);
% Masseters
plotExcitations(postopExcit,0, muscles(:, [7 8 9 10]),'Postop Masseters',outputfilename,window,postOpICP);
plotExcitations(postOpsmoothExcitations,0, muscles(:, [7 8 9 10]),'Postop Smooth Masseters',outputfilename,window,postOpICP); 

% files = dir(fullfile(strcat(outputfilename,'/PreSimPlots/'), '*.pdf'));
% names = {files.name};
% filepaths = cell(1,length(names));
% 
% for f = :length(names)
%     filepaths{1,f} = strcat(outputfilename,'/PreSimPlots/',names{f});
% end
% 
% append_pdfs(string(filepaths(1)),string(filepaths));
save(strcat(outputfilename,'/preopExcit.txt'),'preopExcit');
save(strcat(outputfilename,'/preOpsmoothExcitations.txt'),'preOpsmoothExcitations');
save(strcat(outputfilename,'/preOpICP.txt','preOpICP'));
save(strcat(outputfilename,'/postopExcit.txt','postopExcit'));
save(strcat(outputfilename,'/postOpsmoothExcitations.txt'),'postOpsmoothExcitations');
save(strcat(outputfilename,'/postOpICP.txt'),'postOpICP');
