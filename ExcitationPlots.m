%-------------------------------SUMMARY------------------------------------
% This script generates inverse and forward excitation plots for each group
% of muscles pre and post op. The excitations signals are collected for the
% target trajectory of the the jaw in an inverse simulation, those signals
% are then smoothed and plotted. The smooth signals are used to drive the 
% forward simulations.

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
leftsidecorprocess = muscles([3 5]);
rightsidecorprocess = muscles([4 6]);
bothcorprocess = muscles([3 4 5 6]);
leftpterygoids = muscles([11 13 15]);
righttpterygoids = muscles([12 14 16]);
allpterygoids = muscles([11 12 13 14 15 16]);
leftsubmentalmuscles = muscles([17 19 21 23]);
rightsubmentalmuscles = muscles([18 20 22 24]);
submentalmuscles = muscles([17 18 19 20 21 22 23 24]);

musclesDeactivated = leftpterygoids;
muscleDeactivatedDescription = 'Left Pterygoids Removed';

%-------------------------ARTISYNTH MODEL NAMES---------------------------
invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';

outputFileName = 'Excitation Plots';
mkdir(outputFileName);

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

%---------------------------EXCITATION PLOTS--------------------------------
for iplot= 1:3
%parameters for figure and panel size
plotheight=20;
plotwidth=16;
subplotsx=2;
subplotsy=3;   
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

%loop to create axes
for i=1:subplotsx
    for ii=1:subplotsy

    ax=axes('position',sub_pos{i,ii},'XGrid','off','XMinorGrid','off','FontSize',fontsize,'Box','on','Layer','top');
    if(iplot == 1)    
        if(i == 1 && ii == 3)
            plotexcitations(t,preopExcit,temporals,preopICP, outputFileName,'Preop Temporals Excitations');
        end     
        if(i == 2 && ii == 3)
            plotexcitations(t,postopExcit,temporals,postopICP,outputFileName,'Postop Temporals Excitations');
        end
        if(i == 1 && ii == 2)
            plotexcitations(t,preopExcit,masseters,preopICP, outputFileName,'Preop Masseters Excitations');
        end
        if(i == 2 && ii == 2)
            plotexcitations(t,postopExcit,masseters,postopICP,outputFileName,'Postop Masseters Excitations');
        end
        if(i == 1 && ii == 1)
            plotexcitations(t,preopExcit,pterygoids,preopICP, outputFileName,'Preop Pterygoids Excitations');
        end
        if(i == 2 && ii == 1)
            plotexcitations(t,postopExcit,pterygoids,postopICP,outputFileName,'Postop Pterygoids Excitations');
        end
    end
    if(iplot == 2)
        if(i == 1 && ii == 3)
            plotexcitations(t,preopExcit,digastrics,preopICP, outputFileName,'Preop Digastrics Excitations');
        end
        if(i == 2 && ii == 3)
            plotexcitations(t,postopExcit,digastrics,postopICP,outputFileName,'Postop Digastrics Excitations');
        end
        if(i == 1 && ii == 2)
            plotexcitations(t,preopExcit,mylohyoid,preopICP, outputFileName,'Preop Mylohyoid Excitations');
        end
        if(i == 2 && ii == 2)
            plotexcitations(t,postopExcit,mylohyoid,postopICP,outputFileName,'Postop Mylohyoid Excitations');
        end
        if(i == 1 && ii == 1)
            plotexcitations(t,preopExcit,geniohyoid,preopICP, outputFileName,'Preop Geniohyoid Excitations');
        end
        if(i == 2 && ii == 1)
            plotexcitations(t,postopExcit,geniohyoid,postopICP,outputFileName,'Postop Geniohyoid Excitations');
        end
    end

    if(iplot == 3)
        if(i == 1 && ii == 3)
            plotexcitations(t,preopInvExcitations(:,2:25),temporals,preopICP, outputFileName,'Inverse Temporals Excitations');
        end
        if(i == 2 && ii == 3)
            plotexcitations(t,preopInvExcitations(:,2:25),masseters,postopICP,outputFileName,'Inverse Masseters Excitations');
        end
        if(i == 1 && ii == 2)
            plotexcitations(t,preopInvExcitations(:,2:25),pterygoids,preopICP, outputFileName,'Inverse Pterygoids Excitations');
        end
        if(i == 2 && ii == 2)
            plotexcitations(t,preopInvExcitations(:,2:25),digastrics,postopICP,outputFileName,'Inverse Digastrics Excitations');
        end
        if(i == 1 && ii == 1)
            plotexcitations(t,preopInvExcitations(:,2:25),mylohyoid,preopICP, outputFileName,'Inverse Mylohyoid Excitations');
        end
        if(i == 2 && ii == 1)
            plotexcitations(t,preopInvExcitations(:,2:25),geniohyoid,postopICP,outputFileName,'Inverse Geniohyoid Excitations');
        end
    end

    if ii==subplotsy
        if (iplot ~= 3)
            if (i == 1)
                title('Pre Op Muscle Excitations');
            elseif (i == 2)
                title(['Post Op Muscle Excitations','(',muscleDeactivatedDescription,')']);
            end
        else
            title('Raw Inverse Excitations');
        end
end

    if ii>1
    set(ax,'xticklabel',[])
    end

    if i>1
    set(ax,'yticklabel',[])
    end

    if i==1
    ylabel('Excitation [%]')
    end

    if ii==1
    xlabel(['Time [s]'])
    end

    end
end
end
%Saving eps with matlab and then producing pdf and png with system commands
%If using windows or mac you need to download the MikTex commandline tool.
%https://miktex.org/download

fileName=['Excitations'];
print(gcf, '-depsc2','-loose',[outputFileName,'/',fileName,'.eps']);
system(['epstopdf ',outputFileName,'/',fileName,'.eps'])
system(['convert -density 300 ',outputFileName,'/',fileName,'.eps',outputFileName,'/',fileName,'.png'])

