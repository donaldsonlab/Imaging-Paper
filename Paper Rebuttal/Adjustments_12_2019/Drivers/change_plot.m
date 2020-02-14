% Combine the two plots for overlapping departure cells

clear all; close all; clc;

cd ..
PWD = pwd;
cd('Vector Plots\Novel\Final')
novel = openfig('Cell_557_1_45_Departure.fig');
cd(PWD)
cd('Vector Plots\Partner\Final')
partner = openfig('Cell_557_1_45_Departure.fig');

new_fig = figure('Visible','off');
new_ax = axes;
partner_plots = partner.Children.Children;
novel_plots = novel.Children.Children;

new_ax.Parent = new_fig;
hold(new_ax,'on');
partner_plots(3).Parent = new_ax;
partner_plots(4).Parent = new_ax;

novel_plots(3).Parent = new_ax;
novel_plots(4).Parent = new_ax;
grid on
new_fig.Visible = 'on';