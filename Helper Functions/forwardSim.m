function [forwICP, forwICV] = ...
    forwardSim(simTime,forwardModelName,smoothExcitationM, muscles)
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
    %	muscles		      = A Key, Value pair of simulation muscles. The keys 
    %                       are the muscle codes and the values are integers 
    %					    pertubations to.
    %   numSim			  = The number of forward simulations to run.
    % 
    % RETURNS:
    %   forwICP 		  = A 4 column matrix with time and (x,y,z) position
    %						of lower mid incisor from the forward simulation.
    %   forwICV 		  = A 4 column matrix with time and (x,y,z) position
    %						of lower mid incisor from the forward simulation.

    %----------------------FULL MUSCLE NAMES FOR IPROBES-----------------------
    lat     =  'Left Anterior Temporal';
    rat     =  'Right Anterior Temporal';
    lmt     =  'Left Middle Temporal';
    rmt     =  'Right Middle Temporal';
    lpt     =  'Left Posterior Temporal';
    rpt     =  'Right Posterior Temporal';
    lsm     =  'Left Superficial Masseter';
    rsm     =  'Right Superficial Masseter';
    ldm     =  'Left Deep Masseter';
    rdm     =  'Right Deep Masseter';
    lmp     =  'Left Medial Pterygoid';
    rmp     =  'Right Medial Pterygoid';		
    lsp     =  'Left Superior Lateral Pterygoid';
    rsp     =  'Right Superior Lateral Pterygoid';
    lip     =  'Left Inferior Lateral Pterygoid';
    rip     =  'Right Inferior Lateral Pterygoid';
    lad     =  'Left Anterior Digastric';
    rad     =  'Right Anterior Digastric';
    lam     =  'Left Mylohyoid';
    ram     =  'Right Mylohyoid';
    lpm     =  'Left Posterior Mylohyoid';
    rpm     =  'Right Posterior Mylohyoid';
    lgh     =  'Left Geniohyoid';
    rgh     =  'Right Geniohyoid';					

    smoothExcitations = smoothExcitationM(:,2:25);
    t = smoothExcitationM(:,1);

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

    ah.setIprobeData (lat  ,horzcat(t,smoothExcitations(:,1)));
    ah.setIprobeData (rat  ,horzcat(t,smoothExcitations(:,2)));
    ah.setIprobeData (lmt  ,horzcat(t,smoothExcitations(:,3)));
    ah.setIprobeData (rmt  ,horzcat(t,smoothExcitations(:,4)));
    ah.setIprobeData (lpt  ,horzcat(t,smoothExcitations(:,5)));
    ah.setIprobeData (rpt  ,horzcat(t,smoothExcitations(:,6)));
    ah.setIprobeData (lsm  ,horzcat(t,smoothExcitations(:,7)));
    ah.setIprobeData (rsm  ,horzcat(t,smoothExcitations(:,8)));
    ah.setIprobeData (ldm  ,horzcat(t,smoothExcitations(:,9)));
    ah.setIprobeData (rdm  ,horzcat(t,smoothExcitations(:,10)));
    ah.setIprobeData (lmp  ,horzcat(t,smoothExcitations(:,11)));
    ah.setIprobeData (rmp  ,horzcat(t,smoothExcitations(:,12)));
    ah.setIprobeData (lsp  ,horzcat(t,smoothExcitations(:,13)));
    ah.setIprobeData (rsp  ,horzcat(t,smoothExcitations(:,14)));
    ah.setIprobeData (lip  ,horzcat(t,smoothExcitations(:,15)));
    ah.setIprobeData (rip  ,horzcat(t,smoothExcitations(:,16)));
    ah.setIprobeData (lad  ,horzcat(t,smoothExcitations(:,17)));
    ah.setIprobeData (rad  ,horzcat(t,smoothExcitations(:,18)));
    ah.setIprobeData (lam  ,horzcat(t,smoothExcitations(:,19)));
    ah.setIprobeData (ram  ,horzcat(t,smoothExcitations(:,20)));
    ah.setIprobeData (lpm  ,horzcat(t,smoothExcitations(:,21)));
    ah.setIprobeData (rpm  ,horzcat(t,smoothExcitations(:,22)));
    ah.setIprobeData (lgh  ,horzcat(t,smoothExcitations(:,23)));
    ah.setIprobeData (rgh  ,horzcat(t,smoothExcitations(:,24))); 

    if exist('muscles','var')
		muscleids = cell2mat(muscles(1,:));
        musclelabels = string(muscles(2,:));
        
        for m = 1:length(muscleids)
            ah.find(strcat('models/jawmodel/axialSprings/',musclelabels(m))).setEnabled(false);
        end
    end
    
    ah.play(simTime);
    ah.waitForStop();

    % Check incisor path deviation is less that 1mm
    forwICP = ah.getOprobeData('incisor_position');
    forwICV = ah.getOprobeData('incisor_velocity');
    ah.quit();
end