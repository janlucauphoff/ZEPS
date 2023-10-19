function new_table = f_analyze_Downsample(data, n)
%% Function to downsample PEL mesurement data
% Author: Jan Luca Uphoff
% Project: ZEPS

sz = size(data);
sz = [sz(1) - mod(sz(1),n), sz(2)-1];
names = data.Properties.VariableNames;
times = data.Datum;
times = times(1:sz(1));
times = reshape(times,[n,sz(1)/n]);
times = mean(times, 1, 'omitnan')';
vals = table2array(data(1:sz(1),2:end));
sz = size(vals);
vals = reshape(vals, [n,sz(1)/n,sz(2)]);
vals = squeeze(mean(vals, 1, 'omitnan'));
new_table = array2table(vals,'VariableNames', names(2:end));
new_table = addvars(new_table, times, 'NewVariableNames', names(1), 'Before', names(2));
end