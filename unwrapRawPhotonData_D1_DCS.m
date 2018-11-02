% Tests function unwrap8BitRawDataFile.m and also plots and saves baseline
% figures for each of the four photon arrival time series collected on
% D1_DCS.

% NB - Sam confirmed that longest delay between any two consecutive photons
% for Sample 1 is indeed 6618 clock ticks. At 110.30 microseconds, this 
% initially seemed too long, but is the tail end of an exponential distribution. 

clearvars
clc
close all
opengl('save', 'software')
save_figs = true;
% save_figs = false;

%% To set line widths and font size for plots
fs=20;
LW=1.5;
% set number of bins for histograms
num_bins = 200;

%% Day 1 DCS data
path_name = 'C:\Users\edggj\Dropbox\desktop\PhD\Data Analysis\Shared Data Folder\D1_DCS\';
% Data marked "_venous" was collected over a vein, assuming if not
% mentioned then no attempt was made to collect over a vein. 

%% Sample 1
file_name = 'ej_10s_10mm_5mW_history.dat';
% extract raw data
[f,T,duration,n,num_photons,abs_photon_times_clock,abs_photon_times_seconds, ...
    rel_photon_times_clock, rel_photon_times_seconds] ...
    = unwrap8BitRawDataFile(path_name,file_name);
% save raw data
save Unwrapped_Data\D1_DCS_unwrapped_data_sample_1 f T duration n num_photons ...
    abs_photon_times_clock abs_photon_times_seconds rel_photon_times_clock ...
    rel_photon_times_seconds
% plot two figures
% 1)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(abs_photon_times_seconds,num_bins);
grid minor
xlabel('Arrival Time (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 1 - Absolute Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: EJ - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (non-venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\absolute_arrival_time_seconds_ej_10s_10mm_5mW_history.fig')
    saveas(gcf,'Images\absolute_arrival_time_seconds_ej_10s_10mm_5mW_history.png')
end
% 2)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(rel_photon_times_seconds,num_bins);
grid minor
xlabel('Delay (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 1 - Relative Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: EJ - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (non-venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\relative_arrival_time_seconds_ej_10s_10mm_5mW_history.fig')
    saveas(gcf,'Images\relative_arrival_time_seconds_ej_10s_10mm_5mW_history.png')
end

%% Sample 2
file_name = 'ej_10s_10mm_5mW_history_venous.dat';
% extract raw data
[f,T,duration,n,num_photons,abs_photon_times_clock,abs_photon_times_seconds, ...
    rel_photon_times_clock, rel_photon_times_seconds] ...
    = unwrap8BitRawDataFile(path_name,file_name);
% save raw data
save Unwrapped_Data\D1_DCS_unwrapped_data_sample_2 f T duration n num_photons ...
    abs_photon_times_clock abs_photon_times_seconds rel_photon_times_clock ...
    rel_photon_times_seconds
% plot two figures
% 1)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(abs_photon_times_seconds,num_bins);
grid minor
xlabel('Arrival Time (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 2 - Absolute Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: EJ - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\absolute_arrival_time_seconds_ej_10s_10mm_5mW_history_venous.fig')
    saveas(gcf,'Images\absolute_arrival_time_seconds_ej_10s_10mm_5mW_history_venous.png')
end
% 2)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(rel_photon_times_seconds,num_bins);
grid minor
xlabel('Delay (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 2 - Relative Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: EJ - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\relative_arrival_time_seconds_ej_10s_10mm_5mW_history_venous.fig')
    saveas(gcf,'Images\relative_arrival_time_seconds_ej_10s_10mm_5mW_history_venous.png')
end
%% Sample 3
file_name = 'sp_10s_10mm_5mW_history_venous.dat';
% extract raw data
[f,T,duration,n,num_photons,abs_photon_times_clock,abs_photon_times_seconds, ...
    rel_photon_times_clock, rel_photon_times_seconds] ...
    = unwrap8BitRawDataFile(path_name,file_name);
% save raw data
save Unwrapped_Data\D1_DCS_unwrapped_data_sample_3 f T n duration num_photons ...
    abs_photon_times_clock abs_photon_times_seconds rel_photon_times_clock ...
    rel_photon_times_seconds
% plot two figures
% 1)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(abs_photon_times_seconds,num_bins);
grid minor
xlabel('Arrival Time (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 3 - Absolute Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: SP - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\absolute_arrival_time_seconds_sp_10s_10mm_5mW_history_venous.fig')
    saveas(gcf,'Images\absolute_arrival_time_seconds_sp_10s_10mm_5mW_history_venous.png')
end
% 2)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(rel_photon_times_seconds,num_bins);
grid minor
xlabel('Delay (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 3 - Relative Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: SP - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\relative_arrival_time_seconds_sp_10s_10mm_5mW_history_venous.fig')
    saveas(gcf,'Images\relative_arrival_time_seconds_sp_10s_10mm_5mW_history_venous.png')
end

%% Sample 4
file_name = 'sp_10s_10mm_5mW_historyA.dat';
[f,T,duration,n,num_photons,abs_photon_times_clock,abs_photon_times_seconds, ...
    rel_photon_times_clock, rel_photon_times_seconds] ...
    = unwrap8BitRawDataFile(path_name,file_name);
save Unwrapped_Data\D1_DCS_unwrapped_data_sample_4 f T n duration num_photons ...
    abs_photon_times_clock abs_photon_times_seconds rel_photon_times_clock ...
    rel_photon_times_seconds
% plot two figures
% 1)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(abs_photon_times_seconds,num_bins);
grid minor
xlabel('Arrival Time (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 4 - Absolute Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: SP - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (non-venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\absolute_arrival_time_seconds_sp_10s_10mm_5mW_historyA.fig')
    saveas(gcf,'Images\absolute_arrival_time_seconds_sp_10s_10mm_5mW_historyA.png')
end
% 2)
figure('units','normalized','outerposition',[0 0 1 1])
histogram(rel_photon_times_seconds,num_bins);
grid minor
xlabel('Delay (seconds)','FontSize',fs-1,'FontWeight','bold')
ylabel('count','FontSize',fs-1,'FontWeight','bold')
title(['Sample 4 - Relative Photon Arrival Time Histogram - n:',num2str(num_photons),...
    ' - Subject: SP - Duration:',num2str(duration),...
    ' - Source Power: 5mW - SDS: 10mm - Location: Arm (non-venous)'],... 
    'FontSize',fs+1,'FontWeight','bold')
suptitle('D1 DCS - Date: 22/10/2018')
if save_figs
    saveas(gcf,'Images\relative_arrival_time_seconds_sp_10s_10mm_5mW_historyA.fig')
    saveas(gcf,'Images\relative_arrival_time_seconds_sp_10s_10mm_5mW_historyA.png')
end

   