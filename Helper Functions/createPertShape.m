function [pertShape] = createPertShape(shape,window)
%createPertShape
% SUMMARY: This function accepts two paramters shape and window
%
% PARAMETERS:
%  shape  = the shape of the pertubation (unitstep or  ramp)
%  window = a vector of the start (t0) and end (t1) of the the window
% 			based on the specificed shape the function then returns a scaled
% 			vector pertShape.
%
% EXAMPLE output: 
% 	pertShape = 1		2
%				0		randnum * 1
%				0.1		randnum * 1
%				0.2		randnum * 1
%				0.3		randnum * 1
%				0.4		randnum * 1
%				0.5		randnum * 1
    
    t = window(:,2);
    unitstep = ones(size(t));
    if (strcmp(shape,"unitstep"))
        % unit step       
        pertShape = unitstep;
    elseif (strcmp(shape,"ramp"))
        % ramp unit step
        ramp = t.*unitstep;
        pertShape = ramp;
    elseif (strcmp(shape,"quad"))
        quad = t.^2.*unitstep;
        pertShape = quad;
    else
        disp('triange or heavside shape function must be specified')
    end
end