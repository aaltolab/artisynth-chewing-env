function [window] = createlocalpertwindow(simDur,pertt0,pertt1, fs)
%createlocalpertwindow
% SUMMARY: Creates a window where a small perturbation
% will be applied to the forward chewing simulation.
% 
% This function uses the computed muscles excitations (compExcitM),
% initial time (t0), final time (t1), and the sampling frequency (fs)
% to generate a window where the first column is the row number of the
% computed excitations and then second column is the correlating time
% interval.
%
% EXAMPLE OUTPUT: createlocalpertwindow(comptExcitM,0,0.05,100)
%
%	window = 1			2
%   		 1			0.01
%   		 2			0.02
%   		 3			0.03
%   		 4			0.04
%   		 5			0.05

	dt=1/fs;
	t = [0:dt:simDur;];
	temp = [1:1:length(t);t]';
	first = find(temp(:,2)<=pertt0,1,'last');
	last  = find(temp(:,2)<=pertt1,1,'last');
	
	window = temp(first:last,:);
end