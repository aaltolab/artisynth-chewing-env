function [muscleMap] = createMuscleMap(muscles)
%CREATEMUSCLEMAP Summary of this function goes here
%   Input argument is the muscle struct and the output is 
%   its map

muscleMap = containers.Map;
for i = 1:length(muscles)
    muscleMap(muscles(i).name) =  muscles(i).id;
end

