function [x_mean, x_std, x_lim]  = f_analyze_Statistics(data, sigma)
%% Function to perform a statistical analyzis of the measurement data
% Author: Jan Luca Uphoff
% Project: ZEPS

x_mean = [mean(data.I11min(data.I11min>5),'omitnan'); mean(data.I21min(data.I21min>5),'omitnan'); mean(data.I31min(data.I31min>5),'omitnan')];
x_std = [std(data.I11min(data.I11min>5),'omitnan'); std(data.I21min(data.I21min>5),'omitnan'); std(data.I31min(data.I31min>5),'omitnan')];
x_lim = round(x_mean + sigma * x_std);
end