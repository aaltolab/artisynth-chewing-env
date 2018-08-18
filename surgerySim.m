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

%--------------------CLEAR WORKSPACE AND SHUFFLE RNDGEN--------------------
clc;
clear;
close all;
rng('shuffle');

%-------------------------SCRIPT DEFINITIONS------------------------------  
simDur  = 0.5;
dt = 0.005;
t = [0:dt:simDur];

%-------------------------MUSCLE DEFINITIONS------------------------------  
muscles = createmusclestruct('musclekey.txt'); 
% Muscle Groups
temporals  = muscles([1:6]);
masseters  = muscles([7:8]);
pterygoids = muscles([11:16]);
digastrics = muscles([17:18]);
mylohyoid  = muscles([19:22]);
geniohyoid = muscles([23:24]);

% Muscle Groups to be deactivated
leftsidecorprocess = muscles(:,[3 5]);
rightsidecorprocess = muscles(:,[4 6]);
bothcorprocess = muscles(:,[3 4 5 6]);
leftpterygoids = muscles(:,[11 13 15]);
righttpterygoids = muscles(:,[12 14 16]);
allpterygoids = muscles(:,[11 12 13 14 15 16]);
leftsubmentalmuscles = muscles(:,[17 19 21 23]);
rightsubmentalmuscles = muscles(:,[18 20 22 24]);
submentalmuscles = muscles(:,[17 18 19 20 21 22 23 24]);

musclesDeactivated = pterygoids;
muscleDeactivatedDescription = 'Pterygoids Removed';


invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';

outputfilename = strcat('Trajectory Plots');
mkdir(outputfilename);

%-------------------------------PREOP------------------------------
[preopInvExcitations,preopiInvICP,preopInvICV] = inversesim(simDur,invModelName);
preopSmoothExcit = smoothexcitationsignal(preopInvExcitations(:,2:25));
[preopICP,preopICV,preopExcit] = ...
	forwardsim(simDur,forwardModelName,preopSmoothExcit,muscles);

%-------------------------------POSTOP------------------------------
[postopInvExcitations,postopiInvICP,preopInvICV] = inversesim(simDur,invModelName,musclesDeactivated);
postopSmoothExcit = smoothexcitationsignal(postopInvExcitations(:,2:25));
[postopICP,postopICV,postopExcit] = ...
	forwardsim(simDur,forwardModelName,postopSmoothExcit,muscles);

%-----------------------------INCISOR PLOTS---------------------------------
%parameters for figure and panel size
plotheight=20;
plotwidth=16;
subplotsx=2;
subplotsy=6;   
leftedge=1.2;
rightedge=0.4;   
topedge=1;
bottomedge=1.5;
spacex=0.2;
spacey=0.2;
fontsize=5;    
sub_pos=subplotpos(plotwidth,plotheight,leftedge,rightedge,bottomedge,topedge,subplotsx,subplotsy,spacex,spacey);

%setting the Matlab figure
f=figure('visible','on')
clf(f);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 plotwidth plotheight]);

%TODO: generate plots from incisor path
%TODO: run first case
%loop to create axes
for i=1:subplotsx
    for ii=1:subplotsy

    ax=axes('position',sub_pos{i,ii},'XGrid','off','XMinorGrid','off','FontSize',fontsize,'Box','on','Layer','top');

    if(i == 1 && ii == 1)
        plotincisorposition(goalICP,postopICPForw,[0,0])
    end
    if(i == 2 && ii == 1)
        plotincisorposition(goalICP,postopICPForw,[90,0])
    end
    if(i == 1 && ii == 2)
        plotincisorposition(preopICPInv,postopICPInv,[0,0])
    end
    if(i == 2 && ii == 2)
        plotincisorposition(preopICPInv,postopICPInv,[90,0])
    end
    if(i == 1 && ii == 3)
        plotincisorposition(goalICP,postopForwICPRecov,[0,0])
    end
    if(i == 2 && ii == 3)
        plotincisorposition(goalICP,postopForwICPRecov,[90,0])
    end
    if ii==subplotsy
        if (i == 1)
            title('Frontal View');
        elseif (i == 2)
            title('Transverse View');
end
end

    if ii>1
    set(ax,'xticklabel',[])
    end

    if i>1
    set(ax,'yticklabel',[])
    end

    if i==1
    ylabel('Position [mm]')
    end

    if ii==1
    xlabel(['Position [mm]'])
    end

    end
end

%Saving eps with matlab and then producing pdf and png with system commands
%If using windows or mac you need to download the MikTex commandline tool.
%https://miktex.org/download

fileName=['ICPcases'];
print(gcf, '-depsc2','-loose',[outputFileName,'/',fileName,'.eps']);
system(['epstopdf ',outputFileName,'/',fileName,'.eps'])
system(['convert -density 300 ',outputFileName,'/',fileName,'.eps',outputFileName,'/',fileName,'.png'])