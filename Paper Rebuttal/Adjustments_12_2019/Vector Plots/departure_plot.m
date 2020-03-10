clear all; close all; clc;

cd Partner
cd Final
partner_fig = openfig('Cell_557_1_45_Departure.fig');

cd .. 
cd ..
cd Novel 
cd Final
novel_fig = openfig('Cell_557_1_45_Departure.fig');

cd ..
cd ..
cd Final_Plots
% load('tethered_trace_557_1_Novel.mat');
% novel_trace = tethered_trace;
% load('tethered_trace_557_1_Partner.mat')
% partner_trace = tethered_trace;

novel_ax = novel_fig.Children;
partner_ax = partner_fig.Children;
novel_im = novel_ax(2).Children;
partner_im = partner_ax(2).Children;
novel_plots = novel_ax(1).Children;
partner_plots = partner_ax(1).Children;

partner_x = partner_trace(:,1);
partner_y = partner_trace(:,2);
partner_lims = [min(partner_x) min(partner_y) max(partner_x)-min(partner_x) max(partner_y)-min(partner_y)];

novel_x = novel_trace(:,1);
novel_y = novel_trace(:,2);
novel_lims = [min(novel_x) min(novel_y) max(partner_x)-min(partner_x) max(partner_y)-min(partner_y)];

newax = axes;
%newax.Parent = newfig;
xlim([35 662])
ylim([189 369])

novel_figPos = ds2nfu(novel_lims);
partner_figPos = ds2nfu(partner_lims);

new_novelax = axes('pos', novel_figPos);
new_novelax.Color = 'none';
new_novelax.YDir = 'normal';
imshow(novel_im.CData)
new_partnerax = axes('pos',partner_figPos);
new_partnerax.Color = 'none';
new_partnerax.YDir = 'normal';
imshow(partner_im.CData)

newfig = figure('Visible','on');
new_novelax.Parent = newfig;
new_partnerax.Parent = newfig;
newax.Parent = newfig;
novel_plots(1).Parent = newax;
partner_plots(1).Parent = newax;
newax.Color = 'none';
newfig.Color = 'w';

%Plot walls
xend = [35 662];
yend = [189 369];
lwall = 244;
rwall = 453;

range = (yend(2)-yend(1));
range = floor(range/3);
lwidth = 1.5;

llx = [lwall lwall];
lly = [yend(1),yend(1)+range];
ulx = [lwall lwall];
uly = [yend(2)-range,yend(2)];
lrx = [rwall rwall];
lry = [yend(1),yend(1)+range];
urx = [rwall rwall];
ury = [yend(2)-range,yend(2)];

hold(new_novelax,'on')
hold(new_partnerax,'on')
hold(newax,'on')
plot(llx,lly,'k','LineWidth',lwidth);
plot(ulx,uly,'k','LineWidth',lwidth);
plot(lrx,lry,'k','LineWidth',lwidth);
plot(urx,ury,'k','LineWidth',lwidth);

daspect(new_novelax,[1 1.2 1])
daspect(new_partnerax,[1 1.2 1])
daspect(newax,[1 1.2 1])



