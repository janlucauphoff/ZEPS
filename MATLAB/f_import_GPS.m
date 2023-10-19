function GPS = f_import_GPS(directory, type)
%% Function to import data from the GPS logger of the MS Patria
% Author: Jan Luca Uphoff
% Project: ZEPS

opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ["\t", ";"];

% Specify column names and types
opts.VariableNames = ["Date", "Time", "Datum", "Latitudedegrees", "Longitudedegrees", "Position", "Coursedegrees", "Headingdegrees", "Speedkmh", "Fuelconsumption", "Fueltotal1", "Fueltotal2", "Pullforce"];
opts.VariableTypes = ["datetime", "datetime", "datetime", "double", "double", "char", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Position", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Position", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Date", "InputFormat", "yyyy-MM-dd");
opts = setvaropts(opts, "Time", "InputFormat", "HH:mm:ss");
opts = setvaropts(opts, "Datum", "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts = setvaropts(opts, ["Latitudedegrees", "Longitudedegrees", "Coursedegrees", "Headingdegrees", "Speedkmh", "Fuelconsumption", "Fueltotal1", "Fueltotal2", "Pullforce"], "DecimalSeparator", ",");

% Import the data
files = dir(strcat(directory, '/*.', type));
    for i=1:length(files)
        filename = strcat(files(i).folder, '/', files(i).name);
        gps = readtable(filename, opts);
        gps = gps(:,[3 4 5 9]);
        if i==1
            GPS = gps;
        else
            GPS = [GPS;gps];
        end
    end
    GPS.Datum.Format = "dd.MM.yyyy HH:mm:ss";
    GPS(GPS.Longitudedegrees==0,:) = [];
    GPS(GPS.Latitudedegrees==0,:) = [];
    GPS = sortrows(GPS);
end

