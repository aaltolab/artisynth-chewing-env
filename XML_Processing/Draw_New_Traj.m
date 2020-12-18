% Extract data from the file
% File_Path = 'D:\Fall_2020_Work_Term\artisynth\China_Data\19971003.xml';
% %
% [traj,np,dt] = XML2TRAJ(File_Path,10);

% plot3(traj(1,:,1), traj(1,:,2), traj(1,:,3),traj(2,:,1), traj(2,:,2),
% traj(2,:,3),traj(3,:,1), traj(3,:,2), traj(3,:,3))

traj_drawn = traj;

% An infinite loop, to exit, use ctrl+C to break.
while true
    
    disp('Press any key to continue.')
    
    % Pauses the program until a keypress.
    pause
    
    % Clear the figure every time the loop runs.
    clf
    
    % Create animated lines for the three trackers.
    curve1 = animatedline('LineWidth',2,'Color','g');
    curve2 = animatedline('LineWidth',2,'Color','r');
    curve3 = animatedline('LineWidth',2,'Color','b');
    
%     axis([-40 40 -40 40 -40 40])
    
    grid on
    
    for i = 1:np
        
        %     Add points to the animated lines.
        addpoints(curve1,traj_drawn(1,i,1), traj_drawn(1,i,2), traj_drawn(1,i,3))
        addpoints(curve2,traj_drawn(2,i,1), traj_drawn(2,i,2), traj_drawn(2,i,3))
        addpoints(curve3,traj_drawn(3,i,1), traj_drawn(3,i,2), traj_drawn(3,i,3))
        
        %    The interval between each point is set below, by setting it to
        %    dt, it represents the real interval at which the data was
        %    recorded.
        pause(dt)
        
        %    Update the graph.
        drawnow
        
    end
    
end