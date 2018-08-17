function [simulationParamTableOut, statvarTableOut] = ...
    pertStudy(simDur,smoothExcitations,window,pertShape,...
			   muscles,pertModelType,forwardModelName,...
			   invModelName,pertShapeType,invICP,numSim,outputFileName);
%pertStudy 
% SUMMARY: 
% This function accepts all of the required paramters 
% to perform multiple forward chewing simulations. The excitation
% patterns for each specified muscle are calculated in the inverse 			  
% simulation, smoothed with a fast fourier transform and then used 
% to load the excitation patterns into the muscles specified in a 
% forward simulation.
%
% PARAMTERS:
% 	smoothExcitations = This parameter is a matrix that holds the 
%						calculated and signal smoothed excitations
%						from the inverse simulation in artisynth
%	window			  = 2D column matrix with pertubation window
%						time information. See createLocalPertWindow.
%	pertshape		  = 2D column matrix with rand pertubation 
%						magnitutdes. See createPertShape.
%	musclesMap		  = A Key, Value pair of simulation muscles. The keys 
%                       are the muscle codes and the values are integers 
%					    pertubations to.
%   pertModelType     = The type of pertubation model
%					    (additive or multplicative).
%   invICP 			  = A 4 column matrix with time and (x,y,z) position
%						of lower mid incisor from the inverse simulation.
%						used to check path deviation between forward and
%						inverse simulation.
%   numSim			  = The number of forward simulations to run.
% 
% RETURNS:
% statvarTableOut 		  =	IV and DV in a table for X simulations
% simulationParamTableOut = with all of the required parameters to run 
%							the specific simulation.		

dt = round(simDur/size(smoothExcitations,1),1,'significant');
t = [0:dt:simDur]';

%-------------------------OUTPUT DATA HEADERS------------------------------
statvarTableCol = {
				'Simulation' 
                'Pertt0'
				'PertICPX'     			
				'PertICPY'     			
				'PertICPZ'     			
				'PertICVX'     			
				'PertICVY'     			
				'PertICVZ'     		
				'PertAvgICAX'     			
				'PertAvgICAY'     			
				'PertAvgICAZ'
				'ICPX'     				
				'ICPY'     				
				'ICPZ'     				
				'ICVX'   				
				'ICVY'   				
				'ICVZ'   				
				'AvgICAX' 				
				'AvgICAY' 				
				'AvgICAZ'
				'lat' 
				'rat' 
				'lmt' 
				'rmt' 
				'lpt' 
				'rpt' 
				'lsm' 
				'rsm' 
				'ldm' 
				'rdm' 
				'lmp' 
				'rmp' 
				'lsp' 
				'rsp' 
				'lip' 
				'rip' 
				'lad' 
				'rad' 
				'lam' 
				'ram' 
				'lpm' 
				'rpm' 
				'lgh' 
				'rgh' 
			 }';
         
pertMagTableCol = {			   			 			 							   						
				'lat' 
				'rat' 
				'lmt' 
				'rmt' 
				'lpt' 
				'rpt' 
				'lsm' 
				'rsm' 
				'ldm' 
				'rdm' 
				'lmp' 
				'rmp' 
				'lsp' 
				'rsp' 
				'lip' 
				'rip' 
				'lad' 
				'rad' 
				'lam' 
				'ram' 
				'lpm' 
				'rpm' 
				'lgh' 
				'rgh' 
			 }';
			 
simulationParamTableCol = {
						'Simulation'					
						'SimDuration'     			
						'SimTimeStep'
						'InvSimName'     				
						'ForwardSimName'     			
						'PertShapeFunction'
						'PertModelType'
						't0Pert'     						
						'tfPert'    						
					   }';
			
				
			 
statvarTable = cell2table(cell(0,length(statvarTableCol)), 'VariableNames', statvarTableCol);
pertMagTable = cell2table(cell(0,length(pertMagTableCol)), 'VariableNames', pertMagTableCol);
simulationParamTable = cell2table(cell(0,length(simulationParamTableCol)), 'VariableNames', simulationParamTableCol);

