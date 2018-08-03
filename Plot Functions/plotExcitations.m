function [] = plotExcitations(excitM,randPertExcit,muscles,groupName,outputfilename,pertwindow)
%PLOTEXCITATIONS Summary of this function goes here
%   Detailed explanation goes here
desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
ymin = -0.0001;
ymax = 0.1;

if exist('pertwindow','var')
    t0 = pertwindow(1,end);
    tf = pertwindow(end,end);
else
    t0 = 0;
    tf = 0;
end

t = excitM(:,1);
excitationsTemp = excitM(:,2:25);
muscleids = cell2mat(muscles(1,:));
musclelabels = string(muscles(2,:));
excit = excitationsTemp(:,muscleids);

if(randPertExcit == 0)
    myGroup = desktop.addGroup('myGroup');
    desktop.setGroupDocked('myGroup', 0);
    myDim   = java.awt.Dimension(4, 2);   % 4 columns, 2 rows
    % 1: Maximized, 2: Tiled, 3: Floating
    mkdir(strcat(outputfilename,'\PreSimPlots\',groupName));
    desktop.setDocumentArrangement('myGroup', 2, myDim)
    figH    = gobjects(1, length(muscleids));
    bakWarn = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    for iFig = 1:length(muscleids)
        figH(iFig) = figure('Visible','Off','WindowStyle', 'docked', ...
        'Name', sprintf('Figure %d', iFig), 'NumberTitle', 'off');
        drawnow;
        set(get(handle(figH(iFig)), 'javaframe'), 'GroupName', groupName);
        plot(t,excit(:,iFig),'b','LineWidth',1.2);
        hold on
        plot(t0,excit(pertwindow(1,1),iFig),'rv','MarkerSize', 9, 'MarkerFaceColor', 'r')
        hold on
        plot(tf,excit(pertwindow(end,1),iFig),'rv','MarkerSize',9, 'MarkerFaceColor', 'r')
        ylim([ymin ymax]); 
        xlabel('Time [s]');
        ylabel('Excitation [%]');
        legend('Excitation','Pertubation Window');
        title(musclelabels(iFig));
        saveas(gcf,strcat(outputfilename, '\PreSimPlots\',groupName,'\',musclelabels(iFig),'.png'));
        pause(0.02);% Magic, reduces rendering errors
    end
    warning(bakWarn);
else
    pertExcit = randPertExcit(:,muscleids);
    figure;
    title('Pertubation Excitation Example');    
    for j = 1:length(muscleids)
        subplot(length(muscleids),1,j)
            plot(t,pertExcit(:,j),'r','LineWidth',1.2);
            hold on
            ylim([ymin ymax]); 
            plot(t,excit(:,j),'b','LineWidth',1.2);
            hold on
            plot(t0,excit(pertwindow(1,1),j),'rv','MarkerSize', 9, 'MarkerFaceColor', 'r')
            hold on
            plot(tf,excit(pertwindow(end,1),j),'rv','MarkerSize',9, 'MarkerFaceColor', 'r')
            ylim([ymin ymax]); 
            xlabel('Time [s]');
            ylabel('Excitation [%]');
            yyaxis right
            ylabel(musclelabels(j))
            legend('Pertubation','No Pertubation','Pertubation Window');
            hold on

    end
end
end

%     hyiodGroup = desktop.addGroup('hyiodGroup');
%     desktop.setGroupDocked('hyiodGroup', 0);
%     myDim   = java.awt.Dimension(4, 2);   % 4 columns, 2 rows
%     % 1: Maximized, 2: Tiled, 3: Floating
%     desktop.setDocumentArrangement('hyiodGroup', 2, myDim)
%     figH    = gobjects(1, length(muscleids));
%     bakWarn = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%     for iFig = 1:length(muscleids)
%         figH(iFig) = figure('WindowStyle', 'docked', ...
%         'Name', sprintf('Figure %d', iFig), 'NumberTitle', 'off');
%         drawnow;
%         pause(0.02);  % Magic, reduces rendering errors
%         set(get(handle(figH(iFig)), 'javaframe'), 'GroupName', 'myGroup');
%         plot(t,excit(:,iFig),'b','LineWidth',1.2);
%     end
%     warning(bakWarn);

