function [resp_mat,t]=get_resp_mat(signal, stim_times, Fs, resp_dur)

stim_ixs=round(stim_times*Fs*1000);
stim_ixs=stim_ixs(:);
n_stims=length(stim_ixs);
resp_dur_ixs=round(resp_dur*Fs);

resp_ixs=[resp_dur_ixs(1):resp_dur_ixs(2)]-1; %#ok<*NBRAK>
all_art_ixs=repmat(stim_ixs,1,length(resp_ixs))+repmat(resp_ixs,n_stims,1);

% org_n_samp=length(signal);

% signal(org_n_samp+resp_ixs+1)=NaN;
% 
% if all_art_ixs(end) > length(signal)
% 	error('last stimulus artifact outside boundaries, this needs to be solved')
% end

resp_mat=signal(all_art_ixs)';
t=resp_dur(1):1/Fs:resp_dur(2);