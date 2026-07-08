% (xCircle1,yCircle1), (xCircle2,yCircle2), (xCircle3,yCircle3) - centres of 3 circles
% matrixT - translation matrix
% matrixR - rotation matrix
% matrixCombined - translation and rotation matrix
function [matrixT, matrixR, matrixCombined] = transformationMatrices(xCircle1, yCircle1, xCircle2, yCircle2, xCircle3, yCircle3)
    %Translate the matrix to move the third circle's center to the origin
    matrixT = [1, 0, -xCircle3; 
               0, 1, -yCircle3;
               0, 0, 1];
    
    % Calculate the angle for the rotation
    % Gradient of the line joining the centres of circle 1 and circle 2
    deltaX = xCircle2 - xCircle1;
    deltaY = yCircle2 - yCircle1;
    theta = atan2(deltaY, deltaX);  % Angle of rotation in radians
    
    % Rotation Matrix
    matrixR = [cos(theta), -sin(theta), 0;
               sin(theta), cos(theta), 0;
               0, 0, 1];
    
    % Combined Transformation Matrix
    matrixCombined = matrixT * matrixR;
end


