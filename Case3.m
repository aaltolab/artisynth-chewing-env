

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
lefttemporals = muscles([1 3 5]);

leftmedialpterygoid = muscles([11]);
leftlatalpterygoid = muscles([13 15]]);

musclesToDeactivate = leftlatalpterygoid;
muscleDeactivatedDescription = 'Left Temporals Removed';

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
    plotheight=24.1;
    plotwidth=17.7;
    subplotsx=3;
    subplotsy=4;   
    leftedge=1.5;
    rightedge=1.5;   
    topedge=1.65;
    bottomedge=1.65;
    spacex=0.3;
    spacey=0.5;
    fontsize=2;    
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
            ax=axes('position',sub_pos{i,ii},'XGrid','off','XMinorGrid','off','FontSize',6,'Box','on','Layer','top');
            if(iplot == 1)
                % Column 1 - Jaw Depressors
                if (i == 3 && ii == 4)
                    plotexcitations(t,preopExcit,leftJawClosers,postopICPForw, outputFileName,'Preop Excitations');
                    set(ax,'xticklabel',[])
                    set(ax,'yticklabel',[])
                end
                if(i == 3 && ii == 3)
                    plotexcitations(t,postopExcit,leftJawClosers,postopICPForw, outputFileName,'Postop Excitations');
                    set(ax,'xticklabel',[])
                    set(ax,'yticklabel',[])
                end
                if(i == 3 && ii == 2)
                    plotexcitations(t,compensatedExcitForw,leftJawClosers,compensatedICPForw, outputFileName,'Ipsilateral Compensated');
                    set(ax,'xticklabel',[])
                    set(ax,'yticklabel',[])
                end
                if(i == 3 && ii == 1)
                    plotexcitations(t,compensatedExcitForw,rightJawClosers,compensatedICPForw, outputFileName,'Controlateral Compensated');
                    set(ax,'yticklabel',[])
                    xlabel(['Time [s]'])
                end
                
                % Column 2 - Jaw Elevators
                if(i == 2 && ii == 4)
                    plotexcitations(t,preopExcit,leftJawOpeners,goalICP,outputFileName,'Preop Excitations');
                    set(ax,'yticklabel',[])
                    set(ax,'xticklabel',[])

                end
                if(i == 2 && ii == 3)
                    plotexcitations(t,postopExcit,leftJawOpeners,postopICPForw,outputFileName,'Postop Excitations');
                    set(ax,'yticklabel',[])
                    set(ax,'xticklabel',[])

                end
                if(i == 2 && ii == 2)
                    plotexcitations(t,compensatedExcitForw,leftJawOpeners,compensatedICPForw, outputFileName,'Ipsilateral Compensated');
                    set(ax,'yticklabel',[])
                    set(ax,'xticklabel',[])

                end
                if(i == 2 && ii == 1)
                    plotexcitations(t,compensatedExcitForw,rightJawOpeners,compensatedICPForw, outputFileName,'Controlateral Compensated');
                    set(ax,'yticklabel',[])
                    xlabel(['Time [s]'])
                end
                
                % Column 3 - Trajectory Plots
                if(i == 1 && ii == 4)
                    plotincisorposition(goalICP,postopICPForw,compensatedICPForw,[0,0],['Fontal View']);
                    set(ax,'yticklabel',[])
                end
                if(i == 1 && ii == 3)
                    plotincisorposition(goalICP,postopICPForw,compensatedICPForw,[90,0],['Sagittal View']);
                    set(ax,'xticklabel',[])

                end
                if(i == 1 && ii == 2)
                    plotincisorposition(goalICP,postopICPForw,compensatedICPForw,[0,90],['Superior View']);
                    set(ax,'zticklabel',[])

                end
            end
            
            if ii==subplotsy
                if (i == 1)
                    title('Lower Mid Incisor Position');
                elseif (i == 2)
                    title('Jaw Elevators');
                    % title(['Post Op Muscle Excitations','(',muscleDeactivatedDescription,')']);
                elseif (i == 3)
                    title('Jaw Depressors');
                    % title(['Left Compensated Post Op Excitations','(',muscleDeactivatedDescription,')']);
                % elseif (i == 4)
                %     title(['Right Compensated Post Op Excitations','(',muscleDeactivatedDescription,')']);
                end
            end
        
            if i==3
                yyaxis right
                ylabel('Excitation [%]');
                set(gca,'ycolor','k') 
                
            end
            if i==1
                % reset(gca);
                xlabel('[mm]')
                % ax.ZAxisLocation = 'right';
                zlabel('[mm]');
                % ax.XAxisLocation = 'right';
                % ax.YAxisLocation = 'right';
                ylabel('[mm]');
            end
        end
    end
end
%Saving eps with matlab and then producing pdf and png with system commands
%If using windows or mac you need to download the MikTex commandline tool.
%https://miktex.org/download

fileName=['Excitations'];
saveas(gcf,[outputFileName,'/',fileName,'.pdf']);

% print(gcf, '-depsc2','-loose',[outputFileName,'/',fileName,'.eps']);
% system(['epstopdf ',outputFileName,'/',fileName,'.eps'])
% system(['convert -density 300 ',outputFileName,'/',fileName,'.eps',outputFileName,'/',fileName,'.png'])

