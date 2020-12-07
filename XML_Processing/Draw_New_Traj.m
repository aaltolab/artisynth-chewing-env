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
        addpoints(curve1,di(1,i,1), di(1,i,2), di(1,i,3))
        addpoints(curve2,di(2,i,1), di(2,i,2), di(2,i,3))
        addpoints(curve3,di(3,i,1), di(3,i,2), di(3,i,3))
        
        %    The interval between each point is set below, by setting it to
        %    dt, it represents the real interval at which the data was
        %    recorded.
        pause(dt)
        
        %    Update the graph.
        drawnow
        
    end
    
end