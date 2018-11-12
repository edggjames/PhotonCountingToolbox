function [f,T,duration,n,num_photons,abs_photon_times_clock,abs_photon_times_seconds, ...
    rel_photon_times_clock, rel_photon_times_seconds] ...
    = unwrap16BitRawDataFile(path_name,file_name)
% Function to extract photon arrival time series from 16 bit Flex02 raw data 

% Inputs
% 1) path_name = path_name of data file
% 2) file_name = individual name of data file, these two inputs will be
%    concatenated

% Outputs
% 1) f = system clock in Hz
% 2) T = time unit in seconds
% 3) duration = length of data collection in seconds
% 4) n = length of measured data (includes all bytes which equal 65536)
% 5) num_photons = number of photons recorded during entire data collection
% 6) abs_photon_times_clock = vector of absolute photon arrival time series
%    in system clock ticks
% 7) abs_photon_times_seconds = as above but in units of seconds. 
% 8) rel_photon_times_clock = vector of relative photon arrival time series
%    in system clock ticks - first value is delay between first photon and
%    start of experiment, all subsequent values are delay between ith
%    photon and previous photon. 
% 9) rel_photon_times_seconds = as above but in units of seconds.

% Author: Edward James, PhD Student, UCL, November 2018.
% e.james.14@ucl.ac.uk

%% load data file in 8 bit format 
fileID = fopen(strcat(path_name,file_name),'r'); % open file for reading
A = fread(fileID,'uint8'); % read data from binary file, in 8 bit (1 byte)
% unsigned integer format
% fclose(fileID);

file_format = A(1); % the first byte identifies the format of the file in bits
% should be 16 bit here
if file_format ~= 16
    disp('Error - data file is not in 16 bit format')
    return
end
f = A(2)*1e6; % the second byte identifies the system clock in MHz
T = 1/f;  % calculate the time unit
clear A

%% load data file in 16 bit
fileID = fopen(strcat(path_name,file_name),'r'); % open file for reading
A = fread(fileID,'uint16'); % read data from binary file, in 16 bit (2 byte)
% unsigned integer format
fclose(fileID);

rel_photon_times_clock = A(2:end); % the rest of the file contains the times
% between two photon arrivals, except if value is 65536, in which case no
% photon has arrived and 65536 time units have elapsed. The time unit is 
% T = 1/(system clock) (here 16.66 ns).
clear A

% Duration of data collection
duration = sum(rel_photon_times_clock)*T;
% calculate length of measured data
n = length(rel_photon_times_clock);
% calculate number of photons detected
num_photons = n - sum(rel_photon_times_clock==65536);

%% loop through file and convert intervals between photon arrival times to
% absolute arrival times

% allocate memory for absolute photon times
abs_photon_times_clock = zeros(n,1);

% at start of experiment let t = 0 (t_0)
% first photon then arrives at t = rel_photon_times_clock(1)
abs_photon_times_clock(1) = rel_photon_times_clock(1);

% set delay and idx counter
delay = 0;
idx = 0;
for i = 2:n
    % add current relative photon arrival time to delay
    delay = delay + rel_photon_times_clock(i);
    if rel_photon_times_clock(i) ~= 65536
        % simply add delay to previous absolute photon arrival time
        abs_photon_times_clock(i) = abs_photon_times_clock(i-1-idx) + delay;
        % reset delay and idx counter
        delay = 0;
        idx = 0;
    else
        % increment idx counter and mark entry as NaN for later removal
        idx = idx + 1;
        abs_photon_times_clock(i) = NaN;
    end
end
% remove all NaN elements
abs_photon_times_clock(isnan(abs_photon_times_clock))= [];

%% data processing

% convert absolute photon arrival times from clock units to time in seconds
abs_photon_times_seconds = abs_photon_times_clock*T;

% calculate relative photon arrival times, first value is delay between
% start of experiment and first photon, all other values are delay between
% ith photon and previous photon
rel_photon_times_clock = zeros(length(abs_photon_times_clock)+1,1);
rel_photon_times_clock(2:end) = abs_photon_times_clock;
rel_photon_times_clock = diff(rel_photon_times_clock);
% also calculate relative photon arrival times in seconds
rel_photon_times_seconds = rel_photon_times_clock*T;
end
