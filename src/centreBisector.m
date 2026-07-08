% m,c - parameters of line y = mx + c bisecting centre points
% (xCircle1,yCircle1), (xCircle2,yCircle2) - centres of 2 circles

function [m c] = centreBisector(xCircle1,yCircle1,xCircle2,yCircle2)
%Calculating the midpoint between the 2 circles
midX = (xCircle1 + xCircle2)/2;
midY = (yCircle1 + yCircle2)/2;


gradient = (yCircle2 - yCircle1)/(xCircle2 - xCircle1);
%Calculate the perpendicular gradient
m = -1/gradient;
%Use midpoint and gradient to find y intercept, c = y - mx
c = midY - m*midX;


end
