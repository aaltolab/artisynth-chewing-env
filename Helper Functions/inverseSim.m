function [collectedExcitions,collectedIncisorPath,... 
	collectedIncisorVelocity] = inverseSim(simTime,invModelName,muscles)
%PERTSHAPE Summary of this function goes here
%   This function accepts two paramters shape and window
%   shape  = the shape of the pertubation (triangle or  heaviside)
%   window = a vector of the start (t0) and end (t1) of the the window
%   based on the specificed shape the function then returns a normalized
%   vector pertShape
%   muscles = The muscles that are to be deactivated for an inverse sim

	ah = artisynth('-noGui','-disableHybridSolves','-model',invModelName);

	if exist('muscles','var')
		muscleids = cell2mat(muscles(1,:));
		musclelabels = string(muscles(2,:));

		for m = 1:length(muscleids)
			ah.find(strcat('models/jawmodel/axialSprings/',musclelabels(m))).setEnabled(false);
		end
	end

	ah.play(simTime);
	ah.waitForStop();
	
    % save excitation data to matrix
	collectedExcitions = ah.getOprobeData('computed excitations');
	collectedIncisorPath = ah.getOprobeData('incisor_position');
	collectedIncisorVelocity = ah.getOprobeData('incisor_velocity');
    ah.quit();
end