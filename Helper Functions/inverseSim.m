function [collectedExcitions,collectedIncisorPath, collectedIncisorVelocity] = inverseSim(simTime,invModelName)
%PERTSHAPE Summary of this function goes here
%   This function accepts two paramters shape and window
%   shape  = the shape of the pertubation (triangle or  heaviside)
%   window = a vector of the start (t0) and end (t1) of the the window
%   based on the specificed shape the function then returns a normalized
%   vector pertShape

	printed = 0;  % 1 = true and 0 = false

	ah = artisynth('-noGui','-disableHybridSolves','-model',invModelName);
	ah.play(simTime);
	while(ah.isPlaying())     
		if (ah.getTime() == 0.25*simTime)
			if (printed == 0)
                disp('Starting Inverse Simulation');
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
    % save excitation data to matrix
	collectedExcitions = ah.getOprobeData('computed excitations');
	collectedIncisorPath = ah.getOprobeData('incisor_position');
	collectedIncisorVelocity = ah.getOprobeData('incisor_velocity');
    ah.quit();
end