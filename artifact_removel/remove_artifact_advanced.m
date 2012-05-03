function clean_signal = remove_artifact_advanced...
    (signal, signal_Fs, stim_times, stim_times_Fs,...
	us_factor, art_end, max_dead_time_dur, do_lin_decay)
% Advanced method for stimulus artifact removal
% Artifact removal algorithm:
% 1. Detection of saturated times: the post stimuli time samples, in which
%    the signal is saturated are detected. The saturation times are
%    searched at the segment t=sat_dur(1):sat_dur(2) =0:1 ms.
%    (get_sat_times).     
% 2. The signal is up-sampled (my_upsamp), us_factor times.
% 3. The jitter in the stimulus times is corrected, using segments of
%    t=jit_dur(1):jit_dur(2)=0:1 ms. (Boris’ paper, get_temp_jit)
% 4. The artifacts are removed in the following manner: the dead time
%    (starting the minimal time of saturation and ending at the maximal time
%    of saturation with respect to the stimulus time) is set to zero. For the
%    rest of the segment, lasting art_time, the average response is
%    subtracted. If do_lin_decay==true, a similar length segment, after the
%    first one is subtracted in a linearly decay manner.
%    (remove_stim_artifact)  
% 5. The signal is downsampled to the original sampling rate (my_decimate)
% 
% 
if ~exist('us_factor','var') || isempty(us_factor)
	us_factor=8;
	disp('Using defauly us_factor=8')
end

if ~exist('art_end','var') || isempty(art_end)
	art_end=10;
	disp('Using defauly art_end=10')
end

if ~exist('max_dead_time_dur','var') || isempty(max_dead_time_dur)
	max_dead_time_dur=0.75;
	disp('Using defauly max_dead_time_dur=0.75')
end

if ~exist('do_lin_decay','var') || isempty(do_lin_decay)
	do_lin_decay=false;
	disp('Using defauly do_lin_decay=false')
end

	
art_begin=0;
resp_dur=[art_begin art_end];
sat_dur=[0 1]; %The period duration in which satturation is looked for
jit_dur=[0 1]; %The period duration in which jitter is looked for
% (1) "sat_times" marks the times in which the signal is saturated. This is
% used to define the dead time. It's done easier before the upsampling.
sat_times = get_sat_times(signal, stim_times, signal_Fs, sat_dur);

% (2) upsampling the signal
if stim_times_Fs~=signal_Fs
    warning('Sampling rate of the signal and stimuli times are different. The code was not debugged for these cases')
end
signal = my_upsamp(signal,us_factor);
Fs=signal_Fs*us_factor; %Fs is the sampling rate of the upsampled signal
stim_times=get_upsamp_times(stim_times,stim_times_Fs,us_factor); %stim_times, though digital, require correction when going to higher sampling rate

% (3) correcting for temporal jitter of the stimuli
jit_ixs=get_temp_jit(signal, stim_times, Fs, jit_dur, us_factor); 
stim_times=stim_times+jit_ixs/Fs/1000; % Using the jittering indices correction to correct the stimuli times
% sat_times=sat_times+[min(jit_ixs) max(jit_ixs)+1]*2/Fs; %correct for the jitter, plus margins
sat_times=sat_times + minmax(jit_ixs')/signal_Fs;% + [-1 +1]/Fs; %correct for the jitter, plus margins

sat_times(1) = max(sat_times(1),0); %prevent zeroing before stimulus;
sat_times(2) = min(sat_times(2),max_dead_time_dur); %zeroing no more than max_dead_time_dur
fprintf('Saturation time is between %1.2f and %1.2f msec. from stimulus onset\n',sat_times);
% This proved to be both of little effect in the agarose data, and
% potentially noise inducing in the physiological data...
% [resp_mat_us_dejit_denoise, mult_factor]=
% denoise_multip(resp_mat_us_dejit(t2<sat_times(1) | t2>sat_times(2),:)); %
clean_us_signal=remove_stim_artifact(...
	signal, Fs, stim_times, resp_dur(2), sat_times, false, do_lin_decay);
clear signal

clean_signal=my_decimate(clean_us_signal,us_factor);