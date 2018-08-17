function [forwICP, forwICV,forwExcitations] = ...
    forwardSim(simDur,forwardModelName,smoothExcitations,muscles, musclesToDeactivate)
    %forwardSim 
    % SUMMARY: 
    % This function accepts all of the required parameters 
    % to perform multiple forward chewing simulations. The excitation
    % patterns for each specified muscle are calculated in the inverse 			  
    % simulation, smoothed with a fast fourier transform and then used 
    % to load the excitation patterns into the muscles specified in a 
    % forward simulation.
    %
    % PARAMETERS:
    % 	smoothExcitations   = This parameter is a matrix that holds the 
    %					    	calculated and signal smoothed excitations
    %					    	from the inverse simulation in artisynth
    %	muscles		        = A struct of simulation muscles. The keys 
    %                         are the muscle codes and the values are integers 
    %					      perturbations to.
    %   simDur			    = The duration of the simulation.
    %   musclesToDeactivate = cell array of muscles to deactivate
    % 
    % RETURNS:
    %   forwICP 		    = A 4 column matrix with time and (x,y,z) position
    %					    	of lower mid incisor from the forward simulation.
    %   forwICV 		    = A 4 column matrix with time and (x,y,z) position
    %					    	of lower mid incisor from the forward simulation.
    %   forwExcitations	    = All muscles excitations 

    %-------------------------FORWARD SIMULATIONS------------------------------
    % SUMMARY OF SCRIPT:
    % 1. run forward sim with smooth excitation

    dt = round(simDur/size(smoothExcitations,1),1,'significant');
    t = [0:dt:simDur]';

    ah = artisynth('-noGui','-model',forwardModelName);


    for m = 1:length(muscles)
        probeLabel = muscles(m).probeLabel;
        muscleId = muscles(m).id;
        ah.setIprobeData (probeLabel, horzcat(t,smoothExcitations(:,muscleId)));
    end

    if exist('musclesToDeactivate','var')
		muscleIds = {muscles.id};
        muscleLabels = string(muscles.name);
        
        for m = 1:length(muscleIds)
            ah.find(strcat('models/jawmodel/axialSprings/',muscleLabels(m))).setEnabled(false);
        end
    end
    
    ah.play(simDur);
    ah.waitForStop();

    % Check incisor path deviation is less that 1mm
    forwICP = ah.getOprobeData('incisor_position');
    forwICV = ah.getOprobeData('incisor_velocity');
    tempExcitations = ah.getOprobeData('excitations');
    forwExcitations = tempExcitations(:,2:25);
    ah.quit();
end