function [] = writeToExcitFiles(path,t0,tf,excitations)
%WRITETOEXCITFILES Summary of this function goes here
%   IN PROGRESS
	
	t0 = num2str(t0,'%.4f');
	tf = num2str(tf,'%.4f');
	numSteps = num2str(size(excitatations,1),'%d');
	t = excitations(:,1);
    muscles = 1:1:size(excitations,2)-1;
	
	for i = 1:size(t,1)
		fid = fopen(strcat(path,'\', muscles(i)),'wt');
		fprintf(fid, '%s\t %s\t %s\n', t0,tf,'1.0');
		fprintf(fid, '%s\t %s\t %s\n', 'Cubic',numSteps,'explicit');
		dlmwrite(strcat(path,'\', muscles(i)),horzcat(t,excitations(:,i)) ,'-append','delimiter','\t' );
		fclose(fid);
	end
end