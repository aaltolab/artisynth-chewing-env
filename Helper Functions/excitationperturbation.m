function [perturbedExcitMsOut,pertShapeMagnitutdes] = excitationperturbation(window,excitMs,pertShape,muscles,pertModelType)
   % SUMMARY:
   % window         = the time period that the perturbation is applied to
   % excitMs        = the muscle excitations to be perturbed 
   % pertShape      = the shape function of the perturbation (step, ramp)
   % muscles        = struct of the muscle signals to be perturbed
   % pertModelType  = the type of model to apply to the perturbation.
   %                  It can be additive or multiplicative.
   % This function selects the window of time for the excitations signals
   % and applies a small random perturbation to that signal. The random
   % perturbation is generated with matlabs random function algorithms. However,
   % the selection for the algorithm changes every time that this function is called.

    % Set all negative values in smoothed matrices to 0
    rng('shuffle');
    excitMs(excitMs<0)=0;
    muscleIds = cell2mat({muscles.id});

    if (strcmp(pertModelType,"additive"))
        additive = 1;
        sigma = .01*max(max(max(excitMs)));
        mu= 0;
    elseif (strcmp(pertModelType,"multiplicative"))
        additive = 0;
        sigma = .01*max(max(max(excitMs)));
        mu= 0;
    end

    perturbedExcitMs=excitMs(:,muscleIds); 
    pertShapeMagnitutdes = zeros(1,length(muscleIds));

    for i = 1:length(muscleIds)
        randPert = normrnd(mu,sigma)*pertShape;
        if (additive == 1)
            perturbedExcitMs(window(:,1),muscleIds(i)) = ...
                excitMs(window(:,1),muscleIds(i)) + randPert;
        elseif (additive == 0)
            perturbedExcitMs(window(:,1),muscleIds(i)) = ...
                excitMs(window(:,1),muscleIds(i)).*(1 + randPert);
        else
            fprintf('The perturbation model has not been specified. Set additive to 1 or 0.')
            return
        end

        %Check that all random excitations fall within 0 and 1. If not set
        %the muscle vector value to its max or min
        for j = 1:size(perturbedExcitMs(window(:,1),muscleIds(i)),1)
            if (perturbedExcitMs(window(j,1),muscleIds(i)) < 0)
                perturbedExcitMs(window(j,1),muscleIds(i)) = 0;
            elseif (perturbedExcitMs(window(j,1),muscleIds(i)) > 1)
                perturbedExcitMs(window(j,1),muscleIds(i)) = 1;
            end
        end
        pertShapeMagnitutdes(i) = randPert(1);
    end
    perturbedExcitMsOut =  perturbedExcitMs;
end

