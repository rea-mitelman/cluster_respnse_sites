function [binned_trials, binned_fs, binned_t_vec]=bin_trials(org_trials, bin_factor, fs, t_vec)
% takes a metrix of n_samples X n_trials and returns the binned matrix,
% size (n_samples/bin_factor) X n_trials. Each bin in the updated matrix is 
% the sum of bin_factor continuous bins in the original one . The sampling
% rate fs is an input- if given, the fuction can return the new sampling
% frequency (binned_fs)

[n_samples, n_trials]=size(org_trials);
corr_n_samp=n_samples-mod(n_samples, bin_factor);
org_trials_chop = org_trials(1:corr_n_samp,:); %chopping the number of samples to fit bin_factor
binned_trials=squeeze(sum(reshape(org_trials_chop',n_trials,bin_factor,[]),2))';

% for ii=1:n_samples_binned
%     ixs=[1:bin_factor]+(ii-1)*bin_factor;
%     binned_trials(ii,:)=sum(org_trials(ixs,:));
% end

if unempty_exist('fs')
    binned_fs=fs/bin_factor;
else
    binned_fs=[];
end

if unempty_exist('t_vec')
    binned_t_vec=mean(reshape(t_vec(1:corr_n_samp),bin_factor,[]));
end
