% m,c - parameters of bisector line y = mx + c
% (xOffBisector,yOffBisector) - point not on the bisector line
% (xOnBisector,yOnBisector) - point on the bisector line

function [xOnBisector yOnBisector] = closestPointBisector(m,c,xOffBisector,yOffBisector)

%Rearranging the y = mx +c equation

A = xOffBisector + (m*yOffBisector) - (m*c);
B = (m^2) +1;

xOnBisector = A/B;

yOnBisector = m*xOnBisector + c;

end
