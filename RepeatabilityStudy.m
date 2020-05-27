%-------------------------------SUMMARY------------------------------------
% This script generates inverse and forward excitation plots for each group
% of muscles pre and post op. The excitations signals are collected for the
% target trajectory of the the jaw in an inverse simulation, those signals
% are then smoothed and plotted. The smooth signals are used to drive the 
% forward simulations.

% Refer to the muscle.txt which has all of the muscle definitions. To select
% muscle to remove from the chewing simulation take note of the number code and
% select them from the muscles struct. An example of three deferent cases are
% are shown below in the MUSCLES TO DEACTIVATE section below.

%-------------------------SCRIPT DEFINITIONS------------------------------  
simDur  = 0.75;
dt = 0.001;
t = [0:dt:simDur];
debug = 0; % stops sim before run in artisnyth to view.
%-------------------------MUSCLE DEFINITIONS------------------------------  
muscles = createmusclestruct('Muscle Info\musclekey.csv'); 

% Masseter, Medial Pterygoid, and Temporalis
rightJawOpeners = muscles([1 3 5 7 9 11]);
leftJawOpeners = muscles([2 4 6 8 10 12]);
jawOpeners = muscles([1 2 3 4 5 6 7 8 9 10 11 12]);

% Digastricus, Geniohyoid, Lateral pterygoid, Mylohyoid
rightJawClosers = muscles([13 15 17 19 21 23]);
leftJawClosers = muscles([14 16 18 20 22 24]);
jawClosers = muscles([13 14 15 16 17 18 19 20 21 22 23 24]);

musclesToDeactivate = muscles([])
%***********SIMULATION OUTPUT OPTIONS ------------------------------------

designer = '0';
operation = 'Test';
path = 'C:\develop\matlab\chewing-pertubation\Results\'
outputFileName = strcat('Designer_', designer,'_', operation,'_', 'Result')
fullpath = strcat(path,outputFileName)
mkdir(fullpath);

targetdatapath = strcat('C:\develop\artisynth\Patient Data\lowerincisor_position_des',designer,'.txt')

plotTitle = strcat('Designer ', designer, ' Jaw Model Trajectory and Muscle Excitations');

%-------------------------ARTISYNTH MODEL NAMES---------------------------
invModelName = ...
    'artisynth.models.irsm.jawsurgery.JawModelInverse';
forwardModelName = ...
    'artisynth.models.irsm.jawsurgery.JawModelForward';

%-------------------------------SIMULATION ORDER------------------------------
[invExcitations,invICP,invICV] = ...
    inversesim(t,invModelName,targetdatapath,musclesToDeactivate,debug);

[frwICP,frwICV,frwExcit] = ...
	forwardsim(t,forwardModelName,invExcitations,musclesToDeactivate,debug);

% csvwrite(strcat(fullpath,'\invSmoothExcit_',operation,'_Designer_',designer,'.csv'),invExcit);
% csvwrite(strcat(fullpath,'\invICP_',operation,'_Designer_',designer,'.csv'),invICP);
% csvwrite(strcat(fullpath,'\frwExcitations_',operation,'_Designer_',designer,'.csv'),frwExcit);
% csvwrite(strcat(fullpath,'\frwICP_',operation,'_Designer_',designer,'.csv'),frwICP);

%---------------------------EXCITATION PLOTS--------------------------------
for iplot= 1:1
    %parameters for figure and panel size
    plotheight=24.1;
    plotwidth=17.7;
    subplotsx=5;
    subplotsy=2;   
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
    
%     loop to create axes
    for i=1:subplotsx
        for ii=1:subplotsy
            ax=axes('position',sub_pos{i,ii},'XGrid','off','XMinorGrid','off','FontSize',6,'Box','on','Layer','top');
            if(iplot == 1)
      
                % Column 1 - Trajectory Plots -----------------------------
                if(i == 1 && ii == 2)
                    plotincisorposition(frwICP,frwICP,frwICP,[0,0],['Fontal View (Forward)']);
