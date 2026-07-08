% (xCircle,yCircle), radiusCircle - centre & radius of circle
% (xPoint1,yPoint1), (xPoint2,yPoint2), (xPoint3,yPoint3) - points on the circumference of the circle

function [xCircle, yCircle, radiusCircle] = circleSolve(p1,p2,p3)
 % Points on the circumference
    x1 = p1(1); y1 = p1(2);
    x2 = p2(1); y2 = p2(2);
    x3 = p3(1); y3 = p3(2);
    
    % Midpoints of the line segments
    midpoint12 = [(x1 + x2) / 2, (y1 + y2) / 2];
    midpoint13 = [(x1 + x3) / 2, (y1 + y3) / 2];
    
    % Gradients of the line segments
    m12 = (y2 - y1) / (x2 - x1);
    m13 = (y3 - y1) / (x3 - x1);
    
    % Gradients of the perpendicular bisectors
    m12_perp = -1 / m12; % Perpendicular slope for line 1-2
    m13_perp = -1 / m13; % Perpendicular slope for line 1-3
    
    % Equation of perpendicular bisector 1-2: y - midpoint12(2) = m12_perp * (x - midpoint12(1))
    % Equation of perpendicular bisector 1-3: y - midpoint13(2) = m13_perp * (x - midpoint13(1))
    
    % Rearranging to y = mx + b form
    b12 = midpoint12(2) - m12_perp * midpoint12(1); 
    b13 = midpoint13(2) - m13_perp * midpoint13(1);
    
    % Solve for the intersection (xCircle, yCircle)
    % m12_perp * x + b12 = m13_perp * x + b13
    % (m12_perp - m13_perp) * x = b13 - b12
    xCircle = (b13 - b12) / (m12_perp - m13_perp);
    yCircle = m12_perp * xCircle + b12; % Use either equation to find yCircle
    
    % Calculate the radius using the Euclidean distance between the center and any point
    radiusCircle = sqrt((xCircle - x1)^2 + (yCircle - y1)^2); % Using point 1 as reference
    

end
