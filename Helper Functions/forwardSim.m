function [simulationParamTableOut, statvarTableOut] = ...
    forwardSim(smoothExcitations,window,pertshape,...
			   muscles,pertModelType,forwardModelName,...
			   invModelName,pertShapeType,invICP,numSim);
%forwardSim 
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
%	muscles			  = A 1D row vecotor with all muscles to perform
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

%-------------------------MUSCLE DEFINITIONS------------------------------
lad     =  'Left Anterior Digastric';
lip     =  'Left Inferior Lateral Pterygoid';
lsp     =  'Left Superior Lateral Pterygoid';
lam     =  'Left Anterior Mylohyoid';
lgh     =  'Left Geniohyoid';
lpd     =  'Left Posterior Digastric';
lsh     =  'Left Stylohyoid';
lsth    =  'Left Sternohyoid' ;
lat     =  'Left Anterior Temporal';
lmt     =  'Left Middle Temporal';
lpm     =  'Left Posterior Mylohyoid';
lpt     =  'Left Posterior Temporal';
ldm     =  'Left Deep Masseter';
lsm     =  'Left Superficial Masseter';
lmp     =  'Left Medial Pterygoid';
rad     =  'Right Anterior Digastric';
rip     =  'Right Inferior Lateral Pterygoid';
rsp     =  'Right Superior Lateral Pterygoid';
ram     =  'Right Anterior Mylohyoid';
rgh     =  'Right Geniohyoid';
rpd     =  'Right Posterior Digastric';
rsh     =  'Right Stylohyoid';
rsteh   =  'Right Sternohyoid';
rat     =  'Right Anterior Temporal';
rmt     =  'Right Middle Temporal';
rpm     =  'Right Posterior Mylohyoid';
rpt     =  'Right Posterior Temporal';
rdm     =  'Right Deep Masseter';
rsm     =  'Right Superficial Masseter';
rmp     =  'Right Medial Pterygoid';					

t = smoothExcitations(:,1,1);
simTime = max(t);

% Setting to 1 will write to artisynth probe files. Must change path to location 
% of files in artisynth model.
writetoartisynth = 0; 
%-------------------------OUTPUT DATA HEADERS------------------------------
statvarTableCol = {
				'Simulation' 				   			 			 							   						
				'PertWindowICPXmm'     			
				'PertWindowICPYmm'     			
				'PertWindowICPZmm'     			
				'PertWindowICVXm_s'     			
				'PertWindowICVYm_s'     			
				'PertWindowICVZm_s'     		
				'PertAvgWindowICAXm_s2'     			
				'PertAvgWindowICAYm_s2'     			
				'PertAvgWindowICAZm_s2'
				'WindowICPXmm'     				
				'WindowICPYmm'     				
				'WindowICPZmm'     				
				'WindowICVXm_s'   				
				'WindowICVYm_s'   				
				'WinMaxICVZm_s'   				
				'WindowAvgICAXm_s2' 				
				'WindowAvgICAYm_s2' 				
				'WindowAvgICAZm_s2'
				'ladPertExcit' 
				'lipPertExcit' 
				'lspPertExcit' 
				'lamPertExcit' 
				'lghPertExcit' 
				'latPertExcit' 
				'lmtPertExcit' 
				'lpmPertExcit' 
				'lptPertExcit' 
				'ldmPertExcit' 
				'lsmPertExcit' 
				'lmpPertExcit' 
				'radPertExcit' 
				'ripPertExcit' 
				'rspPertExcit' 
				'ramPertExcit' 
				'rghPertExcit' 
				'ratPertExcit' 
				'rmtPertExcit' 
				'rpmPertExcit' 
				'rptPertExcit' 
				'rdmPertExcit' 
				'rsmPertExcit' 
				'rmpPertExcit' 
			 }';
			 
simulationParamTableCol = {
						'Simulation'					
						'SimDuration'     			
						'SimTimeStep'
						'Muscles'
						'InvSimName'     				
						'ForwardSimName'     			
						'PertShapeFunction'
						'PertModelType'
						't0Pert'     						
						'tfPert'    						
						'PertExcitationFilePath'     	  				
						'ExcitationFilePath' 
					   }';
			
				
			 
statvarTable = cell2table(cell(0,length(statvarTableCol)), 'VariableNames', statvarTableCol);
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

ah = artisynth('-noGui','-model',forwardModelName);

