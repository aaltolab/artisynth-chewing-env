function [smoothExcitations] = smoothexcitationsignal(invExcitations)
%SMOOTH EXCITATION SIGNAL
%   This function accepts a matrix for raw excitations with the first column
%   being the time and return smooth signals for the raw excitations calculated
%   from the inverse simulator in artisynth

    smoothExcitations = zeros(size(invExcitations));
    smoothExcitations(:,1) = invExcitations(:,1);
    
    for i = 1:size(invExcitations,2)
         smoothExcitations(:,i) = smoothdata(invExcitations(:,i),'gaussian');
    end
end