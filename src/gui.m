function gui
    figure = uifigure('Name', 'Graph', 'Position',[100,100,900,700]); %Create a blank window
    axes = uiaxes(figure, 'Position', [50,100,550,550]); %Creates an axis for the graph
    hold(axes, 'on')
    grid(axes, 'on')
    axis(axes, [0 100 0 100]) %Increments on the graph

    %Data storage
    points = [];
    pointHandles = [];
    tempPoints = [];
    circleData = [];
    circleMode = false; %Check to see if user wants to draw circle
    tanCircleMode = false; %Check to see if user want to draw tangential circle
    circleHandles = [];
    storeSelect = [];
    thirdCircle = false;
    bisectorMode = false;
    finalCircleData = [];
    finalCentre = [];
    visibility = struct('points', true, 'lines', true)

    %Buttons
    %Button to hide points on graph
    btnHidePoints = uibutton(figure, 'Position', [50,50,100,30], 'Text', 'Hide Points', 'ButtonPushedFcn', @(~, ~) toggleVisibility());
    %Button to draw a circle
    btnDrawCircle = uibutton(figure, 'Position', [200, 50, 150, 30], 'Text', 'Draw Circle', 'ButtonPushedFcn', @(~, ~) activateCircleMode());
    %Button to draw tangential circle
    tangentialCircle = uibutton(figure, 'Position', [400, 50 ,150,30], 'Text','Draw Tangential Circle', 'ButtonPushedFcn', @(~, ~) activateTangentialMode());
    btnThirdCircle = uibutton(figure, 'Position', [750, 50, 150, 30], 'Text', 'Draw third circle', 'ButtonPushedFcn', @(~, ~) activateThirdCircle());
    btnBisector = uibutton(figure, 'Position', [600, 50, 150, 30], 'Text', 'Draw Bisector', 'ButtonPushedFcn', @(~, ~) activateBisector());
    btnApplyTransformation = uibutton(figure, 'Position', [900, 50, 150, 30], 'Text', 'Apply Transformation', 'ButtonPushedFcn', @(~, ~) applyTransformation());
    btnSaveData = uibutton(figure, 'Position', [50, 10, 100, 30], 'Text', 'Save Data', 'ButtonPushedFcn', @(~, ~) saveData());
    btnLoadData = uibutton(figure, 'Position', [200, 10, 100, 30], 'Text', 'Load Data', 'ButtonPushedFcn', @(~, ~) loadData());


    figure.WindowButtonDownFcn = @mousePress; %When anything is pressed call function mousePress