ah.setIprobeData (lat  ,horzcat(t,smoothExcitations(:,2)));
ah.setIprobeData (rat  ,horzcat(t,smoothExcitations(:,3)));
ah.setIprobeData (lmt  ,horzcat(t,smoothExcitations(:,4)));
ah.setIprobeData (rmt  ,horzcat(t,smoothExcitations(:,5)));
ah.setIprobeData (lpt  ,horzcat(t,smoothExcitations(:,6)));
ah.setIprobeData (rpt  ,horzcat(t,smoothExcitations(:,7)));
ah.setIprobeData (lsm  ,horzcat(t,smoothExcitations(:,8)));
ah.setIprobeData (rsm  ,horzcat(t,smoothExcitations(:,9)));
ah.setIprobeData (ldm  ,horzcat(t,smoothExcitations(:,10)));
ah.setIprobeData (rdm  ,horzcat(t,smoothExcitations(:,11)));
ah.setIprobeData (lmp  ,horzcat(t,smoothExcitations(:,12)));
ah.setIprobeData (rmp  ,horzcat(t,smoothExcitations(:,13)));
ah.setIprobeData (lsp  ,horzcat(t,smoothExcitations(:,14)));
ah.setIprobeData (rsp  ,horzcat(t,smoothExcitations(:,15)));
ah.setIprobeData (lip  ,horzcat(t,smoothExcitations(:,16)));
ah.setIprobeData (rip  ,horzcat(t,smoothExcitations(:,17)));
ah.setIprobeData (lad  ,horzcat(t,smoothExcitations(:,18)));
ah.setIprobeData (rad  ,horzcat(t,smoothExcitations(:,19)));
ah.setIprobeData (lam  ,horzcat(t,smoothExcitations(:,20)));
ah.setIprobeData (ram  ,horzcat(t,smoothExcitations(:,21)));
ah.setIprobeData (lpm  ,horzcat(t,smoothExcitations(:,22)));
ah.setIprobeData (rpm  ,horzcat(t,smoothExcitations(:,23)));
ah.setIprobeData (lgh  ,horzcat(t,smoothExcitations(:,24)));
ah.setIprobeData (rgh  ,horzcat(t,smoothExcitations(:,25))); 

ah.play(simTime);
printed = 0;  % 1 = true and 0 = false
while(ah.isPlaying())     
    if (ah.getTime() == 0.25*simTime)
        if (printed == 0)
            disp('Checking forward simulation error');
            disp('25% Complete');
        end
        printed = 1;
    end
    if (ah.getTime() == 0.5*simTime) 
        if (printed == 1)
            disp('50% Complete');
        end
        printed = 0;
    end 
    if (ah.getTime() == 0.75*simTime)
        if (printed == 0)
            disp('75% Complete');
        end
        printed = 1;
    end
    if (ah.getTime() == simTime)
        if (printed == 1)
            disp('100% Complete');
            printed = 0;
        end
    end 
end

% Check incisor path deviation is less that 1mm
icpFull = ah.getOprobeData('incisor_position');
MaxPositionError = max(abs(invICP(:,2:4)-icpFull(:,2:4)));

% No Pertubations
icvFull = ah.getOprobeData('incisor_velocity');
icaFull = 0;
excitationsFull = ah.getOprobeData('excitations');

%Select position and velocity only within specified pertubation window
icp = icpFull(window(:,1),:);
icv = icvFull(window(:,1),:);
icv(:,2:4) = icv(:,2:4).*0.001; % Convert mm/s to m/s

%Calculate average acceleration within pertubation window
averageica = (icv(end,2:4)-icv(1,2:4))/(icv(end,1)-icv(1,1));
excitations = ah.getOprobeData('excitations');
save('Output\excitations.mat','excitations');

ah.quit();

% Perform excitation analysis in window for pre simulation plots
perturbedExcitations = performExcitationAnalysis(window,smoothExcitations,pertshape,muscles,pertModelType);

% Generate pre simulation plots
% Frontal view on ICP
figure(1);
 plot3(invICP(:,2),invICP(:,3),invICP(:,4));
 view(0,0);
 hold on
 plot3(icpFull(:,2),icpFull(:,3),icpFull(:,4));
 view(0,0);
 legend('inverse ICP', 'forwardICP');
 xlabel('X axis [mm]');
 zlabel('Z axis [mm]');
 title('Lower mid incisor path (Frontal View)');
 xlim([-0.5 0.5]); 
 saveas(gcf,'Output/FrontalView.png')
 
 % Transverse view on ICP
