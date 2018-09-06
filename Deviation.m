%Coronal Plane (x-z)
fprintf('Open Cor %.5f\n', norm(goalICP(51,[2 4])-postopICPForw(51,[2 4])))
fprintf('Close Cor %.5f\n',norm(goalICP(end,[2 4])-postopICPForw(end,[2 4])))

%Sagittal Plane (zy)
fprintf('Open Sag %.5f\n',norm(goalICP(51,[3 4])-postopICPForw(51,[3 4])))
fprintf('Close Sag %.5f\n',norm(goalICP(end,[3 4])-postopICPForw(end,[3 4])))

%Axial Plane (xy)
fprintf('Open Axial %.5f\n',norm(goalICP(51,[2 3])-postopICPForw(51,[2 3])))
fprintf('Close Axial %.5f\n',norm(goalICP(end,[2 3])-postopICPForw(end,[2 3])))