function mousePress(~, ~)
    mp = axes.CurrentPoint(1, 1:2); %Get mouse position
    if circleMode %Check to see if circleMode is true
        tempPoints = [tempPoints; mp]; %Store temporary coordinates for circle
        plot(axes, mp(1), mp(2), 'bo', 'MarkerSize', 8, 'DisplayName','Circle Point'); %Plot the centre of the circle
        if size(tempPoints, 1) == 2 %Checks to see if there are 2 points for the circle
            drawCircle(tempPoints(1, :), tempPoints(2, :)); %Calls drawCircle function
            tempPoints = [];
            circleMode = false; %Turn off drawing circles
        end
    elseif tanCircleMode  
        if isempty(circleData) %Check if first circle has been drawn
            disp("Error, draw circle first")
            return;
        end
        plot(axes, mp(1), mp(2), 'go', 'MarkerSize', 8, 'DisplayName', 'Tangential Centre') %Plot the centre of the second circle

        [radius, valid] = radiusTangentialCircle(circleData, mp);
        if valid
            % Draw the tangential circle
            drawCircle(mp, mp + [radius, 0]); % Example: Use radius to draw a circle
            tanCircleMode = false; % Exit tangential circle mode

            [m, c] = centreBisector(circleData(1, 1), circleData(1, 2), circleData(2, 1), circleData(2, 2));

            if isinf(m)
                % Vertical line: x = midX
                xLine = repmat(c, 1, 2); % x-coordinates
                yLine = axes.YLim; % Full range of y-coordinates
            else
                % Normal line: y = mx + c
                xLine = linspace(axes.XLim(1), axes.XLim(2), 100); % Range of x-coordinates
                yLine = m * xLine + c; % Corresponding y-coordinates
            end

            plot(axes, xLine, yLine, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Bisector');
        end
    elseif thirdCircle
        tempPoints = [tempPoints; mp];
        plot(axes, mp(1), mp(2), 'bo', 'MarkerSize', 8, 'DisplayName','Circle Point');
        [xOnCircle, yOnCircle, select] = closestPointsOnCircle(circleData(1,1), circleData(1,2), circleData(1,3), ... % Circle 1 data
                                                       circleData(2,1), circleData(2,2), circleData(2,3), ... % Circle 2 data
                                                       mp(1), mp(2)); % Coordinates of the clicked point
        finalCircleData = [finalCircleData; xOnCircle, yOnCircle];
        storeSelect = [storeSelect; select];
        if size(storeSelect, 1) == 2 && storeSelect(1) ~= storeSelect(2)
            [xCircle, yCircle, radiusCircle] = circleSolve(finalCircleData(2, :),finalCircleData(3, :),finalCircleData(1, :));
            finalCentre = [xCircle, yCircle];
            drawCircle(finalCentre, radiusCircle)
            thirdCircle = false; 
            intersections1 = intersections2circles(circleData(1,3), circleData(1,1), circleData(1,2), xCircle, yCircle, radiusCircle);
            intersections2 = intersections2circles(circleData(2,3), circleData(2,1), circleData(2,2), xCircle, yCircle, radiusCircle);
            intersections = [intersections1; intersections2];
            for i = 1:size(intersections, 1)
                plot(axes, intersections(i, 1), intersections(i, 2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Intersection');
            end
            return;
        end
        
    elseif bisectorMode
        tempPoints = [tempPoints; mp];
        [m, c] = centreBisector(circleData(1, 1), circleData(1, 2), circleData(2, 1), circleData(2, 2));
        [xOnBisector, yOnBisector] = closestPointBisector(m,c,mp(1), mp(2));
        finalCircleData = [finalCircleData; xOnBisector, yOnBisector];
        c = yOnBisector - ((-1/m)*xOnBisector);
        xLine2 = linspace(axes.XLim(1), axes.XLim(2), 100); % Range of x-coordinates
        yLine2 = -(1/m) * xLine2 + c; % Corresponding y-coordinates5
        plot(axes, xLine2, yLine2, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Bisector');
        bisectorMode = false;

    else
    points = [points; mp]; %Store the coordinates of point
    pointHandles(end+1) = plot(axes, mp(1), mp(2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Point'); %Plot the marker on the axis
    end
end

function toggleVisibility
    visibility.points = ~visibility.points;
    set(pointHandles, 'Visible', visibilityState(visibility.points)); %Set the visibility based on return from visibilityFlags function
    btnHidePoints.Text = visibilityLabel(visibility.points); %Set the label on the button by calling visibiltyLabel function
end
function state = visibilityState(flag)
    if flag
        state = 'on';
    else
        state = 'off';
    end
end
function label = visibilityLabel(flag) %Changes label on button
    if flag
        label = 'Hide points';
    else
        label = 'Show points';
    end
end
function activateCircleMode() %Runs when draw circle button is clicked
    circleMode = true;
    tempPoints = [];
    disp("Circle mode has been activated")
end
function drawCircle(centre, circumference)
    radius = sqrt(sum((circumference - centre).^2)); %Euclidean distance formula
    theta = linspace(0, 2*pi, 100); %Array of 100 angles
    %Parametric equations for a circle:
    x = centre(1) + radius * cos(theta);
    y = centre(2) + radius * sin(theta);
    circleHandles(end+1) = plot(axes, x,y,'b-', 'LineWidth', 1.5, 'DisplayName', 'Circle'); %Plot circle on the axis
    circleData = [circleData; centre, radius]; %Store circle data

end
function activateTangentialMode()
    if isempty(circleData) %Check if first circle has been drawn
        disp("You need to draw the first circle before you can draw a tangential circle")
        return;
    end
    tanCircleMode = true;
    disp("Tangential circle can be drawn now.")
end
function activateThirdCircle()
    if isempty(circleData)
        disp("You need to draw the first or second circle before you can do this")
        return;
    end
    thirdCircle = true;
    disp("Drawing third circle now")

end
function activateBisector()
    if isempty(circleData)
        disp("You need to press the buttons in order")
        return;
    end
    bisectorMode = true;
    
end
function applyTransformation()
    % Ensure the third circle is drawn and transformation is needed
    if isempty(circleData) || isempty(finalCentre)
        disp("Error: Ensure that circles are drawn first.")
        return;
    end
    
    % Retrieve the circle data (circle 1, circle 2, and third circle center)
    x1 = circleData(1, 1); y1 = circleData(1, 2);
    x2 = circleData(2, 1); y2 = circleData(2, 2);
    x3 = finalCentre(1); y3 = finalCentre(2);
    
    % Get the transformation matrices
    [matrixT, matrixR, matrixCombined] = transformationMatrices(x1, y1, x2, y2, x3, y3);
    
    
    % Transform circles
    transformedCircles = [];
    for i = 1:size(circleData, 1)
        center = [circleData(i, 1); circleData(i, 2); 1]; % Convert to homogeneous coordinates
        transformedCenter = matrixCombined * center; % Apply the transformation
        transformedCircles = [transformedCircles; transformedCenter(1:2)'];
    end
    
    % Clear only the circles and points from the previous transformation, but not everything
    for h = circleHandles
        delete(h); % Remove all previous circles
    end
    for h = pointHandles
        delete(h); % Remove all previous points
    end
    
    % Redraw transformed circles
    for i = 1:size(transformedCircles, 1)
        drawCircle(transformedCircles(i, :), transformedCircles(i, :) + [circleData(i, 3), 0]); % Redraw circle with the same radius
    end
    
    % Transform points (if any)
    transformedPoints = [];
    for i = 1:size(points, 1)
        point = [points(i, 1); points(i, 2); 1]; % Convert to homogeneous coordinates
        transformedPoint = matrixCombined * point; % Apply the transformation
        transformedPoints = [transformedPoints; transformedPoint(1:2)'];
    end
    
    % Redraw points after transformation
    for i = 1:size(transformedPoints, 1)
        pointHandles(end+1) = plot(axes, transformedPoints(i, 1), transformedPoints(i, 2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Point');
    end
    
    disp("Transformation applied successfully.");
end
function saveData()
    % Check if there is data to save
    if isempty(points) && isempty(circleData)
        disp("No data to save.");
        return;
    end
    
    % Prompt user to choose a file location
    [file, path] = uiputfile('*.txt', 'Save Data');
    if isequal(file, 0)
        disp("Save operation canceled.");
        return;
    end
    
    fullFilePath = fullfile(path, file);
    
    % Save points and circles to the file
    fid = fopen(fullFilePath, 'w');
    fprintf(fid, "Points:\n");
    fprintf(fid, "%f %f\n", points');
    fprintf(fid, "Circles:\n");
    fprintf(fid, "%f %f %f\n", circleData');
    fclose(fid);
    
    disp("Data saved successfully.");
end
function loadData()
    % Prompt user to select a file
    [file, path] = uigetfile('*.txt', 'Load Data');
    if isequal(file, 0)
        disp("Load operation canceled.");
        return;
    end
    
    fullFilePath = fullfile(path, file);
    
    % Read the file
    fid = fopen(fullFilePath, 'r');
    points = [];
    circleData = [];
    section = '';
    
    while ~feof(fid)
        line = fgetl(fid);
        if strcmp(line, "Points:")
            section = "points";
        elseif strcmp(line, "Circles:")
            section = "circles";
        elseif ~isempty(line)
            data = sscanf(line, '%f %f %f');
            if strcmp(section, "points")
                points = [points; data(1:2)'];
            elseif strcmp(section, "circles")
                circleData = [circleData; data'];
            end
        end
    end
    fclose(fid);
    
    % Redraw all loaded data
    cla(axes); % Clear axes
    hold(axes, 'on');
    grid(axes, 'on');
    axis(axes, [0 100 0 100]); % Reset graph range
    
    % Redraw points
    for i = 1:size(points, 1)
        pointHandles(end+1) = plot(axes, points(i, 1), points(i, 2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Point');
    end
    
    % Redraw circles
    for i = 1:size(circleData, 1)
        center = circleData(i, 1:2);
        radius = circleData(i, 3);
        drawCircle(center, center + [radius, 0]);
    end
    
    disp("Data loaded successfully.");
end


end