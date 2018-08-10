function [] = plotExcitations(excitM,randPertExcit,muscles,groupName,outputfilename,pertwindow,icp)
    %PLOTEXCITATIONS Summary of this function goes here
    %   Detailed explanation goes here
    desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
    ymin = -0.0001;
    ymax = 0.125;

    if exist('pertwindow','var')
        t0 = pertwindow(1,end);
        tf = pertwindow(end,end);
        windowdur = strcat(num2str((tf-t0)*1000)," ms");
    end

    if exist('icp','var')
        [maxNum maxIndex] = min(icp(:,4));
        tmaxopen = icp(maxIndex,1);
    end

    t = excitM(:,1);
    excitationsTemp = excitM(:,2:25);
    muscleids = cell2mat(muscles(1,:));
    musclelabels = string(muscles(2,:));
    excit = excitationsTemp(:,muscleids);

    if(randPertExcit == 0)
        mkdir(strcat(outputfilename,'\PreSimPlots'));
        h = figure('Visible','Off');
        for iFig = 1:length(muscleids)
            figH(iFig) = plot(t,excit(:,iFig),'LineWidth',1.2);
            hold on
            marker = plot(tmaxopen,excit(maxIndex,iFig),'mo','MarkerSize',4, 'MarkerFaceColor', 'm');
        end
        ymax = max(excit(:));
        if(ymax < 0.02)
            ylim([ymin 0.1]); 
        else
            ylim([ymin ymax]);    
        end

        xlabel('Time [s]'); 
        ylabel('Excitation [%]');
        legend([marker, figH],{'Jaw max opening',muscles{2,:}});
        vline([t0 tf],{'k','k'}, {'',strcat(windowdur," Pertubation")});
        title(groupName);    
        saveas(h,strcat(outputfilename, '\PreSimPlots\',groupName,'.pdf'));
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
                plot(tmaxopen,excit(maxIndex,j),'mo','MarkerSize',4, 'MarkerFaceColor', 'm');
                hold on
                vline([t0 tf],{'k','k'}, {'',strcat(windowdur," Pertubation")});
                ymax = max(excit(:,j));
                if(ymax < 0.02)
                    ylim([ymin 0.1]); 
                else
                    ylim([ymin ymax]);    
                end
                xlabel('Time [s]');
                ylabel('Excitation [%]');
                yyaxis right
                ylabel(musclelabels(j))
                legend('Pertubation','No Pertubation','Jaw max open');
                pause(0.02);
        end
    end
end

