function [R,T] = T_Matrix_Calc(d1,m1)

d1_ave = mean(d1);
m1_ave = mean(m1);

dc1 = d1 - d1_ave;
mc1 = m1 - m1_ave;

H = mc1*dc1';



% Singular Value Decompositionfor a matrix
[U,S,V] = svd(H);

% The rotation matrix is found
R = V*U';

% If the determinate is -1
if det(R) < 0
    R = [V(1:3,1:2) -V(1:3,3)]*U';
end

% The translation matrix is found
T = (d1_ave' - R* m1_ave')';



end