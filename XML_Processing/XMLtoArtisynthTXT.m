% Set the path of the xml file.
% File_Path = 'D:\Fall_2020_Work_Term\artisynth\China_Data\Zebris_Tracking_Data.xml';
File_Path = 'D:\Fall_2020_Work_Term\artisynth\China_Data\19971003.xml';

% Artisynth ASCII file variables, by default the start time is 0
Start_Time = 0;

% Scale factor, probably for the time variables, 1 by default
Scale = 1;

% Interpolation can be "Linear", "Parabolic" or "Cubic", etc. Not sure if
% the ititial capitalization matters but it is capitalized in the
% documentation
Interpolation = "Linear";

[p,np,dt] = XML2TRAJ(File_Path);
% Now we have our points, just need to format them so Artisynth understands

% See Artisynth documentation Artisynth Manuals and Guides\Artisynth
% Modelling Guide\5.4.4 
% https://www.artisynth.org/manuals/index.jsp?topic=%2Forg.artisynth.doc%2Fhtml%2Fmodelguide%2FCh5.S4.html

% We can use the follorwing format
% startTime stopTime scale
% interpolation vsize timeStep
% val00 val01 val02 ...
% val10 val11 val12 ...
% val20 val21 val22 ...
% ... 

% The precision of can be changed by changing the number and letter
% following "%.", a letter "g" mean a specific number of signigicant digits
% is requested while "f" requests the number of digits to the right of the 
% decimal point, see https://www.mathworks.com/help/matlab/ref/fprintf.html
% for further details

% Format headings
fprintf("%.5g %.5g %.5g \n", Start_Time, np*dt, Scale)

% The vsize here should be 3 for x, y, and z, "s" for string and "i" for
% integer
fprintf("%s %i %.5g \n", Interpolation, 3, dt)

% Points coordinates
% fprintf("%.5g %.5g %.5g \n", p1(1), p1(2), p1(3))
% fprintf("%.5g %.5g %.5g \n", p2(1), p2(2), p2(3))
% fprintf("%.5g %.5g %.5g \n", p3(1), p3(2), p3(3))

for i = 1:np

    fprintf("%.5g %.5g %.5g \n", p(1,i,1), p(1,i,2), p(1,i,3))
    
end















