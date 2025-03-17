close; clc; clear;

% Set up Serial Communication
serialPort = "COM5";  % Change to your Arduino's port
baudRate = 9600;      % Must match Arduino's baud rate
s = serialport(serialPort, baudRate);
flush(s);             % Clear any old data

% Wait for data and read input
disp("Waiting for data...");

while true
    if s.NumBytesAvailable > 0
        data = readline(s); % Read incoming serial data as a string
        disp("Received: " + data);
        
        % Check if the string starts with "ArrayState:"
        if startsWith(data, "ArrayState: ")
            % Extract numeric values after "ArrayState:"
            numericPart = extractAfter(data, "ArrayState: ");
            
            % Convert to array (split by commas, then convert to numbers)
            values = str2double(strsplit(numericPart, " "));
            
            % Display the received array
            disp("Parsed Array:");
            disp(values);
        end
    end
    pause(0.1); % Small delay to avoid busy-waiting
    if (isequal(values, [0,1,2,3]))
        disp("You Won!")
        break;
    end
end