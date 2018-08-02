function [] = plotIncisorVelocity(incisorVelMs)
%PLOTEXCITATIONS Summary of this function goes here
%   Detailed explanation goes here

t  = incisorVelMs(:,1,:);
vx = incisorVelMs(:,2,:);
vy = incisorVelMs(:,3,:);
vz = incisorVelMs(:,4,:);

for i = 1:size(incisorVelMs,3)
        subplot(3,1,i)
            plot(t(:,:,i),vx(:,:,i),'r','LineWidth',1.2);
            hold on
            plot(t(:,:,i),vy(:,:,i),'g','LineWidth',1.2);
            hold on
            plot(t(:,:,i),vz(:,:,i),'b','LineWidth',1.2);
            hold on
            xlabel('Time [s]');
            ylabel('Vel [m/s]');
            legend('vx','vy','vz');
end

%   title = sprintf('Simulation: %d',i); 
