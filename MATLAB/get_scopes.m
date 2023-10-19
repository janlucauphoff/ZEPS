function get_scopes(out, selection,  save_figure, colormap)
%% Function to plot results from simulation output
% Author: Jan Luca Uphoff
% Project: ZEPS

%% Check if figures shall be save
if ~exist('save_figure','var')
      save_figure = false;
end

if ~exist('colormap','var')
      colormap = [... %finnja3
            175 49 255;     % Fuel Cell
            253 124 8;      % Solar
            25 196 255;     % Wind
            95 199 36;      % Battery
            181 1 113;      % Hotel Services
            32 80 25;       % Bow Thruster
            0 0 148;        % Fresh Water
            15 116 141;     % Waste Water
            198 0 7;        % Engines
            95 199 36;      % Battery
            ]/256;

end
SourceColors = colormap(1:4,1:3);
LoadColors = colormap(5:10,1:3);


s = inputname(1);
idx = find(s >= '0' & s <= '9',1);
if isempty(idx)
    scenario = s(find(s >= 'A' & s <= 'Z'):end);
else
    scenario = s(find(s >= 'A' & s <= 'Z'):find(s >= '0' & s <= '9')-1);
end

selection = num2str(selection)-'0';

switch scenario
    case 'Cruise'
        steps = minutes(5);
    case 'Transfer'
        steps = minutes(5);
    case 'Harbour'
        steps = hours(1);
    otherwise
        disp('Scenario not found. Assumed Cruise');
        s = 'Temp';
        steps = minutes(1);
end
t_end = out.tout(end)/3600;
new_idx = hours(0):steps:hours(t_end);

%% System names
Load = {'Hotel Services','Bow Thruster','Fresh Water','Waste Water','Engines','Battery charger'};
Source = {'PEM Fuel Cell','Solar','Generator','Battery'}; % TODO add Wind

