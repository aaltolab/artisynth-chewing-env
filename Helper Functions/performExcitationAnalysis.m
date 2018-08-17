function [perturbedExcitMsOut,pertShapeMagnitutdes] = performexcitationanalysis(window,excitMs,pertshape,muscles,pertModelType)
    %performexcitationanalysis Summary of this function goes here
    %   Detailed explanation goes here

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
        randPert = normrnd(mu,sigma)*pertshape;
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

