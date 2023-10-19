function f = f_analyze_Overview(data, txt)
%% Function to analyze PEL power measurements over time
% Author: Jan Luca Uphoff
% Project: ZEPS

f = figure('Name', 'PEL Overview');
subplot(311)
plot(data.Datum, data.I11min, 'r', data.Datum, data.I21min, 'g', data.Datum, data.I31min, 'b')
grid;
title(txt)
% ylim([0 150])
ylabel('current [A]')

subplot(312)
plot(data.Datum, data.V11min, 'r', data.Datum, data.V21min, 'g', data.Datum, data.V31min, 'b')
ylim([150 250])
ylabel('voltage [V]')
xlabel('time')

subplot(313)
plot(data.Datum, (data.P11min+data.P21min+data.P31min)/1000)
ylabel('power [KW]')
end