figure(2);
 plot3(invICP(:,2),invICP(:,3),invICP(:,4));
 view(90,0)  % YZ
 hold on
 plot3(icpFull(:,2),icpFull(:,3),icpFull(:,4));
 view(90,0)  % YZ
 legend('inverse ICP', 'forwardICP');
 ylabel('Y axis [mm]');
 zlabel('Z axis [mm]');
 title('Lower mid incisor path (Tansverse View)');
 xlim([-0.5 0.5]);
 saveas(gcf,'Output/TransverseView.png')

% Muscle excitation example
plotExcitations(smoothExcitations,perturbedExcitations, 1, [16,17,23]);
saveas(gcf,'Output/ExcitationExample.png')
spreadfigures();

%Estimate completion time and report to dialog
pertExcitationMagitudes = zeros(numSim,24);
completionTime = 0.35 * numSim;

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
	

% Generate dialog to ask user if they want to procceed with know path deviation error
question = sprintf(strcat('The max path deviation is: (%.2f, %.2f, %.2f) [mm] and the estimated completion time is %.2f ',unit,' Would you like to continue?'),...
    MaxPositionError(1),MaxPositionError(2),MaxPositionError(3),completionTime);
answer = questdlg(question, ...
	'Warning',...
    	'Yes','No','No');
% Handle response
switch answer
    case 'Yes'
        completetime = (0.35 * numSim);
        fprintf('Begining pertubation analysis...\nEstimated time to complete = %.2f [s]\n'...
            ,completetime);
    case 'No'
        simulationDataTableOut = 0;
        disp('Pertubation analysis aborted');
        return;
end
 
% Start artisynth for pertubation analysis
ah = artisynth('-noGui','-model',forwardModelName);

% Fast forward to beginneing of pertubation window
ah.forward();
tElapsed = 0;
ah.clearWayPoints();
ah.addBreakPoint(min(window(:,2)));
ah.addBreakPoint(max(window(:,2)));

