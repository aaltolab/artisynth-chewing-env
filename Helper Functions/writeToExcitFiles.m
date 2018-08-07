function [] = writeToExcitFiles(path,t0,tf,excit,muscles)
%WRITETOEXCITFILES Summary of this function goes here
%   IN PROGRESS
	
	numSteps = num2str(size(excit,1),'%d');    
    t = excit(:,1);
    excitationsTemp = excit(:,2:25);
    muscleids = cell2mat(muscles(1,:));
    musclelabels = string(muscles(2,:));
    excitations = excitationsTemp(:,muscleids);
	
    for m = 1:size(muscles,2)
        musclefilepath = strcat(path,"\", musclelabels(m),".txt");        
        fid = fopen(musclefilepath,'wt');
        fprintf(fid, "%s\t %s\t %s\n", num2str(t0),num2str(tf),"1.0");
        fprintf(fid, "%s\t %s\t %s\n", "Cubic",num2str(numSteps),"explicit");
        dlmwrite(musclefilepath,horzcat(t,excitations(:,m)),'-append','delimiter','\t' );
        fclose(fid);
    end
    display('Smooth excitations successfully written to input probe files');
end

