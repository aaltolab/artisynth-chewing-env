function [collectedExcitations,collectedIncisorPath,...
    collectedIncisorVelocity] = inversesim(t,invModelName,targetdatapath,musclesToDeactivate,debug)
%INVERSESIM Summary of this function goes here
%   simDur  = the duration of the simulation
%	invModelName = the java path of the class to be instantiated within artisynth
%   musclesDeactivated = The muscles that are to be deactivated for an inverse sim

ah = artisynth('-disableHybridSolves','-model',invModelName);
musclestoactivate = createmusclestruct('musclekey.csv');
muscleMap = createMuscleMap(musclestoactivate);
muscles = musclestoactivate;
% Get tcon
tcon = ah.find('controllers/myTrackingController');
model = ah.find('.');
dt = t(end) - t(end-1);
model.setMaxStepSize (dt);

% Add waypoints
for i = 1:length(t)
    model.addWayPoint(t(i));
end
pause(1);
if length(musclesToDeactivate) ~= 0
    muscleIds = [musclesToDeactivate.id];
    musclestoactivate(muscleIds) = []
    
    for m = 1:length(musclestoactivate)
        muscle = ah.find(strcat('models/jawmodel/axialSprings/',musclestoactivate(m).name));
        tcon.addExciter(muscle);
    end
    tcon.setProbeUpdateInterval(dt);
    tcon.setProbeDuration(t(end));
    tcon.createProbes(model);
    
    % Get labels of active muscle excitation tracks on the output probe
    OprobeHeaders = strings(1,length(musclestoactivate));
    op = ah.find('outputProbes/computed excitations');
    for i = 1:length(musclestoactivate)
        label = string(op.getPlotTraceInfo(i-1).getLabel());
        trimmedLabel = extractBetween(label,19,21);
        OprobeHeaders(i) =  trimmedLabel;
    end
    
else
    for m = 1:length(musclestoactivate)
        muscle = ah.find(strcat('models/jawmodel/axialSprings/',musclestoactivate(m).name));
        tcon.addExciter(muscle);
    end
    tcon.setProbeUpdateInterval(dt);
    tcon.setProbeDuration(t(end));
    tcon.createProbes(model);
    
        % Get labels of active muscle excitation tracks on the output probe
    OprobeHeaders = strings(1,length(musclestoactivate));
    op = ah.find('outputProbes/computed excitations');
    for i = 1:length(musclestoactivate)
        label = string(op.getPlotTraceInfo(i-1).getLabel());
        trimmedLabel = extractBetween(label,19,21);
        OprobeHeaders(i) =  trimmedLabel;
    end
    % TODO: Build a function to set maxForce, passiveFraction, optLength,
    % maxLength, tendonRatio, and damping for each muscle
    % load the muscleprops.mat table and set material params based on table
    % data. To access the props in artisynth here is a start to get there:
    % This will set max force for example:
        % m.getProperty('material').get().getProperty('maxForce').set(0)
    % To set the muscle on or off the  maxForce needs to be 0 and it should
    % not be added as an exciter
    
    musclesToDeactivate = [];
end


% Add motion target of lower incisor to tracking controller
motionTargetIProbe = ah.find('inputProbes/target positions');
motionTargetIProbe.setAttachedFileName(targetdatapath);
motionTargetIProbe.load();
motionTargetIProbe.setActive(true);

if debug == 1
    pause(1);
    disp("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    disp("!!!!!!                                    !!!!!!!");
    disp("!!!!!!     Enter any key to continue      !!!!!!!");
    disp("!!!!!!                                    !!!!!!!");
    disp("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    pause;
end

ah.play();

while ah.isPlaying()
    progress = (ah.getTime()/t(end)) * 100;
    fprintf('Simulation complete: %5.2f %%\n ', progress)
    
    if ah.getTime() == t(end)
        ah.pause()
    end
end

% save excitation data to matrix
tempExcitations = ah.getOprobeData('computed excitations');
recoveredExcitations = {OprobeHeaders;tempExcitations(:,2:end)};

% compare recovered excitations to all muslce column vectors to return a
% 24x24 num mat of excitation
collectedExcitations = zeros(length(t),24);

    for m = 1:length(recoveredExcitations{1})
        key = char(recoveredExcitations{1}(m));
        if isKey(muscleMap,key) == 1
            colNum = muscleMap(key);
            collectedExcitations(:,colNum) = recoveredExcitations{2}(:,m);
        end
    end
collectedIncisorPath = ah.getOprobeData('target positions');
collectedIncisorVelocity = ah.getOprobeData('incisor_velocity');
ah.quit();
end