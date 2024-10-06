function [lb, ub] = calculateBoundaries(min_datenum, max_datenum, tolerance_seconds)
    % Calculate the range of values in seconds

    seconds_per_day = 24 * 60 * 60; % Seconds in a day
    min_value_seconds = min_datenum * seconds_per_day; % Convert min datenum to seconds
    max_value_seconds = max_datenum * seconds_per_day; % Convert max datenum to seconds

    % Calculate lower and upper boundaries in seconds
    lb = min_value_seconds - tolerance_seconds;
    ub = max_value_seconds + tolerance_seconds;
end

