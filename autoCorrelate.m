function [G_2,g_2,bins,bins_seconds,num_bins] = ...
    autoCorrelate(min_exp,max_exp,points_per_base,abs_photon_times_clock,T,...
    num_photons,tau,display)
% Function to to implement autocorrelation of photon arrival time series based on:
% 1) Laurence et al. (2006)
% 2) https://github.com/OpenSMFS/pycorrelate/blob/master/pycorrelate/pycorrelate.py
% 3) https://uk.mathworks.com/matlabcentral/fileexchange/64605-photon-arrival-time-correlation

% lines 113 and 118 - provide exact same results as pcorrelate - woop!!
% leave as < not =<

% 30.11.2018 - added offset_lag to allow for dead time of SPAD - need to
% clarify this?

% 03.12.2018 - added functionality for adding own bins for tau as input - 
% think left sided bins work best too so changed from centre bins to left
% sided bins - note if any spacing in tau is less than T then number of bins
% will be reduced

% Todo - optimise for speed

% Inputs

    % 1) min_exp - exponent of minimum time lag (base 10)
    % 2) max_exp - exponent of maximum time lag (base 10)
    % 3) points_per_base - number of points per base, i.e. in a decade as 
    %    using base 10.
    % 4) abs_photon_times_clock - series of absolute photon arrival times
    %    to be autocorrelated (in clock units)
    % 5) T - time unit in seconds
    % 6) num_photons - number of photons in arrival time series
    % 7) tau - optional input specifying sampling points for tau (must be
    %    column vector) must have max frequency of clock period of sampler
    %    (i.e 60 MHz to maintain linear spacing). 

% Outputs
    % 1) G_2 - scattered un-normalised intensity temporal autocorrelation 
    %    function at the detector intensity
    % 2) g_2 - scattered normalised intensity temporal autocorrelation 
    %    function at the detector intensity  
    % 3) bins - left edge of each time lag bin in clock units
    % 4) bins_seconds - left edge of each time lag bin in seconds
    % 5) num_bins - number of time lag bins in output (may vary from input
    %    if smallest bin spacing is less than T).   
    
%% 1) Initialise bins edges
if isempty(tau)
    % use log spaced (base 10) bin edges
    num_edges = points_per_base * (max_exp - min_exp) + 1;
    edges = logspace(min_exp,max_exp,num_edges);
    % convert edges to integer clock units to avoid problems with floating points
    edges = (unique(round(edges/T)));
else
    % else use pre-defined bin edges (max frequency is 60 MHz here due to
    % clock period of sampler)
    % convert tau to clock units and row vector
    bins = reshape(tau./T,1,[]);
    num_bins = length(bins); % number of bins
    num_edges = num_bins + 1; % number of edges
    edges = zeros(1,num_edges); % vector of edges
    diff_vec = diff(bins); % vector of differences between each tau value
    edges(1:end-1) = bins;
    edges(end) = bins(end) + diff_vec(end);
    % convert edges to integer clock units to avoid problems with floating points
    edges = (unique(round(edges))); % very necessary to do this!!
end

% adapt number of bins if unique function has reduced length of edges
% vector due to bin spacing being less than one clock unit
num_bins = length(edges)-1;
bins = edges(1:end-1);
% convert bins into seconds
bins_seconds = bins*T;

%% 2) Count the number of photons separated from each individual
% photon by the distance specified in edges.
% The time-saving step is to keep track of the earliest and
% latest photon in each bin, that way when going from one photon
% to the next, a minimum amount of comparison operations is
% performed.

low_ind = ones(1,num_bins); 
max_ind = ones(1,num_bins); 
% low_ind(1) = 2; % must start at 2 ??
% max_ind(1) = 2; % must start at 2 ??
ACF = zeros(1,num_bins); % initialise autocorrelation function
offset_lag = 0; 
% offset_lag = 45e-9; 
% set to equal dead time of SPAD (min value is 42 ns and
% typical value is 45 ns according to data sheet)??
offset_lag = offset_lag/T;  

% open waitbar
h = waitbar(0,'Autocorrelating Photon Arrival Time Series ...');
divider_waitbar=10^(floor(log10(num_photons))-1);

if display
    fprintf('\nAutocorrelating Photon Arrival Time Series ... \n')
    tic
end

% loop through all photons
for i = 1:num_photons
    
    % update waitbar dialog box
    if (round(i/divider_waitbar)==i/divider_waitbar)
        waitbar(i/num_photons,h)
    end
    
    % shift the log bins for each photon
    bin_edges = abs_photon_times_clock(i) + edges - offset_lag;
    % offset_lag here accounts for dead time of SPAD??
    % loop through all bins and count photons into bins
    for k = 1:num_bins
        while low_ind(k) < num_photons && ...
                abs_photon_times_clock(low_ind(k)) < bin_edges(k)
            low_ind(k) = low_ind(k)+1;
        end
        
        while max_ind(k) < num_photons && ...
                abs_photon_times_clock(max_ind(k)) < bin_edges(k+1)
            max_ind(k) = max_ind(k)+1;
        end
        
        % low index for next loop is current max index - this is key!
        low_ind(k+1) = max_ind(k);
        
        % update ACF
        ACF(k) = ACF(k) + (max_ind(k)-low_ind(k));
    end
end
% close waitbar
close(h)

% find bin widths for normalisation
bin_widths = diff(edges);

% divide counts in ACF by bin widths to normalise for bin widths
G_2 = ACF./bin_widths;

if display
    toc
    fprintf('... Autocorrelation and bin width normalisation complete. \n')

%% Normalise data (work in clock units here)
   
    fprintf('\nNormalising autocorrelation data ... \n')
    tic
end

abs_duration = max(abs_photon_times_clock) - min(abs_photon_times_clock);
t_corr = abs_duration - bins;
g_2 = G_2;
for i = 1:num_bins
    % first multiply ith element of t_corr
    g_2(i) = G_2(i) * t_corr(i);
    % divide by number of occurences of photon arrival times less than or 
    % equal to ith element of t_corr
    g_2(i) = g_2(i) / sum(abs_photon_times_clock <= t_corr(i));
    % divide by number of occurences of photon arrival times greater than
    % or equal to ith element of bins
    g_2(i) = g_2(i) / sum(abs_photon_times_clock >= bins(i));
end

if display
    toc
    fprintf('... Normalisation of autocorrelation data complete. \n')
end

end

