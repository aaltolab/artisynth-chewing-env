function [collectedExcitions,collectedIncisorPath,... 
	collectedIncisorVelocity] = inversesim(simDur,invModelName,musclesDeactivated)
%INVERSESIM Summary of this function goes here
%   simDur  = the duration of the simulation
%	invModelName = the java path of the class to be instantiated within artisynth
%   musclesDeactivated = The muscles that are to be deactivated for an inverse sim

	ah = artisynth('-noGui','-disableHybridSolves','-model',invModelName);

	if exist('musclesDeactivated','var')
% 		muscleIds = cell2mat(musclesDeactivated(1,:));
% 		muscleLabels = string(musclesDeactivated(2,:));
		muscleIds = {musclesDeactivated.id};
        muscleLabels = {musclesDeactivated.name};

		for m = 1:length(musclesDeactivated)
			ah.find(strcat('models/jawmodel/axialSprings/',muscleLabels(m))).setEnabled(false);
		end
	end

	ah.play(simDur);
	ah.waitForStop();
	
    % save excitation data to matrix
	collectedExcitions = ah.getOprobeData('computed excitations');
	collectedIncisorPath = ah.getOprobeData('incisor_position');
	collectedIncisorVelocity = ah.getOprobeData('incisor_velocity');
    ah.quit();
end