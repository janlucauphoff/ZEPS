function RPM = f_import_RPM(directory, type)
%% Function to import data from the multimeter measuring the engine speed
% Author: Jan Luca Uphoff
% Project: ZEPS

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = [5, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["Datum", "V"];
opts.VariableTypes = ["datetime", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Specify variable properties
opts = setvaropts(opts, "Datum", "InputFormat", "yyyy.MM.dd HH:mm:ss");
opts = setvaropts(opts, "V", "TrimNonNumeric", true);
opts = setvaropts(opts, "V", "DecimalSeparator", ",");
opts = setvaropts(opts, "V", "ThousandsSeparator", ".");

% Import the data
files = dir(strcat(directory, '/*.', type));
for i=1:length(files)
    filename = strcat(files(i).folder, '/', files(i).name);
    rpm = readtable(filename, opts);
    if i ==1
        RPM = rpm;
    else
        RPM = [RPM; rpm];
    end
end
RPM.rpm = RPM.V*200;
RPM.V = [];
RPM = rmmissing(RPM);
RPM = sortrows(RPM);
RPM.Datum.Format = "dd.MM.yyyy HH:mm:ss";
end