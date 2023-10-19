close all;
clear;
clc;

load measurement;
load dataset;
load solar.mat;
%% power consumption
data = f_analyze_Downsample(PEL1, 60);
start = datetime("04.07.2020 12:00:00", 'InputFormat', "dd.MM.yyyy HH:mm:SS");
stop = datetime("11.07.2020 00:00:00", 'InputFormat', "dd.MM.yyyy HH:mm:SS");

f1 = figure('Name', 'PEL Overview','Position', [20 200 1200 300]);
hold on;
%points = plot(PEL1.Datum, (PEL1.P11min+PEL1.P21min+PEL1.P31min)/1000,'.', 'MarkerSize', 0.1);
b = bar(data.Datum, [data.P11min, data.P21min, data.P31min]/1e3, 'stacked');
b(1).FaceColor = 'r';
b(2).FaceColor = 'g';
b(3).FaceColor = 'b';
ylabel('Power [kW]')
xticks([start:hours(4):stop])
xtickformat('HH:mm')
xtickangle(90)

xmean = (mean(data.P11min + data.P21min + data.P31min))/1e3;
yline(xmean, 'k--')

plot([Schedule.Departure,Schedule.Departure],[0,35], 'r--')
for i=1:size(Schedule,1)-1
    txt = string(Schedule.Port(i)) + ' - ' + string(Schedule.Port(i+1));
    text(Schedule.Departure(i),17,txt, 'rotation', 90, 'VerticalAlignment', 'bottom');
end

%% Export figure
exportgraphics(f1, '../images/power_measurement.pdf','ContentType','vector')

%% Bow thruster
f5 = figure('Name', 'Bow thruster', 'Position', [200 200 1200 200]);
data = PEL3;
plot(data.Datum, (data.P11min+data.P21min+data.P31min)/1000)
xlabel('Date')
ylabel('Power [kW]')
ylim([0 100])
grid on;

%% Export Figure
exportgraphics(f5, '../images/bow_thruster.pdf','ContentType','vector')

%% solararray data
solar = solar(0.2 <solar.Area & solar.Area < 2, :);

f2 = figure('Name', 'Solar cell power','Position', [20 200 1200 300]);
hold on;
scatter( solar.Area,solar.WattPeak, 'b.')
ylabel('Power [Wp]')
xlabel('Cell size [m2]')
title('Solar cell power over size')
yline(200, 'r--')
yline(300, 'r--')
hold off;

%% Export figure
%exportgraphics(f2, '../images/solar_cells.pdf','ContentType','vector')
exportgraphics(f2, '../images/solar_cells.jpg','Resolution',450)

%% solar price
x = [2010:2025]';
y = [1183 917 721 663 588 381 293 219 180 156 135]';
k = length(y);

