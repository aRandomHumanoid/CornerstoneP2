function finalproject()
    filename = 'data_log.csv';    % CSV file name

    % Image filenames
    imageFiles = {'park.jpg', 'school.jpg', 'farm.jpg', ...
                  'factory.jpg', 'house.jpg', 'powerplant.jpg'};
    
    % Set up Serial Communication
    s = serialport("/dev/cu.usbmodem1101", 9600);
    flush(s);             % Clear any old data
    
    % Descriptions
    imageDescriptions = {
        'Parks are like the Earths lungs — trees and plants help clean the air by soaking up carbon dioxide.';
        'Turning off lights and electronics when youre not using them can help everyone in the building use less power!';
        'Solar panels on barns help farms run tractors, lights, and machines without needing as much fossil fuel.';
        'Factories make everything from toys to toothbrushes — but they also use a lot of electricity!';
        'If everyone in the U.S. switched just one light bulb to an energy-saving LED, we’d save enough energy to light 2.5 million homes for a year!';
        'Coal power plants create energy but also release gases that can hurt our air.'
    };

    % Image Names
    imageNames = {'Park', 'School', 'Farm', 'Factory', 'House', 'Power Plant'};
    
    % Create single window
    fig = figure('Name', 'Image Gallery', ...
                 'NumberTitle', 'off', ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Position', [100, 100, 800, 600]);
    
    % Store shared data
    appData.imageFiles = imageFiles;
    appData.imageDescriptions = imageDescriptions;
    appData.imageNames = imageNames;
    appData.fig = fig;

    % Show the main page initially
    showMainPage(appData);


    
    
    % Wait for data and read input
    disp("Waiting for data...");
    values = [0, 0, 0, 0, 0, 0];
    while true
        changed = false;
        if s.NumBytesAvailable > 0
            data = readline(s); % Read incoming serial data as a string
            disp("Received: " + data);
            
            % Check if the string starts with "ArrayState:"
            if startsWith(data, "ArrayState:")
                % Extract numeric values after "ArrayState:"
                numericPart = extractAfter(data, "ArrayState:");
                
                % Convert to array (split by commas, then convert to numbers)
                prevValues = values;
                values = str2double(strsplit(numericPart, " "));
                
                % Display the received array
                disp("Parsed Array:");
                disp(values);
                changed = true;
            end
        end
        pause(0.1); % Small delay to avoid busy-waiting
        if changed == true
            disp("Previous Array:");
            disp(prevValues);
            %finds which building has channged
            for i = 1:6
                if values(i) ~= prevValues(i) && values(i) ~= 0
                    showImagePage(appData, values(i)); %show fun fact of building
                    break;
                end
            end
            %writes timestamped data to the thing
            timestamp = datetime("now");
    
            % Append to CSV
            fid = fopen(filename, 'a');
            fprintf(fid, '%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n', ...
            timestamp, values(1), values(2), values(3), values(4), values(5), values(6));
            fclose(fid);
        end
    end
end

function showMainPage(appData)
    clf(appData.fig);
    
    % Create a grid of images
    for i = 1:6
        subplot(2, 3, i, 'Parent', appData.fig);
        img = imread(appData.imageFiles{i});
        imshow(img);
        title([appData.imageNames(i)]);
        
        h = gca;
        set(h, 'ButtonDownFcn', @(src, event)showImagePage(appData, i));
        % Make sure the image itself is clickable
        if ~isempty(h.Children)
            set(h.Children, 'ButtonDownFcn', @(src, event)showImagePage(appData, i));
        end
    end
end

function showImagePage(appData, index)
    clf(appData.fig);

    % Create custom axes layout: larger top area for image, smaller bottom for text
    imgAxes = axes(appData.fig, ...
        'Position', [0.05, 0.35, 0.9, 0.6]);  % [x y width height]
    imshow(imread(appData.imageFiles{index}), 'Parent', imgAxes);
    title(imgAxes, [appData.imageNames(index)], 'FontSize', 14);

    % Centered description text
    textAxes = axes(appData.fig, ...
        'Position', [0.05, 0.05, 0.9, 0.25]);
    axis(textAxes, 'off');
    text(textAxes, 0.5, 0.5, appData.imageDescriptions{index}, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 14, ...
        'Units', 'normalized');

    % Wait before returning to the main page
    pause(3);
    showMainPage(appData);
end

