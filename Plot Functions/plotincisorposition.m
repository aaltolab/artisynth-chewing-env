function [] = plotincisorposition(preopICP,postopICP,v)
%PLOTEXCITATIONS Summary of this function goes here
%   Detailed explanation goes here

[maxNumPreOp, maxIndexPreop] = min(preOpICP(:,4));
[maxNumPostOp, maxIndexPostOp] = min(postOpICP(:,4));

x = incisorPosMs(:,2,:);
y = incisorPosMs(:,3,:);
z = incisorPosMs(:,4,:);

plot3(preopICP(:,2),preopICP(:,3),preopICP(:,4),'LineWidth',1.2);
view(v(1),v(2));
hold on
plot3(preOpICP(1,2),preOpICP(1,3),preOpICP(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
hold on
plot3(preOpICP(end,2),preOpICP(end,3),preOpICP(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
hold on;
plot3(preOpICP(maxIndexPreop,2),preOpICP(maxIndexPreop,3),maxNumPreOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
hold on
plot3(postOpICP(:,2),postOpICP(:,3),postOpICP(:,4),'LineWidth',1.2);
view(v(1),v(2));
hold on
plot3(postOpICP(1,2),postOpICP(1,3),postOpICP(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
hold on
plot3(postOpICP(end,2),postOpICP(end,3),postOpICP(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
hold on
plot3(postOpICP(maxIndexPostOp,2),postOpICP(maxIndexPostOp,3),maxNumPostOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
legend('Pre Op ICP', 'Pre Op  Initial ICP', 'Pre Op  Final ICP', 'Pre Op Max Opening ICP' ,'Post Op ICP', 'Post Op Initial ICP', 'Post Op Final ICP', 'Post Op Max Opening ICP');
% xlabel('X axis [mm]');
% zlabel('Z axis [mm]');
% xlim(xLim);
% title('Lower mid incisor path (Frontal View)');

% % Generate pre simulation plots
% [maxNumPreOp, maxIndexPreop] = min(preOpICP(:,4));
% [maxNumPostOp, maxIndexPostOp] = min(postOpICP(:,4));
% % Frontal view on ICP
% figure;
%  plot3(preOpICP(:,2),preOpICP(:,3),preOpICP(:,4),'LineWidth',1.2);
%  view(0,0);
%  hold on
%  plot3(preOpICP(1,2),preOpICP(1,3),preOpICP(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
%  hold on
%  plot3(preOpICP(end,2),preOpICP(end,3),preOpICP(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
%  hold on;
%  plot3(preOpICP(maxIndexPreop,2),preOpICP(maxIndexPreop,3),maxNumPreOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
%  hold on
%  plot3(postOpICP(:,2),postOpICP(:,3),postOpICP(:,4),'LineWidth',1.2);
%  view(0,0);
%  hold on
%  plot3(postOpICP(1,2),postOpICP(1,3),postOpICP(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
%  hold on
%  plot3(postOpICP(end,2),postOpICP(end,3),postOpICP(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
%  hold on
%  plot3(postOpICP(maxIndexPostOp,2),postOpICP(maxIndexPostOp,3),maxNumPostOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
%  legend('Pre Op ICP', 'Pre Op  Initial ICP', 'Pre Op  Final ICP', 'Pre Op Max Opening ICP' ,'Post Op ICP', 'Post Op Initial ICP', 'Post Op Final ICP', 'Post Op Max Opening ICP');
%  xlabel('X axis [mm]');
%  zlabel('Z axis [mm]');
%  xlim([-5 10])
%  title('Lower mid incisor path (Frontal View)');
 
% saveas(gcf,strcat(outputfilename, '\FrontalView.pdf'));
 
%  % Transverse view on ICP
% figure;
%  plot3(preOpICP(:,2),preOpICP(:,3),preOpICP(:,4),'LineWidth',1.2);
%  view(90,0)  % YZ
%  hold on
%  plot3(preOpICP(1,2),preOpICP(1,3),preOpICP(1,4),'bo','MarkerSize', 5, 'MarkerFaceColor', 'b')
%  hold on
%  plot3(preOpICP(end,2),preOpICP(end,3),preOpICP(end,4),'mv','MarkerSize', 5, 'MarkerFaceColor', 'm')
%  hold on
%  plot3(preOpICP(maxIndexPreop,2),preOpICP(maxIndexPreop,3),maxNumPreOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
%  hold on
%  plot3(postOpICP(:,2),postOpICP(:,3),postOpICP(:,4),'LineWidth',1.2);
%  view(90,0)  % YZ
%  hold on
%  plot3(postOpICP(1,2),postOpICP(1,3),postOpICP(1,4),'ro','MarkerSize', 5, 'MarkerFaceColor', 'r')
%  hold on
%  plot3(postOpICP(end,2),postOpICP(end,3),postOpICP(end,4),'kv','MarkerSize', 5, 'MarkerFaceColor', 'k')
%  hold on
%  plot3(postOpICP(maxIndexPostOp,2),postOpICP(maxIndexPostOp,3),maxNumPostOp,'mx','MarkerSize', 10, 'MarkerFaceColor', 'm')
%  legend('Pre Op  ICP', 'Pre Op  Initial ICP', 'Pre Op  Final ICP', 'Pre Op Max Opening ICP' ,'Post Op ICP', 'Post Op Initial ICP', 'Post Op Final ICP', 'Post Op Max Opening ICP');
%  ylabel('Y axis [mm]');
%  zlabel('Z axis [mm]');
%  title('Lower mid incisor path (Tansverse View)');
%  saveas(gcf,strcat(outputfilename,'/TransverseView.pdf')); 


% save('preOpICP.txt','preOpICP');
% save('postOpICP.txt','postOpICP');