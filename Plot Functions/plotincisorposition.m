function [] = plotincisorposition(incisorPosMs)
%PLOTEXCITATIONS Summary of this function goes here
%   Detailed explanation goes here

x = incisorPosMs(:,2,:);
y = incisorPosMs(:,3,:);
z = incisorPosMs(:,4,:);

for i = 1:size(incisorPosMs,3)
    figure(i);
    plot3(x(:,:,i),y(:,:,i),z(:,:,i))  
    view(0,0);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
            
    title = sprintf('Lower mid incisor path');  
    annotation('textbox', [0 0.9 1 0.1], ...
    'String', title, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')
end