%% Power scope
if selection(1)
    f1 = figure('Name', ['Scope: Power ',s],'Position', [0  0 1800 600]);

    %Remaining Power
    subplot(311)
    T = array2timetable(out.Power{1}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h1 = plot(new_idx,TT.Variables,'LineWidth',1);
    h1(1).Color = SourceColors(1,:);
    h1(2).Color = SourceColors(4,:);
    title('Remaining Energy')
    ylabel('%')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    legend({'Hydrogen level', 'Battery level'},'Location', 'northeast','Orientation','horizontal')

    % Sources
    subplot(312)
    T = array2timetable(out.Power{2}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');
    h2 = plot(new_idx,TT.Variables,'LineWidth',1);
    for k=1:length(h2)
        h2(k).Color = SourceColors(k,:);
    end
    title('Source Power')
    ylabel('Power [kW]')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    legend(Source,'Location', 'northeast','Orientation','horizontal')


    %Loads
    subplot(313)
    T = array2timetable(out.Power{3}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');
    h3 = plot(new_idx,TT.Variables,'LineWidth',1);
    for k=1:length(h3)
        h3(k).Color = LoadColors(k,:);
    end
    title('Load Power')
    ylabel('Power [kW]')
    xlabel('Hours')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    legend(Load,'Location', 'northeast','Orientation','horizontal')
    
    if save_figure 
        exportgraphics(f1, ['results/',s,'Power.pdf'],'ContentType','vector'); 
    end
end
    
%% Battery
if selection(2)
    f2 = figure('Name', 'Scope: Battery','Position', [20 200 1800 600]);

    % Voltage
    subplot(311)
    T = array2timetable(out.Battery{1}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h1 = plot(new_idx,TT.Variables,'Color', SourceColors(4,:),'LineWidth',1);
    title('Bus Voltage')
    ylabel('Voltage [V]')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    %ylim([min(min(TT.Variables))*.99 max(max(TT.Variables))*1.01])


    % Current
    subplot(312)
    T = array2timetable(out.Battery{2}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h2 = plot(new_idx,TT.Variables,'Color', SourceColors(4,:),'LineWidth',1);
    title('Current')
    ylabel('Current [A]')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    %ylim([min(min(TT.Variables))*0.99 max(max(TT.Variables))*1.01])


    % State of Charge
    subplot(313)
    T = array2timetable(out.Battery{3}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h3 = plot(new_idx,TT.Variables,'Color', SourceColors(4,:),'LineWidth',1);
    title('Charging level')
    ylabel('Charging level [%]')
    xlabel('Hours')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    
    if save_figure 
        exportgraphics(f2, ['results/',s,'Battery.pdf'],'ContentType','vector');    
    end
end

%% Environment
if selection(3)
    f3 = figure('Name', ['Scope: Environment ',s],'Position', [20 200 1800 600]);

    % Sun
    subplot(311)
    T = array2timetable(out.Environment{1}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h1 = plot(new_idx,TT.Variables,'Color', SourceColors(2,:),'LineWidth',1);
    title('Irradiance')
    ylabel('Irradiance [W/m2]')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])


    %Temperature
    subplot(312)
    T = array2timetable(out.Environment{2}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h2 = plot(new_idx,TT.Variables,'Color', SourceColors(2,:),'LineWidth',1);
    title('Temperature')
    ylabel('Temperature [°C]')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])


    %Wind
    subplot(313)
    T = array2timetable(out.Environment{3}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h3 = plot(new_idx,TT.Variables,'Color', SourceColors(3,:),'LineWidth',1);
    title('Windspeed')
    ylabel('Windspeed [m/s]')
    xlabel('Hours')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    
    if save_figure 
        exportgraphics(f3, ['results/',s,'Environment.pdf'],'ContentType','vector');
    end
end

%% RPM
if selection(4)
    f4 = figure('Name', ['Scope: RPM',s],'Position', [20 200 1800 200]);
    
    T = array2timetable(out.RPM{1}.Values.Data,'RowTimes',seconds(out.tout));
    TT = retime(T,new_idx,'nearest');

    h3 = plot(new_idx,TT.Variables,'Color', LoadColors(5,:),'LineWidth',1);
    title('RPM')
    ylabel('RPM ')
    xlabel('Hours')
    xlim([hours(0) hours(t_end)])
    ylim([0 max(max(TT.Variables))*1.05])
    
    if save_figure 
        exportgraphics(f4, ['results/',s,'RPM.pdf'],'ContentType','vector');
    end
end

%% Energy Budget
if selection(5)
    f5 = figure('Name', ['Energy distribution ',s],'Position', [20 200 1000 400]);
    tiledlayout(1,2);
    
    ax1= nexttile;
    h1 = pie(ax1, out.SourceE.Data(end,1:end-1));
    hold on;
    for k = 1:width(out.SourceE.Data)-1
        set(h1(k*2-1), 'FaceColor', SourceColors(k,:),'FaceAlpha',0.9);
    end
    title('Electrical sources')
    values = strcat(""+round(out.SourceE.Data(end,1:end-1)).'+ " kWh");    
    t = {};
    for i=1:length(Source)
    t{1,i} = strcat(Source(i), string(newline), values(i,:));
    end
    legend(t, 'Location','westoutside')

    ax2 = nexttile;
    if any(out.LoadE.Data(end,1:end-1) < 0)
        out.LoadE.Data(end,find(out.LoadE.Data(end,1:end-1)<0)) = 0;
    end
    h2 = pie(ax2, out.LoadE.Data(end,1:end-1),'%.1f%%');
    for k = 1:width(out.LoadE.Data)-1
        set(h2(k*2-1), 'FaceColor', LoadColors(k,:),'FaceAlpha',0.9);
    end
    title('Electrical loads')
    values = strcat(""+round(out.LoadE.Data(end,1:end-1)).'+ " kWh");
    t = {};
    for i=1:length(Load)
    t{1,i} = strcat(Load(i), string(newline), values(i,:));
    end
    legend(t, 'Location','eastoutside')
    
    if save_figure 
        exportgraphics(f5, ['results/',s,'Distribution.pdf'],'ContentType','vector');
    end
end
end