%-------------------------FORWARD SIMULATIONS------------------------------
% SUMMARY OF SCRIPT:
% 1. run forward sim with no pertubation (Smooth signal)
% 2. Check that forward sim with no pertubation has path deviation < 1mm
%   a. if < 1mm error is acceptable and run bulk simulations
%   b. else warn user of error and ask if they would like to continue
% 3. Apply small pertubations to X foward simulation run with no
% perubations and save matrix.
% 4. Run X simulation with pertubation data X times and save output data
% after eack simulation has completed.

% Run forward simulation with smooth excitations and check that incisor 
% path error is less than 1mm in x,y, and z.
[icpFull,icvFull,excitationsFull] = ...
	forwardsim(simDur,forwardModelName,smoothExcitations,muscles);
	
maxPositionError = max(abs(icpFull(:,2:4)-icpFull(:,2:4)));

%Select position and velocity only within specified pertubation window
icp = icpFull(window(:,1),:);
icv = icvFull(window(:,1),:);
icv(:,2:4) = icv(:,2:4).*0.001; % Convert mm/s to m/s

%Calculate average acceleration within pertubation window
averageICA = (icv(end,2:4)-icv(1,2:4))/(icv(end,1)-icv(1,1));
save(strcat(outputFileName, '\excitations.mat'),'excitationsFull');

% Perform excitation analysis in window for pre simulation plots
perturbedExcitations = performexcitationanalysis(window,smoothExcitations,pertShape,muscles,pertModelType);

% Generate pre simulation plots
[maxNumInv maxIndexInv] = min(invICP(:,4));
[maxNumForw maxIndexForw] = min(icpFull(:,4));

%Estimate completion time and report to dialog
pertExcitationMagnitudes = zeros(numSim,24);
completionTime = 0.2 * numSim;

if(completionTime <= 60)
    unit = '[sec].';
elseif(completionTime > 60 && completionTime <= 3600)
    unit = '[min].';
    completionTime = (completionTime)/60;
elseif(completionTime > 3600 && completionTime < 86400)
    unit = '[hours].';
    completionTime = (completionTime)/3600;
elseif(completionTime >= 86400)
    unit = '[days].';
    completionTime = (completionTime)/86400;
end
	
