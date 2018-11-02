% Author: Edward James, PhD Student, UCL, October 2018.
% e.james.14@ucl.ac.uk

% Tests function unwrap8BitRawDataFile.m on two data files in 
% \Shared Data Folder\D2_DCS_AOT\DCS_intralipid and saves unwrapped data to 
% \Unwrapped_Data\

clearvars
clc
close all

%% D2_DCS_AOT\DCS_intralipid data
path_name = 'C:\Users\edggj\Dropbox\desktop\PhD\Data Analysis\Shared Data Folder\D2_DCS_AOT\DCS_intralipid\';

%% Sample 1
file_name = '20_pc_intralipid_19_water_1_5mw_10mmA.dat'; 
% extract raw data
[f,T,duration,n,num_photons,abs_photon_times_clock,abs_photon_times_seconds, ...
    rel_photon_times_clock, rel_photon_times_seconds] ...
    = unwrap8BitRawDataFile(path_name,file_name);
% save raw data
save Unwrapped_Data\D2_DCS_AOT_DCS_intralipid_sample_1 f T duration n num_photons ...
    abs_photon_times_clock abs_photon_times_seconds rel_photon_times_clock ...
    rel_photon_times_seconds

%% Sample 2
file_name = '20_pc_intralipid_19_water_1_5mw_20_5mmAA.dat'; 
% extract raw data
[f,T,duration,n,num_photons,abs_photon_times_clock,abs_photon_times_seconds, ...
    rel_photon_times_clock, rel_photon_times_seconds] ...
    = unwrap8BitRawDataFile(path_name,file_name);
% save raw data
save Unwrapped_Data\D2_DCS_AOT_DCS_intralipid_sample_2 f T duration n num_photons ...
    abs_photon_times_clock abs_photon_times_seconds rel_photon_times_clock ...
    rel_photon_times_seconds

