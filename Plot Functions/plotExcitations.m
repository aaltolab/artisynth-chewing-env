function [] = ...
    plotExcitations(t,excitM,muscles,icp,outputFileName,groupName,randPertExcit,pertWindow)
    % SUMMARY: 
    % This function accepts all of the required parameters 
    % to perform multiple forward chewing simulations. The excitation
    % patterns for each specified muscle are calculated in the inverse 			  
    % simulation, smoothed with a fast fourier transform and then used 
    % to load the excitation patterns into the muscles specified in a 
    % forward simulation.
    %
    % PARAMETERS:
    % 	t                   = plotting time (sim duration)
    %	excitM              = excitations to be selected from for plotting
    %	
    %	muscles		        = muscles to be plotted					
    %	icp		            = used to extract the max time position 
    %   outputFileName      = file to save plots to
    %   groupName 			= muscles to plot together and their name
    %   randPertExcit		= option for plotting excitation signal against
    %                       = the perturbed signal
    %   pertWindow			= window of perturbation 

    yMin = -0.0001;
    yMax = 0.125;

    muscleIds = cell2mat({muscles.id});
    muscleLabels = string({muscles.name});
    excit = excitM(:,muscleIds);
    [maxNum maxIndex] = min(icp(:,4));
    tMaxOpen = icp(maxIndex,1);

    if (exist('pertWindow','var') && exist('randPertExcit','var') && exist('groupName','var'))
        t0 = pertWindow(1,end);
        tf = pertWindow(end,end);
        windowDur = strcat(num2str((tf-t0)*1000)," ms");

        pertExcit = randPertExcit(:,muscleIds);
        figure;
        title(groupName);    
        for j = 1:length(muscleIds)
            subplot(length(muscleIds),1,j)
                plot(t,pertExcit(:,j),'r','LineWidth',1.2);
                hold on
                ylim([yMin yMax]); 
                plot(t,excit(:,j),'b','LineWidth',1.2);
                hold on
                plot(tMaxOpen,excit(maxIndex,j),'mo','MarkerSize',4, 'MarkerFaceColor', 'm');
                hold on
                vline([t0 tf],{'k','k'}, {'',strcat(windowDur," Perturbation")});
                yMax = max(excit(:,j));
                if(yMax < 0.02)
                    ylim([yMin 0.1]); 
                else
                    ylim([yMin yMax]);    
                end
                xlabel('Time [s]');
                ylabel('Excitation [%]');
                yyaxis right
                ylabel(muscleLabels(j))
                legend('Perturbation','No Perturbation','Jaw max open');
                pause(0.02);
        end
        saveas(gcf,strcat(outputFileName, '/ExcitationExample.png'));
    else
        mkdir(strcat(outputFileName,'\Excitation Plots'));
        h = figure('Visible','Off');
        for iFig = 1:length(muscleIds)
            figH(iFig) = plot(t,excit(:,iFig),'LineWidth',1.2);
            hold on
            marker = plot(tMaxOpen,excit(maxIndex,iFig),'mo','MarkerSize',4, 'MarkerFaceColor', 'm');
        end
        yMax = max(excit(:));
        if(yMax < 0.02)
            ylim([yMin 0.1]); 
        else
            ylim([yMin yMax]);    
        end

        xlabel('Time [s]'); 
        ylabel('Excitation [%]');
        legend([marker, figH],{'Jaw max opening',muscles{2,:}});
        vline([t0 tf],{'k','k'}, {'',strcat(windowDur," Perturbation")});
        title(groupName);    
        saveas(h,strcat(outputFilename,'\Excitation Plots',groupName,'.pdf'));
    end
end

