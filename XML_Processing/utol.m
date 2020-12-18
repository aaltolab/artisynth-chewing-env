function ltraj = utol(utraj)
% Upper jaw trajectory (maxilla moves relative to a stationary mandible) to
% lower jaw trajectory


np = length(squeeze(utraj(1,:,1)));


ltraj = zeros(3,np,3);
init = [0 0 0; 25 0 30; -25 0 30];


for i = 1:np

    [R,T] = T_Matrix_Calc(init,squeeze(utraj(:,i,:)));
    
    
    
    
    for j = 1:3
    
        ltraj(j,i,:) = R * (squeeze(init(j,:)))' + T';
    
    end
    
    
    
end


end