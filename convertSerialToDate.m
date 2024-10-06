function dateTimeObj = convertSerialToDate(serialDateNumber)
    % Convert serial date number to datetime object
%     format = 'Format','MM/dd/yyyy HH:mm:ss.SSS';
%     dateTimeObj = datetime(serialDateNumber, 'ConvertFrom', 'datenum');
    dateTimeObj = datetime(serialDateNumber, 'ConvertFrom', 'datenum', 'Format','MM/dd/yyyy HH:mm:ss.SSS');
    
end