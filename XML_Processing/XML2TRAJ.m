function [traj,np,dt] = XML2TRAJ(File_Path,Movement_Number)
% xml2struct is a function on MATLAB File Exchange that converts an xml
% file into a MATLAB structure, it is NOT built-in and needs to be present
% for this script to work.

% Inputs: File_Path is the path of the xml file, Movement_Number designates
% which movement to extract, as one file can contain multiple of them.

% Outputs: traj is a 3*n*3 matrix, with the first index refers to the
% marker, the second the point, and the third the axis (1 for x, 2 for y,
% and 3 for z), np is the number of points and dt is the time interval

% Use the function to convert the xml
Original_Struct = xml2struct(File_Path);

% This would return a nested structure with many layers

% Movement 1 Track 1
% Number of points
np = length(Original_Struct.dental_measurement.movements.movement{1,Movement_Number}.tracks.track{1,1}.quants.quant);

% The time interval can be calculated using the frquency
dt = 1/str2double(Original_Struct.dental_measurement.movements.movement{1,Movement_Number}.tracks.track{1,1}.frequency.Text);

% Each coordinate is found in "quant"

% % Point 1
% p1_struct = Original_Struct.dental_measurement.movements.movement{1,1}.tracks.track{1,1}.quants.quant{1,1};
% p1 = [str2double(p1_struct.x.Text), str2double(p1_struct.y.Text), str2double(p1_struct.z.Text)];
%
% % Point 2
% p2_struct = Original_Struct.dental_measurement.movements.movement{1,1}.tracks.track{1,1}.quants.quant{1,2};
% p2 = [str2double(p2_struct.x.Text), str2double(p2_struct.y.Text), str2double(p2_struct.z.Text)];
%
% % Point 3
% p3_struct = Original_Struct.dental_measurement.movements.movement{1,1}.tracks.track{1,1}.quants.quant{1,3};
% p3 = [str2double(p3_struct.x.Text), str2double(p3_struct.y.Text), str2double(p3_struct.z.Text)];

traj = zeros(3,np,3);
for j = 1:3
    for i = 1:np
        
        p_struct = Original_Struct.dental_measurement.movements.movement{1,Movement_Number}.tracks.track{1,j}.quants.quant{1,i};
        traj(j,i,1) = str2double(p_struct.x.Text);
        traj(j,i,2) = str2double(p_struct.y.Text);
        traj(j,i,3) = str2double(p_struct.z.Text);
        
    end
end
end