function [perturbedExcitMsOut,pertShapeMagnitutdes] = performExcitationAnalysis(window,excitMs,pertshape,muscles,pertModelType)
%PERFORMEXCITATIONANALYSIS Summary of this function goes here
%   Detailed explanation goes here

% Set all negative values in smoothed matricies to 0
excitMs(excitMs<0)=0;
muscleids =  cell2mat(muscles(1,:));

if (strcmp(pertModelType,"additive"))
    additive = 1;
    sigma = .01*max(max(max(excitMs)));
    mu= 0;
elseif (strcmp(pertModelType,"multiplicative"))
    additive = 0;
    sigma = .01*max(max(max(excitMs)));
    mu= 0;
end
    
perturbedExcitMs=excitMs(:,muscleids); 
pertShapeMagnitutdes = zeros(1,length(muscleids));

  
for n = 1:size(perturbedExcitMs,3)
    for i = 1:length(muscleids)
        randPert = normrnd(mu,sigma)*pertshape;
        if (additive == 1)
            perturbedExcitMs(window(:,1),muscleids(i),n) = ...
                excitMs(window(:,1),muscleids(i),n) + randPert;
        elseif (additive == 0)
            perturbedExcitMs(window(:,1),muscleids(i),n) = ...
                excitMs(window(:,1),muscleids(i),n).*(1 + randPert);
        else
            fprintf('The pertubation model has not been specificed. Set additive to 1 or 0.')
            return
        end
    
        %Check that all random excitations fall within 0 and 1. If not set
        %the muscle vector value to its max or min
        for j = 1:size(perturbedExcitMs(window(:,1),muscleids(i),n),1)
            if (perturbedExcitMs(window(j,1),muscleids(i),n) < 0)
                perturbedExcitMs(window(j,1),muscleids(i),n) = 0;
            elseif (perturbedExcitMs(window(j,1),muscleids(i),n) > 1)
                perturbedExcitMs(window(j,1),muscleids(i),n) = 1;
            end
        end
        pertShapeMagnitutdes(i) = randPert(1);
    end
end
perturbedExcitMsOut =  perturbedExcitMs;
end

