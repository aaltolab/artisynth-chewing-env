function [collectedExcitations,collectedIncisorPath,...
    collectedIncisorVelocity] = inversesim(t,invModelName,targetdatapath,musclesToDeactivate)
%INVERSESIM Summary of this function goes here
%   simDur  = the duration of the simulation
%	invModelName = the java path of the class to be instantiated within artisynth
%   musclesDeactivated = The muscles that are to be deactivated for an inverse sim

ah = artisynth('-disableHybridSolves','-model',invModelName);
musclestoactivate = createmusclestruct('musclekey.txt');
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

if exist('musclesToDeactivate','var')
    muscleIds = [musclesToDeactivate.id];
    musclestoactivate(muscleIds) = []
    
    for m = 1:length(musclestoactivate)
        muscle = ah.find(strcat('models/jawmodel/axialSprings/',musclestoactivate(m).name));
        tcon.addExciter(muscle);
    end
    tcon.setProbeUpdateInterval(dt);
    tcon.setProbeDuration(t(end));
    tcon.createProbes(model);
else
    for m = 1:length(musclestoactivate)
        muscle = ah.find(strcat('models/jawmodel/axialSprings/',musclestoactivate(m).name));
        tcon.addExciter(muscle);
    end
    tcon.setProbeUpdateInterval(dt);
    tcon.setProbeDuration(t(end));
    tcon.createProbes(model);
end

% Add motion target of lower incisor to tracking controller
motionTargetIProbe = ah.find('inputProbes/target positions');
motionTargetIProbe.setAttachedFileName(targetdatapath);
motionTargetIProbe.load();
motionTargetIProbe.setActive(true);

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
collectedExcitations = tempExcitations(:,2:25);
collectedIncisorPath = ah.getOprobeData('target positions');
collectedIncisorVelocity = ah.getOprobeData('incisor_velocity');
ah.quit();
end