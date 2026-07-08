% (xCircle1,yCircle1) & (xCircle2,yCircle2) - centre of 2 circles
% (xPoint1,yPoint1) - point on the circumference of circle #1
% radiusCircle2 - radius of circle #2

function [radius, valid] = radiusTangentialCircle(circleData, newCentre)
    firstCircle = circleData(end, :); %Get data from the most recent circle
    firstCentre = firstCircle(1:2); %Get centre of the first circle
    firstRadius = firstCircle(3); %Get radius of first circle

    % Compute distance between the two centers
    distance = sqrt(sum((newCentre - firstCentre).^2));

    % Compute the radius of the tangential circle
    radius = distance - firstRadius;

    % Validity check: radius must be positive
    valid = radius > 0;
    if ~valid
        disp("Error: Invalid tangential circle (overlapping or center too close)");
    end
end
