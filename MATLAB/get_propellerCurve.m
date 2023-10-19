function p = get_propellerCurve(nmin, nmax, pmin, pmax, weight ,show_figure)
%% Function to calculate and plot the estimated relationship between propeller rpm and input power
% Author: Jan Luca Uphoff
% Project: ZEPS

if ~exist('show_figure','var')
      show_figure = false;
end

if ~exist('weight','var')
      weight = 0.5;
end
% y = px^3 estimation
% p = 1.71150818e-4; %comparison with Koedood
p = [1-weight weight]*(exp((log([pmin;pmax])-3*log([nmin;nmax]))));

if show_figure==true
    figure('Name','Propeller power curve','NumberTitle','off');
    plot([nmin,nmax], [pmin,pmax], 'r*');
    hold on
    plot(nmin:nmax, p*[nmin:nmax].^3, 'b--');
    hold off
    xlim([nmin*0.95, nmax*1.05])
    ylim([0, pmax*1.05])
    xlabel("RPM")
    ylabel("Power [kW]")
    title("Propeller factor: p="+string(p*1000))
    grid on;
    legend('input parameters', 'estimated power','Location','southeast')
end
end 