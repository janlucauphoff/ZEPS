function Schedule = f_import_Schedule(file)
%% Function to import the schedule from July 2020
% Author: Jan Luca Uphoff
% Project: ZEPS

opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "Tabelle1";
opts.DataRange = "A2:C10";

% Specify column names and types
opts.VariableNames = ["Port", "Arrival", "Departure"];
opts.VariableTypes = ["char", "datetime", "datetime"];

% Specify variable properties
opts = setvaropts(opts, "Port", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Port", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Arrival", "InputFormat", "");
opts = setvaropts(opts, "Departure", "InputFormat", "");

% Import the data
Schedule = readtable(file, opts, "UseExcel", false);
Schedule.Arrival.Format = "dd.MM.yyyy HH:mm:ss";
Schedule.Departure.Format = "dd.MM.yyyy HH:mm:ss";
end