function f = f_analyze_Histogram(data, sigma)
%% Function to analyze load power occurence frequency
% Author: Jan Luca Uphoff
% Project: ZEPS

f = figure('Name', 'Power Histogram');
hold on;
edges = 5:100;
histogram(data.I11min, 'BinEdges',edges, 'DisplayStyle', 'stairs', 'EdgeColor', 'r', 'LineWidth', 1)
histogram(data.I21min, 'BinEdges',edges, 'DisplayStyle', 'stairs', 'EdgeColor', 'g', 'LineWidth', 1)
histogram(data.I31min, 'BinEdges',edges, 'DisplayStyle', 'stairs', 'EdgeColor', 'b', 'LineWidth', 1)
ylabel('Number of occurences')
xlabel('Current [A]')

[x_mean, x_std, x_lim] = f_analyze_Statistics(data,sigma);
xline(x_lim(1), ':r', 'Linewidth', 1)
xline(x_lim(2), ':g', 'Linewidth', 1)
xline(x_lim(3), ':b', 'Linewidth', 1)
end