% Least Square Estimation
Y = log(y);
X = [ones(k,1) x(1:k)];
theta = Y' * X/(X'*X);
f = exp([ones(length(x),1) x] * theta');

f3 = figure('Name', 'Battery price', 'Position', [200 200 600 300]);
hold on;
%plot(x,f, 'r--', 'DisplayName','Least Square Estimation', 'LineWidth', 2);
b1 = bar(x(1:k),y, 'b', 'DisplayName','Recent price drop');
b2 = bar(x(end-4:end), round(f(end-4:end),0), 'm', 'DisplayName','Estimated price drop (LSE)');

xtips = [b1(1).XEndPoints b2(1).XEndPoints];
ytips = [b1(1).YEndPoints b2(1).YEndPoints];
labels = string([b1(1).YData b2(1).YData]);
text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

xticklabels(2010:2:2025)
xlim([2009.5 2025.5])
ylim([0 1250])
xlabel('Year')
ylabel('Price in $/kWh')
title('Battery pack price development')
legend;
hold off;

%% Export figure
exportgraphics(f3, '../images/battery_price.pdf','ContentType','image')


%% Shipping emission
f4 = figure('Name', 'Shipping Emission', 'Position', [200 200 600 400]);
x = flip([25 29 18 1 124 46 68 27 1 35 205 55 166]);
ylabels = {'Vehicle', 'Ro-Ro', 'Refrigerated Bulk', ...
    'Other liquids tankers', 'Oil tankers', ...
    'Liquefied gas tanker', 'General cargo', 'Ferry-RoPax', ...
    'Ferry-pax only', 'Cruise', 'Container', 'Chemical tanker', ...
    'Bulk carrier'};

hold on; 
for i = 1:length(x)
    h(i) = barh(i, x(i), 'FaceColor', '#0072BD');
end
set(h(4), 'FaceColor', '#D95319')
hold off

text([h.YEndPoints],[h.XEndPoints], string([h.YData]),'HorizontalAlignment','left',...
    'VerticalAlignment','middle')


yticks(1:length(x))
yticklabels(flip(ylabels))
xlabel(['\textbf{CO$_2$ emissions (million tonnes)}'],'Interpreter','latex')
%legend('IMO data')

%% Export Figure
exportgraphics(f4, '../images/shipping_emission.pdf','ContentType','image')

%% propeller curve
f6 = figure();
c = 1.71150818e-4;

x = 500:10:1500;
plot(x, c*0.001*x.^3, '--')
xlabel('RPM');
ylabel('Power');
title(["Estimated propeller power curve for p=",string(c)])
%%
exportgraphics(f6, '../images/validation_engine.pdf','ContentType','vector')

%% Irradiance
sun = get_irradiance(50, 14, "01.01.2016");

f7 = figure('Name', 'Irradiance','Position', [20 200 1200 300]);
plot(sun.Date, sun.irradiance)
ylabel("Year 2016");
ylabel('Irrandiance W/m2');
title("Irradiance over time");

%%
exportgraphics(f7, '../images/sun_irradiance.pdf','ContentType','vector')

%% correlation RPM and speed
data = get_scenario(1);

idx = diff(data.rpm)<50;
change = find(diff(data.rpm)>10);
idx = [];

for i = 1:length(change)
    idx = [idx, change(i)-10:change(i)+10];
end
idx = unique(idx);
x = 1:height(data);
x(idx) = [];

new = data(x,:);
%%

f8 = figure('Name', 'speed and rpm', 'Position', [200 200 1000 400]);
scatter( new.rpm, new.Speedkmh, 'rx');
grid()
xlabel('Engine RPM [min^{-1}]')
ylabel('Speed [km/h]')

%%
exportgraphics(f8, '../images/speed.pdf','ContentType','vector')

%% current measurement
f9 = figure('Name', 'current', 'Position', [200 200 1000 400]);
x = [33, 111, 199, 325, 489, 554, 708];
y = [1.1, 1.3, 1.6, 1.8, 2.1, 2.3, 2.4];
ymax = [1.6, 1.9, 2.5, 2.5, 2.7, 2.9, 3.1];

hold on
plot(x,ymax*3.6,'ro-',x,y*3.6,'kx-')
xline(170, 'b--')
xline(221, 'b--')
hold off
grid();
xlabel('Water level [cm]')
ylabel('Current [km/h]')
legend('Maximum surface current', 'Mean current')

%%
exportgraphics(f9, '../images/current.pdf','ContentType','vector')

%% images from simulation results
load ZEPS_results.mat

%% optimized model
get_scopes(optCruise, '11111', true)
get_scopes(optTransfer, '10000', true)
get_scopes(optHarbour, '10001', true)

% minimal model
get_scopes(minCruise, '11001', true)
get_scopes(minTransfer80, '10010', true)
get_scopes(minTransfer100, '10000', true)
get_scopes(minHarbour, '10001', true)

% recommended model
get_scopes(recCruise, '11011', true)
get_scopes(recTransfer80, '10000', true)
get_scopes(recTransfer100, '10000', true)
get_scopes(recTransfer80NoFC, '10000', true)
get_scopes(recTransfer100NoFC, '10000', true)
get_scopes(recHarbour, '10001', true)
disp('Finished');

%% model validtion
%% Battery
valBat = out;
get_scopes(valBat, '11000', true)
%% Hotel
valHotel = out;
get_scopes(valHotel, '10000', true)
%% Fuel cell
valFC = out;
get_scopes(valFC, '10000', true)
%% Solar
valSolar = out;
get_scopes(valSolar, '10100', true)
valSolar.SourceE.Data(end)
max(valSolar.Power{2}.Values.Data)
max(valSolar.Environment{1}.Values.Data)

%% sun irradiance
f2 = figure('Position', [20 200 1800 200]);
plot(sun.Date, sun.irradiance, 'Color', [253 124 8]/256)    
title('Irradiation over time')
ylabel('Irradiance [W/m^2] ')
exportgraphics(f2, ['results/irradiance.pdf'],'ContentType','vector');
%% wind
valWind = out;
get_scopes(valWind, '10100', true)

%%
newCruise = out;
get_scopes(newCruise, '10001', true)
