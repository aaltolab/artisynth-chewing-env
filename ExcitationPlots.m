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

% Masseter, Medial Pterygoid, and Temporalis
leftJawOpeners = muscles([1 3 5 7 9 11]);
rightJawOpeners = muscles([2 4 6 8 10 12]);

% Digastricus, Geniohyoid, Lateral pterygoid, Mylohyoid
leftJawClosers = muscles([13 15 17 19 21 23]);
rightJawClosers = muscles([14 16 18 20 22 24]);

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

musclesToDeactivate = leftpterygoids;
muscleDeactivatedDescription = 'Left Pterygoids Removed';

%-------------------------ARTISYNTH MODEL NAMES---------------------------
invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';

outputFileName = 'Excitation Plots';
mkdir(outputFileName);

%-------------------------------PREOP------------------------------
% [preopInvExcitations,preopiInvICP,preopInvICV] = inversesim(simDur,invModelName);
% preopSmoothExcit = smoothexcitationsignal(preopInvExcitations(:,2:25));
% [preopICP,preopICV,preopExcit] = ...
% 	forwardsim(simDur,forwardModelName,preopSmoothExcit,muscles);
% 
% %-------------------------------POSTOP------------------------------
% [postopInvExcitations,postopiInvICP,preopInvICV] = inversesim(simDur,invModelName,musclesDeactivated);
% postopSmoothExcit = smoothexcitationsignal(postopInvExcitations(:,2:25));
% [postopICP,postopICV,postopExcit] = ...
% 	forwardsim(simDur,forwardModelName,postopSmoothExcit,muscles);

%-------------------------------PREOP------------------------------
[preopInvExcitations,preopInvICP,preopInvICV] = inversesim(simDur,invModelName);

preopSmoothExcit = smoothexcitationsignal(preopInvExcitations(:,2:25));

[goalICP,preopICV,preopExcit] = ...
	forwardsim(simDur,forwardModelName,preopSmoothExcit,muscles);

%---------------------------------POSTOP------------------------------
[postopICPForw,postopICV,postopExcit] = ...
    forwardsim(simDur,forwardModelName,preopSmoothExcit,muscles,musclesToDeactivate);
    
%---------------------------INVERSE COMPENSATION-----------------------
[compensatedExcit,compensatedExcitICP,compensatedExcitICV] = ...
    inversesim(simDur,invModelName,musclesToDeactivate);

compensatedSmoothExcit = smoothexcitationsignal(compensatedExcit(:,2:25));

[compensatedICPForw,compensatedICVForw,compensatedExcitForw] = ...
    forwardsim(simDur,forwardModelName,compensatedSmoothExcit,muscles,musclesToDeactivate);

%---------------------------EXCITATION PLOTS--------------------------------
for iplot= 1:1
    %parameters for figure and panel size
    plotheight=20;
    plotwidth=16;
    subplotsx=4;
    subplotsy=3;   
    leftedge=1.2;
    rightedge=0.4;   
    topedge=1;
    bottomedge=1.5;
    spacex=0.3;
    spacey=0.5;
    fontsize=3;    
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
                % Column
                if(i == 1 && ii == 3)
                    plotexcitations(t,preopExcit,leftJawClosers,goalICP, outputFileName,'Jaw Depressors');
                end
                if(i == 1 && ii == 2)
                    plotexcitations(t,preopExcit,leftJawOpeners,goalICP,outputFileName,'Jaw Elevators');
                end
                % Coronal
                if(i == 1 && ii == 1)
                    plotincisorposition(goalICP,postopICPForw,compensatedICPForw,[0,0],['Fontal View'])
                end
                
                % Column 2
                if(i == 2 && ii == 3)
                    plotexcitations(t,postopExcit,leftJawClosers,postopICPForw, outputFileName,'Jaw Depressors');
                end
                if(i == 2 && ii == 2)
                    plotexcitations(t,postopExcit,leftJawOpeners,postopICPForw,outputFileName,'Jaw Elevators');
                end
                % Sagittal
                if(i == 2 && ii == 1)
                    plotincisorposition(goalICP,postopICPForw,compensatedICPForw,[90,0],['Sagittal View'])
                end
                
                % Column 3
                if(i == 3 && ii == 3)
                    plotexcitations(t,compensatedExcitForw,leftJawClosers,compensatedICPForw, outputFileName,'Jaw Depressors');
                end
                if(i == 3 && ii == 2)
                    plotexcitations(t,compensatedExcitForw,leftJawOpeners,compensatedICPForw,outputFileName,'Jaw Elevators');
                end
                % Axial
                if(i == 3 && ii == 1)
                    plotincisorposition(goalICP,postopICPForw,compensatedICPForw,[0,90],['Superior View'])
                end
                
                % Column 4
                if(i == 4 && ii == 3)
                    plotexcitations(t,compensatedExcitForw,rightJawClosers,compensatedICPForw, outputFileName,'Jaw Depressors');
                end
                if(i == 4 && ii == 2)
                    plotexcitations(t,compensatedExcitForw,rightJawOpeners,compensatedICPForw,outputFileName,'Jaw Elevators');
                end
            end
            
            if ii==subplotsy
                if (i == 1)
                    title('Pre Op');
                elseif (i == 2)
                    title(['Post Op Muscle Excitations','(',muscleDeactivatedDescription,')']);
                elseif (i == 3)
                    title(['Left Compensated Post Op Excitations','(',muscleDeactivatedDescription,')']);
                elseif (i == 4)
                    title(['Right Compensated Post Op Excitations','(',muscleDeactivatedDescription,')']);
                end
            end
        
            if ii>1
                set(ax,'xticklabel',[])
            end
        
            if i>1
                set(ax,'yticklabel',[])
            end
        
            if ii==3 || ii==2
                ylabel('Excitation [%]')
                xlabel(['Time [s]'])

            end
            if ii==1
                zlabel('Longitudinal Axis [mm]')
                xlabel('Frontal Axis [mm]');
                ylabel('Sagittal Axis [mm]');
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

