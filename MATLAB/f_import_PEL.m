function data = f_import_PEL(file)
%% Function to import data from the power measurements with PEL103 
% Author: Jan Luca Uphoff
% Project: ZEPS

%specify power import
opts = spreadsheetImportOptions("NumVariables", 1);
opts.Sheet = "Energie und Kosten";
opts.DataRange = "C:C";
opts.VariableNames = "EpWh1min";
opts.VariableTypes = "double";
data = readtable(file, opts, "UseExcel", false);
EpWh1min = data.EpWh1min(2:end);

% specify data import
opts = spreadsheetImportOptions("NumVariables", 90);
opts.Sheet = "Aggregierte Werte";
opts.DataRange = "A:CL";

% Specify column names and types
opts.VariableNames = ["Datum", "Uhrzeit", "V11min", "Var4", "Var5", "Var6", "Var7", "V21min", "Var9", "Var10", "Var11", "Var12", "V31min", "Var14", "Var15", "Var16", "Var17", "U121min", "Var19", "Var20", "Var21", "Var22", "U231min", "Var24", "Var25", "Var26", "Var27", "U311min", "Var29", "Var30", "Var31", "Var32", "I11min", "Var34", "Var35", "Var36", "Var37", "I21min", "Var39", "Var40", "Var41", "Var42", "I31min", "Var44", "Var45", "Var46", "Var47", "IN1min", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "FHz1min", "Var60", "Var61", "Var62", "Var63", "P11min", "P21min", "P31min", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Q11min", "Q21min", "Q31min", "Var79", "Var80", "Var81", "Var82", "Var83", "Var84", "Var85", "Var86", "Var87", "S11min", "S21min", "S31min"];
opts.SelectedVariableNames = ["Datum", "Uhrzeit", "V11min", "V21min", "V31min", "U121min", "U231min", "U311min", "I11min", "I21min", "I31min", "IN1min", "FHz1min", "P11min", "P21min", "P31min", "Q11min", "Q21min", "Q31min", "S11min", "S21min", "S31min"];
opts.VariableTypes = ["datetime", "datetime", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var9", "Var10", "Var11", "Var12", "Var14", "Var15", "Var16", "Var17", "Var19", "Var20", "Var21", "Var22", "Var24", "Var25", "Var26", "Var27", "Var29", "Var30", "Var31", "Var32", "Var34", "Var35", "Var36", "Var37", "Var39", "Var40", "Var41", "Var42", "Var44", "Var45", "Var46", "Var47", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var60", "Var61", "Var62", "Var63", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Var79", "Var80", "Var81", "Var82", "Var83", "Var84", "Var85", "Var86", "Var87"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var9", "Var10", "Var11", "Var12", "Var14", "Var15", "Var16", "Var17", "Var19", "Var20", "Var21", "Var22", "Var24", "Var25", "Var26", "Var27", "Var29", "Var30", "Var31", "Var32", "Var34", "Var35", "Var36", "Var37", "Var39", "Var40", "Var41", "Var42", "Var44", "Var45", "Var46", "Var47", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var60", "Var61", "Var62", "Var63", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Var79", "Var80", "Var81", "Var82", "Var83", "Var84", "Var85", "Var86", "Var87"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Datum", "InputFormat", "dd.MM.yyyy");
opts = setvaropts(opts, "Uhrzeit", "InputFormat", "HH:mm:ss");

data = readtable(file, opts, "UseExcel", false);
data.EpWh1min = EpWh1min;
data.Datum.Format = "dd.MM.yyyy HH:mm:ss";
data.Datum = data.Datum + timeofday(data.Uhrzeit);
data.Uhrzeit = [];
data(1:3,:) = [];
data(end,:) = [];
data = rmmissing(data,1,'MinNumMissing',10);
data.P = data.P11min + data.P21min + data.P31min;
data.Q = data.Q11min + data.Q21min + data.Q31min;
end

