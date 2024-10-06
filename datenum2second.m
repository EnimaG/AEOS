function timeinsecond = datenum2second(time)
date_vector = datevec(time);
timeinsecond = (date_vector(4) * 3600) + (date_vector(5) * 60) + date_vector(6);