%-------------------------------SUMMARY------------------------------------
% This script generates inverse and forward excitation plots for each group
% of muscles pre and post op. The excitations signals are collected for the
% target trajectory of the the jaw in an inverse simulation, those signals
% are then smoothed and plotted. The smooth signals are used to drive the 
% forward simulations.

%-------------------------SCRIPT DEFINITIONS------------------------------  
simDur  = 0.5;
dt = 0.005;
t = [0:dt:simDur];

outputFileName = strcat('Excitation Plots');
mkdir(outputFileName);
%-------------------------MUSCLE DEFINITIONS------------------------------  
muscles = createmusclestruct('musclekey.txt'); 
 
% Muscle Groups
temporals  = muscles([1:6]);
masseters  = muscles([7:8]);
pterygoids = muscles([11:16]);
digastrics = muscles([17:18]);
mylohyoid  = muscles([19:22]);
geniohyoid = muscles([23:24]);

%-------------------------ARTISYNTH MODEL NAMES---------------------------
invModelName = ...
    'artisynth.models.kieran.tmjsurgery.TmjInverseOpenCloseSimulation';
forwardModelName = ...
    'artisynth.models.kieran.tmjsurgery.ForwardChewing';

%-------------------------------INVERSE SIM-------------------------------
[invExcitations,invICP,invICV] = inversesim(simDur,invModelName);

%------------------------SMOOTH EXCITATION SIGNAL--------------------------
smoothExcitations = smoothexcitationsignal(invExcitations(:,2:25));

%---------------------------PRE OP FORWARD SIM-----------------------------
[preopICP,preopICV,preopExcit] = ...
	forwardsim(simDur,forwardModelName,smoothExcitations,muscles);

preTempFigH   = plotexcitations(t,preopExcit,temporals,preopICP,...
                                outputFileName,"Preop Temporals Excitations");

preMassFigH   = plotexcitations(t,preopExcit,masseters,preopICP,...
                                outputFileName,"Preop Massetrs Excitations");

prePterFigH   = plotexcitations(t,preopExcit,pterygoids,preopICP,...
                                outputFileName,"Preop Pterygoids Excitations");

preDigastFigH = plotexcitations(t,preopExcit,digastrics,preopICP,...
                                outputFileName,"Preop Digastrics Excitations");

preMyloFigH   = plotexcitations(t,preopExcit,mylohyoid,preopICP,...
                                outputFileName,"Preop Mylohyoid Excitations");

preGenioFigH  = plotexcitations(t,preopExcit,geniohyoid,preopICP,...
                                outputFileName,"Preop Geniohyoid Excitations");

%---------------------------POST OP FORWARD SIM-----------------------------
[postopICP,postopICV,postopExcit] = ...
	forwardsim(simDur,forwardModelName,smoothExcitations,muscles);

postTempFigH   = plotexcitations(t,postopExcit,temporals,postopICP,...
                                outputFileName,"Postop Temporals Excitations");

postMassFigH   = plotexcitations(t,postopExcit,masseters,postopICP,...
                                outputFileName,"Postop Massetrs Excitations");

postPterFigH   = plotexcitations(t,postopExcit,pterygoids,postopICP,...
                                outputFileName,"Postop Pterygoids Excitations");

postDigastFigH = plotexcitations(t,postopExcit,digastrics,postopICP,...
                                outputFileName,"Postop Digastrics Excitations");

postMyloFigH   = plotexcitations(t,postopExcit,mylohyoid,postopICP,...
                                outputFileName,"Postop Mylohyoid Excitations");

postGenioFigH  = plotexcitations(t,postopExcit,geniohyoid,postopICP,...
                                outputFileName,"Postop Geniohyoid Excitations");

%TODO: organize plots into pre and post op left and right
% Load saved figures
files = dir(fullfile(outputFileName, '*.fig'));
names = {files.name};
figurePaths = cell(1,length(names));

for f = 1:length(names)
    figurePaths{1,f} = strcat(outputFileName,'/',names{f});
end

% Load saved figures
% c=hgload('MyFirstFigure.fig');

% Prepare subplots
figure
for iPlot = 1:12
    h(iPlot)  = subplot(12,2,iPlot);
end
% props = {'Name','CurrentAxis'};
for ihandle = 1:12
    figHandle = hgload(figurePaths{1,ihandle});
    legendHandle = findobj(allchild(figHandle),'Tag','legend');
    axesHandle = findall(figHandle, 'type', 'axes');
    copyobj(allchild(get(figHandle,'CurrentAxes')),h(ihandle));
    l(ihandle) = legend(h(ihandle),get(legendHandle,'String'));
    t(ihandle) = title(h(ihandle),axesHandle.Title.String);
    yLab(ihandle) = ylabel(h(ihandle),axesHandle.YLabel.String);
    xLab(ihandle) = xlabel(h(ihandle),axesHandle.XLabel.String);
    ylim(h(ihandle),axesHandle.YLim);
end

% figure
% subplot(6,2,1);
%     plotexcitations(t,preopExcit,temporals,preopICP,...
%                     outputFileName,"Preop Temporals Excitations");
% subplot(6,2,2);
%     plotexcitations(t,preopExcit,masseters,preopICP,...
%                     outputFileName,"Preop Massetrs Excitations");
% subplot(6,2,3);
%     plotexcitations(t,preopExcit,pterygoids,preopICP,...
%                     outputFileName,"Preop Pterygoids Excitations");
% subplot(6,2,4);
%     plotexcitations(t,preopExcit,digastrics,preopICP,...
%                     outputFileName,"Preop Digastrics Excitations");
% subplot(6,2,5);
%     plotexcitations(t,preopExcit,mylohyoid,preopICP,...
%                     outputFileName,"Preop Mylohyoid Excitations");
% subplot(6,2,6);
%     plotexcitations(t,preopExcit,geniohyoid,preopICP,...
%                 outputFileName,"Preop Geniohyoid Excitations");


% Paste figures on the subplots
% copyobj(allchild(get(preTempFigH   )),h(1));
% copyobj(allchild(get(postTempFigH  )),h(2));
% copyobj(allchild(get(preMassFigH   )),h(3));
% copyobj(allchild(get(postMassFigH  )),h(4));
% copyobj(allchild(get(prePterFigH   )),h(5));
% copyobj(allchild(get(postPterFigH  )),h(6));
% copyobj(allchild(get(preDigastFigH )),h(7));
% copyobj(allchild(get(postDigastFigH)),h(8));
% copyobj(allchild(get(preMyloFigH   )),h(9));
% copyobj(allchild(get(postMyloFigH  )),h(10));
% copyobj(allchild(get(preGenioFigH  )),h(11));
% copyobj(allchild(get(postGenioFigH )),h(12));

% Paste figures on the subplots
% copyobj(allchild(get(preTempFigH   )),h(1));
% copyobj(allchild(get(postTempFigH  )),h(2));
% copyobj(allchild(get(preMassFigH   )),h(3));
% copyobj(allchild(get(postMassFigH  )),h(4));
% copyobj(allchild(get(prePterFigH   )),h(5));
% copyobj(allchild(get(postPterFigH  )),h(6));
% copyobj(allchild(get(preDigastFigH )),h(7));
% copyobj(allchild(get(postDigastFigH)),h(8));
% copyobj(allchild(get(preMyloFigH   )),h(9));
% copyobj(allchild(get(postMyloFigH  )),h(10));
% copyobj(allchild(get(preGenioFigH  )),h(11));
% copyobj(allchild(get(postGenioFigH )),h(12));













