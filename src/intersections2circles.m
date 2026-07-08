% (xCircle1,yCircle1), radiusCircle1 & (xCircle2,yCircle2), radiusCircle2 - centre & radii of 2 circles
% intersections - coordinates of intersections, one intersection per row; there will be 0, 1 or 2 rows

function intersections = intersections2circles(radiusCircle1,xCircle1,yCircle1,radiusCircle2,xCircle2,yCircle2)
    
    % Difference in centers
    dx = xCircle2 - xCircle1;
    dy = yCircle2 - yCircle1;
    
    % Distance between the two centers
    d = sqrt(dx^2 + dy^2);
    
    % If the circles are the same or too far apart to intersect, return an empty array
    if d > (radiusCircle1 + radiusCircle2) || d < abs(radiusCircle1 - radiusCircle2) || d == 0
        intersections = [];
        return;
    end
    
    % Calculate the intersection points
    a = (radiusCircle1^2 - radiusCircle2^2 + d^2) / (2 * d);  % Distance from circle 1 center to the intersection line
    h = sqrt(radiusCircle1^2 - a^2);  % Height from the intersection line to the intersection points
    
    % Midpoint between the two circle centers
    xm = xCircle1 + a * (dx) / d;
    ym = yCircle1 + a * (dy) / d;
    
    % Intersection points
    x1_intersection = xm + h * (dy) / d;
    y1_intersection = ym - h * (dx) / d;
    x2_intersection = xm - h * (dy) / d;
    y2_intersection = ym + h * (dx) / d;
    
    if a == 0
        intersections = [xm, ym]; % One point of intersection
    else
        intersections = [x1_intersection, y1_intersection; x2_intersection, y2_intersection]; % Two points of intersection
    end
    return;
end