%                     set(ax,'xticklabel',[])
%                     set(ax,'yticklabel',[])

                end
                if(i == 1 && ii == 1)
                    plotincisorposition(invICP,invICP,invICP,[0,0],['Fontal View (Inverse)']);
%                     set(ax,'xticklabel',[])
%                     set(ax,'yticklabel',[])

                end
                
                % Column 2 - Right Jaw Elevators --------------------------
                if(i == 2 && ii == 2)
                    plotexcitations(t,frwExcit,rightJawOpeners,frwICP,outputFileName,'Forward Excitations');
                    set(ax,'yticklabel',[])
                    set(ax,'xticklabel',[])

                end
                if(i == 2 && ii == 1)
                    plotexcitations(t,invExcitations,rightJawOpeners,invICP,outputFileName,'Inverse Excitations');
                    set(ax,'yticklabel',[])
                    set(ax,'xticklabel',[])

                end
                
                % Column 3 - Left Jaw Elevators ---------------------------
                if(i == 3 && ii == 2)
                    plotexcitations(t,frwExcit,leftJawOpeners,frwICP,outputFileName,'Forward Excitations');
                    set(ax,'yticklabel',[])
                    set(ax,'xticklabel',[])

                end
                if(i == 3 && ii == 1)
                    plotexcitations(t,invExcitations,leftJawOpeners,invICP,outputFileName,'Inverse Excitations');
                    set(ax,'yticklabel',[])
                    set(ax,'xticklabel',[])

                end
                
                % Column 4 - Left Jaw Depressors --------------------------
                if (i == 4 && ii == 2)
                    plotexcitations(t,frwExcit,leftJawClosers,frwICP, outputFileName,'Forward Excitations');
                    set(ax,'xticklabel',[])
                    set(ax,'yticklabel',[])
                end
                if(i == 4 && ii == 1)
                    plotexcitations(t,invExcitations,leftJawClosers,invICP, outputFileName,'Inverse Excitations');
                    set(ax,'xticklabel',[])
                    set(ax,'yticklabel',[])
                end
                
                 % Column 5 - Right Jaw Depressors -------------------------
                if (i == 5 && ii == 2)
                    plotexcitations(t,frwExcit,rightJawClosers,frwICP, outputFileName,'Forward Excitations');
                    set(ax,'xticklabel',[])
                    set(ax,'yticklabel',[])
                end
                if(i == 5 && ii == 1)
                    plotexcitations(t,invExcitations,rightJawClosers,invICP, outputFileName,'Inverse Excitations');
                    set(ax,'xticklabel',[])
                    set(ax,'yticklabel',[])
                end
            end
            
            if ii==subplotsy
                if (i == 1)
                    title('Lower Mid Incisor Position');
                elseif (i == 2)
                    title('Left Jaw Elevators');
                elseif (i == 3)
                    title('Right Jaw Elevators');                
                elseif (i == 4)
                    title('Left Jaw Depressors');
                elseif (i == 5)
                    title('Right Jaw Depressors');
                end
            end
        
            if i==5
                yyaxis right
                ylabel('Excitation [%]');
                set(gca,'ycolor','k') 
                
            end
            if i==1
                xlabel('[mm]')
                 zlabel('[mm]');
                ylabel('[mm]');
            end
        end
    end
    annotation('textbox', [0 0.9 1 0.1], ...
    'String', plotTitle, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')
end

savefig(strcat(fullpath,'\ExcitationPlot_',operation,'_Designer_',designer,'.fig'));

% %Saving eps with matlab and then producing pdf and png with system commands
% %If using windows or mac you need to download the MikTex commandline tool.
% %https://miktex.org/download
% 
% fileName=['Excitations'];
% saveas(gcf,[outputFileName,'/',fileName,'.pdf']);

% print(gcf, '-depsc2','-loose',[outputFileName,'/',fileName,'.eps']);
% system(['epstopdf ',outputFileName,'/',fileName,'.eps'])
% system(['convert -density 300 ',outputFileName,'/',fileName,'.eps',outputFileName,'/',fileName,'.png'])

