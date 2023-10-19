%% Cruise demand
load cruiseStatistics.mat

%% cruises in Germany
f1 = figure('Name', 'Cruises Germany', 'Position', [200 200 800 300]);
b1 = bar(cruisesGermany.Year,cruisesGermany.Passengers);
set(gca, 'XTick', cruisesGermany.Year)
set(gca,'XTickLabelRotation',45)
ylabel("Number of Passengers (1000)")
xlabel("Year")
title("Number of passengers on river cruises in Germany from 2004 to 2019")

text(b1.XEndPoints,b1.YEndPoints,string(b1.YData),'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

%% cruises by country 
f2 = figure('Name', 'Cruises by Country', 'Position', [200 200 800 400]);
b2 = barh(flip(cruisesByCountry.Passengers));
set(gca, 'YTick',1:height(cruisesByCountry))
set(gca, 'YTickLabel',flip(cruisesByCountry.Country))
xlabel("Number of Passengers (1000)")
title("European cruise passenger volume 2018, by source country")
text(b2.YEndPoints,b2.XEndPoints, string(b2.YData),'HorizontalAlignment','left',...
    'VerticalAlignment','middle')
%% Export graphics
exportgraphics(f1, '../images/cruisesGermany.pdf','ContentType','vector')
exportgraphics(f2, '../images/cruisesByCountry.pdf','ContentType','vector')
