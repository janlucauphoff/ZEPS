%% Import of secondsol solar array data
% Author: Jan Luca Uphoff
% Project: ZEPS

clear;
close all;
clc
%%

opts = delimitedTextImportOptions("NumVariables", 12);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Manufacturer", "Model", "WattPeak", "Current", "Voltage", "ShortCurrent", "OpenVoltage", "Width", "Length", "Weight"];
opts.SelectedVariableNames = ["Manufacturer", "Model", "WattPeak", "Current", "Voltage", "ShortCurrent", "OpenVoltage", "Width", "Length", "Weight"];
opts.VariableTypes = ["string", "string", "categorical", "string", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Model"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Manufacturer", "Model"], "EmptyFieldRule", "auto");

% Import the data
solar = readtable("/Users/janluca/Projects/git/Masterthesis/MATLAB/secondsol.csv", opts);
solar = rmmissing(solar);
solar.Area = (solar.Width/1000) .* (solar.Length/1000);

clear opts
solar = unique(solar);
%%
save('solar.mat', 'solar')
clearvars -except solar