% Loop small pertubation for x simulations
% start total time clock
tStart = tic;
f = waitbar(0,'','Name','Pertubation Analysis...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
	
for i = 1:numSim
    % Check for clicked Cancel button
    if(getappdata(f,'canceling'))
        break
    end
	
	% Start single sim timer
    tic
	
	% Perform small pertubation and load muscle input probes
    [perturbedExcitations,...
        pertExcitMuscleMags] = performExcitationAnalysis(window,smoothExcitations,pertshape,muscles,pertModelType);
    
    pertExcitationMagitudes(i,:) = pertExcitMuscleMags;
    
    ah.setIprobeData (lat  ,horzcat(t,perturbedExcitations(:,2)));
	ah.setIprobeData (rat  ,horzcat(t,perturbedExcitations(:,3)));
	ah.setIprobeData (lmt  ,horzcat(t,perturbedExcitations(:,4)));
	ah.setIprobeData (rmt  ,horzcat(t,perturbedExcitations(:,5)));
	ah.setIprobeData (lpt  ,horzcat(t,perturbedExcitations(:,6)));
	ah.setIprobeData (rpt  ,horzcat(t,perturbedExcitations(:,7)));
	ah.setIprobeData (lsm  ,horzcat(t,perturbedExcitations(:,8)));
	ah.setIprobeData (rsm  ,horzcat(t,perturbedExcitations(:,9)));
	ah.setIprobeData (ldm  ,horzcat(t,perturbedExcitations(:,10)));
	ah.setIprobeData (rdm  ,horzcat(t,perturbedExcitations(:,11)));
	ah.setIprobeData (lmp  ,horzcat(t,perturbedExcitations(:,12)));
	ah.setIprobeData (rmp  ,horzcat(t,perturbedExcitations(:,13)));
	ah.setIprobeData (lsp  ,horzcat(t,perturbedExcitations(:,14)));
	ah.setIprobeData (rsp  ,horzcat(t,perturbedExcitations(:,15)));
	ah.setIprobeData (lip  ,horzcat(t,perturbedExcitations(:,16)));
	ah.setIprobeData (rip  ,horzcat(t,perturbedExcitations(:,17)));
	ah.setIprobeData (lad  ,horzcat(t,perturbedExcitations(:,18)));
	ah.setIprobeData (rad  ,horzcat(t,perturbedExcitations(:,19)));
	ah.setIprobeData (lam  ,horzcat(t,perturbedExcitations(:,20)));
	ah.setIprobeData (ram  ,horzcat(t,perturbedExcitations(:,21)));
	ah.setIprobeData (lpm  ,horzcat(t,perturbedExcitations(:,22)));
	ah.setIprobeData (rpm  ,horzcat(t,perturbedExcitations(:,23)));
	ah.setIprobeData (lgh  ,horzcat(t,perturbedExcitations(:,24)));
	ah.setIprobeData (rgh  ,horzcat(t,perturbedExcitations(:,25)));
    
	% Run simulation for duration of pertubation window
    ah.play();
    ah.waitForStop();

    perticp = ah.getOprobeData('incisor_position'); 
    perticv = ah.getOprobeData('incisor_velocity').*0.001; %m/s
	
	% Calculate Average ICP Acceleration a(t) = (v(tf)-v(t0))/(tf - t0)
	pertaverageica = (perticv(end,2:4)-perticv(1,2:4))/(perticv(end,1)-perticv(1,1));
    
    
	% Log all variables from simulation
    Simulation					= i;
    SimDuration     			= max(perturbedExcitations(:,1));
    SimTimeStep     			= perturbedExcitations(2,1) - perturbedExcitations(1,1);
    InvSimName     				= invModelName;
	Muscles						= muscles;
    ForwardSimName     			= forwardModelName;
    PertShapeFunction     		= pertShapeType;
	PertModelType				= pertModelType;
    t0Pert     					= min(window(:,2));
    tfPert     					= max(window(:,2));
    PertWindowICPX     			= max(perticp(window(:,1),2));
    PertWindowICPY     			= max(perticp(window(:,1),3));
    PertWindowICPZ     			= max(perticp(window(:,1),4));
    PertWindowICVX     			= max(perticv(window(:,1),1));
	PertWindowICVY     			= max(perticv(window(:,1),2));
	PertWindowICVZ     		    = max(perticv(window(:,1),3));
	PertWindowICAX     			= pertaverageica(1);
	PertWindowICAY     			= pertaverageica(2);
	PertWindowICAZ     			= pertaverageica(3);
	PertExcitationFilePath     	= strcat(pwd,'\Output\pertExcitationMagitudes.mat');
	WindowICPX     				= max(icp(window(:,1),2));
	WindowICPY     				= max(icp(window(:,1),3));
	WindowICPZ     				= max(icp(window(:,1),4));
	WindowICVX     				= max(icv(window(:,1),1));
	WindowICVY     				= max(icv(window(:,1),2));
	WinMaxICVZ     				= max(icv(window(:,1),3));
	WindowICAX     				= averageica(1);
	WindowICAY     				= averageica(2);
	WindowICAZ     				= averageica(3);
	ExcitationFilePath     		= strcat(pwd,'\Output\excitations.mat');
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
							  Muscles
							  InvSimName     				
							  ForwardSimName     			
							  PertShapeFunction
							  PertModelType
							  t0Pert     						
							  tfPert     						
							  PertExcitationFilePath     	  				
							  ExcitationFilePath     		
						    }';  
	
	% Save IVs and DVs to row vector	
	statparameters = {  Simulation					   			 			 							   						
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
    if(i == 1)
      esttime = tSim * numSim;
    else
      tElapsed = toc(tStart);
    end

    if(esttime <= 60)
        unit = '[sec]';
        timeremaining = esttime-tElapsed;
    elseif(esttime > 60 && esttime <= 3600)
        unit = '[min]';
        timeremaining = (esttime-tElapsed)/60;
    elseif(esttime > 3600 && esttime < 86400)
        unit = '[hours]';
        timeremaining = (esttime-tElapsed)/3600;
    elseif(esttime >= 86400)
        unit = '[days]';
        timeremaining = (esttime-tElapsed)/86400;
    end
    
    % Update waitbar and message
    waitbar(i/numSim,f,sprintf(strcat('Simulation Progress: %d%%\nTime remaining = %.2f  ', unit),...
        (i/numSim)*100,timeremaining));
    
	% rewind simulation if we are doing more than 1
	% else end artisynth session
    if(numSim > 1)
        ah.rewind();
    else
		ah.quit();
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
    
    s = sprintf('Total simulation time = %.2f', tElapsed);
    fprintf(strcat(s,unit));
	save('Output\pertExcitationMagitudes.mat','pertExcitationMagitudes');
    simulationParamTableOut = simulationParamTable;
	statvarTableOut = statvarTable;
end


