% Windturbine Database
% Author: Jan Luca Uphoff
% Project: ZEPS

%% Database
manufacturer = [   "WePower";"WePower";"WePower";"WePower";"WePower";"Quietrevolution"];
%            'Quietrevoltion', 'VisionAir', 'windside','APS Global Corporation'};
model = ["Falcon 600W"; "Falcon 1.2kW"; "Falcon 3.4kW";"Falcon 5.5kW";"Falcon 12kW"; "QR6"];
power = [600, 1200, 3400,5500,12000,7000]'; % W  rated speed
cutInWind = [2.7, 2.7, 2.7, 2.7, 2.7, 1.5]'; % m/s
nomWind = [13,13,13,13,13,14]'; % m/s
cutOutWind = [49.6, 49.6, 49.6, 49.6, 49.6, 20]'; %m/s
diameter = [1.3, 1.78, 3, 4, 6, 3.13]'; % m
bladeLength = [1, 2, 3.6, 4.6, 6.2 5.1]'; % m
noise = [32,32,32,32,32,86]'; % dB

windRange = string(cutInWind) + " - " + string(cutOutWind); %m/s

VAWT = table(manufacturer, model, power, cutInWind, nomWind, cutOutWind, diameter, bladeLength);
save('windturbines', 'VAWT');

%% Table output for latex export
T = table(model, windRange, diameter, bladeLength, ...
    'VariableNames', {'Model', 'Wind range [m/s]', 'Diameter [m]', 'Blade Length [m]'});

%wind_mph = 2.23694 * wind_ms;
%wind_kmh = 3.6 * wind_ms;
%wind_kts = 1.9438445 * wind_ms;