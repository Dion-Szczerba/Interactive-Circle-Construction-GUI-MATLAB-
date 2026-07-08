% (xCircle1,yCircle1), radiusCircle1 & (xCircle2,yCircle2), radiusCircle2 - centre & radii of 2 circles
% (xPoint,yPoint) - point
% (xOnCircle,yOnCircle) - closest point on one of the circles
% select - which circle is closest (1 or 2)

function [xOnCircle, yOnCircle, select] = closestPointsOnCircle(xCircle1,yCircle1,radiusCircle1,xCircle2,yCircle2,radiusCircle2,xPoint,yPoint)
    distC1 = sqrt(((xPoint-xCircle1).^2)+((yPoint - yCircle1).^2));
    distC2 = sqrt(((xPoint-xCircle2).^2)+((yPoint - yCircle2).^2));

    distC1 = distC1 - radiusCircle1;
    distC2 = distC2 - radiusCircle2;

    if distC1 < distC2
        select = 1;
        xCentre = xCircle1;
        yCentre = yCircle1;
        radius = radiusCircle1;
    else
        select = 2;
        xCentre = xCircle2;
        yCentre = yCircle2;
        radius = radiusCircle2;
    end
% Vector from circle center to the point
dx = xPoint - xCentre;
dy = yPoint - yCentre;

% Normalize the vector (to get direction)
vectorLength = sqrt(dx^2 + dy^2);
unitDx = dx / vectorLength;
unitDy = dy / vectorLength;

% Closest point on the circle's circumference
xOnCircle = xCentre + (radius * unitDx);
yOnCircle = yCentre + (radius * unitDy);
end