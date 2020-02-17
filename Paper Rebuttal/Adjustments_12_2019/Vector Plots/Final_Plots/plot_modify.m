%Ryan Cameron
%Modify plots

clearvars;close all;clc;

name = 'Cell_445_1_5_Departure';
xend = [93 678];
yend = [155 330];
lwall = 288;
rwall = 483;
aspectratio = 1.2;
lwidth = 1.5;

fig = openfig(strcat(name,'.fig'));
range = (yend(2)-yend(1));
range = floor(range/3);
xlim(xend)
ylim(yend)
xlabel('')
ylabel('')

daspect([1 aspectratio 1])
grid off 
box on

%Plot walls
llx = [lwall lwall];
lly = [yend(1),yend(1)+range];
ulx = [lwall lwall];
uly = [yend(2)-range,yend(2)];
lrx = [rwall rwall];
lry = [yend(1),yend(1)+range];
urx = [rwall rwall];
ury = [yend(2)-range,yend(2)];

plot(llx,lly,'k','LineWidth',lwidth);
plot(ulx,uly,'k','LineWidth',lwidth);
plot(lrx,lry,'k','LineWidth',lwidth);
plot(urx,ury,'k','LineWidth',lwidth);

fig.Visible = 'on';
cd Modified_Plots 
saveas(fig,strcat(name, '.fig'))
saveas(fig,strcat(name, '.png'))
cd ..