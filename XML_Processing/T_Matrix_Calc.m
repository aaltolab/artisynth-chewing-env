
% File path of the kinematic data.
Traj_File_Path = 'D:\Fall_2020_Work_Term\artisynth\China_Data\19971003.xml';

% Separate Files are depeciated.
Use_Separate_Files = 0;

% Coordinate of the points in Artisynth
pa = [407.97703 369.50888 13.646342; 431.94523 339.13054 6.8490294; 382.17257 339.95002 8.6606195];

% Extract data from the xml file.
[traj,np,dt] = XML2TRAJ(Traj_File_Path,10);

% Side lengths
l1 = vecnorm([traj(1,:,1)-traj(2,:,1);traj(1,:,2)-traj(2,:,2);traj(1,:,3)-traj(2,:,3)]);
l2 = vecnorm([traj(1,:,1)-traj(3,:,1);traj(1,:,2)-traj(3,:,2);traj(1,:,3)-traj(3,:,3)]);
l3 = vecnorm([traj(2,:,1)-traj(3,:,1);traj(2,:,2)-traj(3,:,2);traj(2,:,3)-traj(3,:,3)]);

% Calculate the mean side length of the triangles
l_ave = mean(mean([l1;l2;l3]));

% In Artisynth
la1 = norm([pa(1,1)-pa(2,1);pa(1,2)-pa(2,2);pa(1,3)-pa(2,3)]);
la2 = norm([pa(1,1)-pa(3,1);pa(1,2)-pa(3,2);pa(1,3)-pa(3,3)]);
la3 = norm([pa(2,1)-pa(3,1);pa(2,2)-pa(3,2);pa(2,3)-pa(3,3)]);
la_ave = mean([la1,la2,la3]);

% Scale the kinematic data
scale = la_ave/l_ave;
traj_scaled = scale.*traj;

% Apply the D.W. Eggert, A. Lorusso, R.B. Fisher Algorithm, we only have
% the first elements here so
d1 = pa;
mi = traj;
m1 = squeeze(mi(:,1,:));

d1_ave = mean(d1);
m1_ave = mean(m1);

dc1 = d1 - d1_ave;
mc1 = m1 - m1_ave;

H = mc1*dc1';

% Singular Value Decompositionfor a matrix
[U,S,V] = svd(H);

% The rotation matrix is found
R = V*U';

% The translation matrix is found
T = (d1_ave' - R* m1_ave')';

di = zeros(3,np,3);

% Output
for i = 1:3
    for j = 1:np
        di(i,j,:)= R * squeeze(mi(i,j,:)) + T';
        
    end
end

% Write to file

% Artisynth ASCII file variables, by default the start time is 0
Start_Time = 0;

% Scale factor, probably for the time variables, 1 by default
Scale = 1;

% Interpolation can be "Linear", "Parabolic" or "Cubic", etc. Not sure if
% the ititial capitalization matters but it is capitalized in the
% documentation
Interpolation = "Linear";

if Use_Separate_Files
    for k =1:3
        File_Name = "Marker"+k+"_Traj.txt";
        fileID = fopen(File_Name,'w');
        % Format headings
        fprintf(fileID,"%.5g %.5g %.5g \n", Start_Time, np*dt, Scale);
        
        % The vsize here should be 3 for x, y, and z, "s" for string and "i"
        % for integer
        fprintf(fileID,"%s %i %.5g \n", Interpolation, 3, dt);
        for l = 1:np
            
            fprintf(fileID,"%.5g %.5g %.5g \n", di(k,l,1), di(k,l,2), di(k,l,3));
            
            
        end
        fclose(fileID);
        
    end
else
    File_Name = "JMA_position.txt";
    fileID =fopen(File_Name,'w');
    fprintf(fileID,"%.5g %.5g %.5g \n", Start_Time, np*dt, Scale);
    fprintf(fileID,"%s %i %.5g \n", Interpolation, 9, dt);
    for m = 1:np
        
        fprintf(fileID,"%.5g %.5g %.5g %.5g %.5g %.5g %.5g %.5g %.5g \n", di(1,m,1), di(1,m,2), di(1,m,3), di(2,m,1), di(2,m,2), di(2,m,3), di(3,m,1), di(3,m,2), di(3,m,3));
        
        
    end
    
end
