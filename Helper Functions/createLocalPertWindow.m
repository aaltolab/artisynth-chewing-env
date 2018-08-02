function [window] = createLocalPertWindow(compExcitM,t0,t1, fs)
%createLocalPertWindow
% SUMMARY: Creates a window where a small pertubation
% will be applied to the forward chewing simulation.
% 
% This function uses the computed muscles excitations (compExcitM),
% intial time (t0), final time (t1), and the sampling frequency (fs)
% to generate a window where the first column is the row number of the
% computed excitations and then second column is the correlating time
% interval.
%
% EXAMPLE OUTPUT: createLocalPertWindow(comptExcitM,0,0.05,100)
%
%	window = 1			2
%   		 1			0.01
%   		 2			0.02
%   		 3			0.03
%   		 4			0.04
%   		 5			0.05

	dt=1/fs;
	temp=zeros(size((t0:dt:t1)'));
	horzcat(temp, (t0:dt:t1)');

	window=horzcat(temp, (t0:dt:t1)');
	first = 0;

	for i = 1:size(compExcitM,1)
		if(t0 == compExcitM(i,1))
			first = i;
		end      
	end
	for j = 1:length(window(:,1))
		window(j,1) = first;
		first = first + 1;
	end  
end