if(window(1,2) == 0)
	% Frontal view on ICP
	figure;
		plot3(invICP(:,2),invICP(:,3),invICP(:,4),'LineWidth',1.2);
		view(0,0);
		hold on
		plot3(invICP(1,2),invICP(1,3),invICP(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
		hold on
		plot3(invICP(end,2),invICP(end,3),invICP(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
		hold on;
		plot3(invICP(maxIndexInv,2),invICP(maxIndexInv,3),maxNumInv,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
		hold on
		plot3(icpFull(:,2),icpFull(:,3),icpFull(:,4),'LineWidth',1.2);
		view(0,0);
		hold on
		plot3(icpFull(1,2),icpFull(1,3),icpFull(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
		hold on
		plot3(icpFull(end,2),icpFull(end,3),icpFull(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
		hold on
		plot3(icpFull(maxIndexForw,2),icpFull(maxIndexForw,3),maxNumForw,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
		legend('Inverse ICP', 'Inverse Initial ICP', 'Inverse Final ICP', 'Inv Max Opening ICP' ,'Forward ICP', 'Forward Initial ICP', 'Forward Final ICP', 'Forward Max Opening ICP');
		xlabel('X axis [mm]');
		zlabel('Z axis [mm]');
		title('Lower mid incisor path (Frontal View)');
		xlim([-0.25 0.25]); 
		saveas(gcf,strcat(outputFileName, '\FrontalView.png'));
	
	 % Transverse view on ICP
	figure;
		plot3(invICP(:,2),invICP(:,3),invICP(:,4),'LineWidth',1.2);
		view(90,0)  % YZ
		hold on
		plot3(invICP(1,2),invICP(1,3),invICP(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
		hold on
		plot3(invICP(end,2),invICP(end,3),invICP(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
		hold on
		plot3(invICP(maxIndexInv,2),invICP(maxIndexInv,3),maxNumInv,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
		hold on
		plot3(icpFull(:,2),icpFull(:,3),icpFull(:,4),'LineWidth',1.2);
		view(90,0)  % YZ
		hold on
		plot3(icpFull(1,2),icpFull(1,3),icpFull(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
		hold on
		plot3(icpFull(end,2),icpFull(end,3),icpFull(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
		hold on
		plot3(icpFull(maxIndexForw,2),icpFull(maxIndexForw,3),maxNumForw,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
		legend('Inverse ICP', 'Inverse Initial ICP', 'Inverse Final ICP', 'Inv Max Opening ICP' ,'Forward ICP', 'Forward Initial ICP', 'Forward Final ICP', 'Forward Max Opening ICP');
		ylabel('Y axis [mm]');
		zlabel('Z axis [mm]');
		title('Lower mid incisor path (Tansverse View)');
		saveas(gcf,strcat(outputFileName, '/TransverseView.png'));
        
    plotexcitations(t,smoothExcitations,muscles([20 21 22 23]),icpFull,outputFileName,"Excitations",perturbedExcitations,window);
    
	% Generate dialog to ask user if they want to procceed with know path deviation error
	question = sprintf(strcat('The max path deviation is: (%.2f, %.2f, %.2f) [mm] and the estimated completion time is %.2f ',unit,' Would you like to continue?'),...
		maxPositionError(1),maxPositionError(2),maxPositionError(3),completionTime);
	answer = questdlg(question,'Warning','Yes','No','No');
	% Handle response
	switch answer
	    case 'Yes'
		
	    case 'No'
	        simulationParamTableOut = 0;
	        statvarTableOut = 0;
	        error('Pertubation analysis aborted');
	end
end
 
% Start artisynth for pertubation analysis
ah = artisynth('-noGui','-model',forwardModelName);

% Fast forward to beginning of pertubation window
tElapsed = 0;
ah.clearWayPoints();
ah.addBreakPoint(min(window(:,2)));
ah.addBreakPoint(max(window(:,2)));

if(min(window(:,2)) > 0)
    ah.play();
    ah.waitForStop();
end

% display(ah.getTime());
% Loop small pertubation for x simulations
% start total time clock
tStart = tic;
f = waitbar(0,'','Name','Pertubation Analysis...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
count = 0;	
for i = 1:numSim

    % Check for clicked Cancel button
    if(getappdata(f,'canceling'))
        break
    end
	
	% Start single sim timer
    tic
	
	% Perform small pertubation and load muscle input probes
    [perturbedExcitations,...
        pertExcitMuscleMags] = performexcitationanalysis(window,smoothExcitations,pertShape,muscles,pertModelType);
    
    pertMagTable = [pertMagTable;num2cell(pertExcitMuscleMags)];
	
	for m = 1:length(muscles)
        probeLabel = muscles(m).probeLabel;
        muscleId = muscles(m).id;
        ah.setIprobeData (probeLabel, horzcat(t,perturbedExcitations(:,muscleId)));
	end
    
	% Run simulation for duration of pertubation window
    ah.play();
    ah.waitForStop();

    pertICP = ah.getOprobeData('incisor_position'); 
    pertICV = ah.getOprobeData('incisor_velocity'); %m/s
    
    pertICP = pertICP(window(:,1),:);
    pertICV = pertICV(window(:,1),:);
    pertICV(:,2:4) = 0.001.*pertICV(:,2:4);
 
	% Calculate Average ICP Acceleration a(t) = (v(tf)-v(t0))/(tf - t0)
	pertAverageICA = (pertICV(end,2:4)-pertICV(1,2:4))/(pertICV(end,1)-pertICV(1,1));
    
	% Log all variables from simulation
    Simulation					= i;
    Pertt0                      = min(window(:,2));
    SimDuration     			= max(perturbedExcitations(:,1));
    SimTimeStep     			= perturbedExcitations(2,1) - perturbedExcitations(1,1);
    InvSimName     				= invModelName;
    ForwardSimName     			= forwardModelName;
    PertShapeFunction     		= pertShapeType;
	PertModelType				= pertModelType;
    t0Pert     					= min(window(:,2));
    tfPert     					= max(window(:,2));
    PertWindowICPX     			= pertICP(end,2);
    PertWindowICPY     			= pertICP(end,3);
    PertWindowICPZ     			= pertICP(end,4);
    PertWindowICVX     			= pertICV(end,2);
	PertWindowICVY     			= pertICV(end,3);
	PertWindowICVZ     		    = pertICV(end,4);
	PertWindowICAX     			= pertAverageICA(1);
	PertWindowICAY     			= pertAverageICA(2);
	PertWindowICAZ     			= pertAverageICA(3);
	WindowICPX     				= icp(end,2);
	WindowICPY     				= icp(end,3);
	WindowICPZ     				= icp(end,4);
	WindowICVX     				= icv(end,2);
	WindowICVY     				= icv(end,3);
	WinMaxICVZ     				= icv(end,4);
	WindowICAX     				= averageICA(1);
	WindowICAY     				= averageICA(2);
	WindowICAZ     				= averageICA(3);
	ladPertExcit				= pertExcitMuscleMags(1);	   
	lipPertExcit				= pertExcitMuscleMags(2);	   
	lspPertExcit				= pertExcitMuscleMags(3);	   
	lamPertExcit				= pertExcitMuscleMags(4);	   
	lghPertExcit				= pertExcitMuscleMags(5);	   
	latPertExcit				= pertExcitMuscleMags(6);	   
	lmtPertExcit				= pertExcitMuscleMags(7);	   
	lpmPertExcit				= pertExcitMuscleMags(8);	   
	lptPertExcit				= pertExcitMuscleMags(9);	   
	ldmPertExcit				= pertExcitMuscleMags(10);	   
	lsmPertExcit				= pertExcitMuscleMags(11);	   
	lmpPertExcit				= pertExcitMuscleMags(12);	   
	radPertExcit				= pertExcitMuscleMags(13);	   
	ripPertExcit				= pertExcitMuscleMags(14);	   
	rspPertExcit				= pertExcitMuscleMags(15);	   
	ramPertExcit				= pertExcitMuscleMags(16);	   
	rghPertExcit				= pertExcitMuscleMags(17);	   
	ratPertExcit				= pertExcitMuscleMags(18);	   
	rmtPertExcit				= pertExcitMuscleMags(19);	   
	rpmPertExcit				= pertExcitMuscleMags(20);	   
	rptPertExcit				= pertExcitMuscleMags(21);	   
	rdmPertExcit				= pertExcitMuscleMags(22);	   
	rsmPertExcit				= pertExcitMuscleMags(23);	   
	rmpPertExcit				= pertExcitMuscleMags(24);	   
	
	% Save simulation parameters to row vector
	simulationparameters = {  Simulation					
							  SimDuration     			
							  SimTimeStep
							  InvSimName     				
							  ForwardSimName     			
							  PertShapeFunction
							  PertModelType
							  t0Pert     						
							  tfPert     						 		
						    }';  
	
	% Save IVs and DVs to row vector	
	statparameters = {  Simulation
                        Pertt0
						PertWindowICPX     			
						PertWindowICPY     			
						PertWindowICPZ     			
						PertWindowICVX     			
						PertWindowICVY     			
						PertWindowICVZ     		
						PertWindowICAX     			
						PertWindowICAY     			
						PertWindowICAZ
						WindowICPX     				
						WindowICPY     				
						WindowICPZ     				
						WindowICVX     				
						WindowICVY     				
						WinMaxICVZ     				
						WindowICAX     				
						WindowICAY     				
						WindowICAZ
						ladPertExcit   
						lipPertExcit   
						lspPertExcit   
						lamPertExcit   
						lghPertExcit   
						latPertExcit   
						lmtPertExcit   
						lpmPertExcit   
						lptPertExcit   
						ldmPertExcit   
						lsmPertExcit   
						lmpPertExcit   
						radPertExcit   
						ripPertExcit   
						rspPertExcit   
						ramPertExcit   
						rghPertExcit   
						ratPertExcit   
						rmtPertExcit   
						rpmPertExcit   
						rptPertExcit   
						rdmPertExcit   
						rsmPertExcit   
						rmpPertExcit   
					}'; 
					
	% Append row to simulationParamTable and statvarTable
	simulationParamTable = [simulationParamTable;simulationparameters];
	statvarTable = [statvarTable;statparameters];
	
	% Updated estimated simulation completion time 
   tSim = toc;
   tElapsed = toc(tStart);
   estTime = (tElapsed/i)*(numSim-i); 
   
   if(i == 1)
        fprintf('Begining pertubation analysis...\nEstimated time to complete = %.2f %s\n'...
        ,completionTime,unit);
    end
    
    if(estTime <= 60)
        unit = '[sec]';
        timeRemaining = (tElapsed/i)*(numSim-i);
    elseif(estTime > 60 && estTime <= 3600)
        unit = '[min]';
        timeRemaining = ((tElapsed/i)*(numSim-i))/60;
    elseif(estTime > 3600 && estTime < 86400)
        unit = '[hours]';
        timeRemaining = ((tElapsed/i)*(numSim-i))/3600;
    elseif(estTime >= 86400)
        unit = '[days]';
        timeRemaining = ((tElapsed/i)*(numSim-i))/86400;
    end
    
    % Update waitbar and message
    waitbar(i/numSim,f,sprintf(strcat('Simulation Progress: %.2f%%\nTime remaining = %.2f ', unit),...
        (i/numSim)*100,timeRemaining));
    
	% rewind simulation if we are doing more than 1
	% else end artisynth session
    if(numSim > 1)
        ah.rewind();
    else
		ah.quit();
    end
    
    if ~(mod(i,10000))
        if(i == 10000)
            fid = fopen(strcat(outputFileName,"/statvarTable.txt"),"wt");
            statvarheader = strings(size(statvarTableCol));
            [statvarheader{:}] = statvarTableCol{:};
            fprintf(fid, "%s,",statvarheader{1:end-1});
            fprintf(fid, "%s\n",statvarheader{end});
            dlmwrite(strcat(outputFileName,'/statvarTable.txt'),table2array(statvarTable),'-append','delimiter',',' ); 
            statvarTable(:,:) = [];
            fclose(fid);           
            
            fid = fopen(strcat(outputFileName,"/pertMagTable.txt"),"wt");
            pertmagheader = strings(size(pertMagTableCol));
            [pertmagheader{:}] = pertMagTableCol{:};
            fprintf(fid, "%s,",pertmagheader{1:end-1});
            fprintf(fid, "%s\n",pertmagheader{end});
            dlmwrite(strcat(outputFileName,'/pertMagTable.txt'),table2array(pertMagTable),'-append','delimiter',',' ); 
            pertMagTable(:,:) = [];
            fclose(fid);
        else
           dlmwrite(strcat(outputFileName,'/statvarTable.txt'),table2array(statvarTable),'-append','delimiter',',' ); 
           dlmwrite(strcat(outputFileName,'/pertMagTable.txt'),table2array(pertMagTable),'-append','delimiter',',' ); 
           statvarTable(:,:) = [];
           pertMagTable(:,:) = [];
        end
    end
end
	
	% kill dialog and quit artisynth
    delete(f);
    ah.quit();
    
    if(tElapsed <= 60)
        unit = '[s]\n';
    elseif(tElapsed > 60 && tElapsed <= 3600)
        unit = '[mins]\n';
        tElapsed = (tElapsed)/60;
    elseif(tElapsed > 3600 && tElapsed < 86400)
        unit = '[hrs]\n';
        tElapsed = (tElapsed)/3600;
    elseif(tElapsed >= 86400)
        unit = '[days]\n';
        tElapsed = (tElapsed)/86400;
    end
    
    s = sprintf('Total simulation time = %.2f ', tElapsed);
    fprintf(strcat(s,unit));
    
    if (numSim < 10000)
        writetable(statvarTable,strcat(outputFileName,'/statvarTable.txt'),'Delimiter',',');  
        writetable(pertMagTable,strcat(outputFileName,'/pertMagTable.txt'),'Delimiter',',');
    end
    writetable(simulationParamTable,strcat(outputFileName,'/simulationParamTable.txt'),'Delimiter',',');
    
    % Return key data tables
    simulationParamTableOut = simulationParamTable;
	statvarTableOut = statvarTable;
end