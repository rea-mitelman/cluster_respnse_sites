function [binned_trials, new_fs]=bin_trials2(org_trials, bin_factor, fs)
% takes a metrix of n_samples X n_trials and returns the binned matrix,
% size (n_samples/bin_factor) X n_trials. Each bin in the updated matrix is 
% the sum of bin_factor continuous bins in the original one . The sampling
% rate fs is an input- if given, the fuction can return the new sampling
% frequency (new_fs)

[n_samples, n_trials]=size(org_trials);
org_trials_chop = org_trials(1:n_samples-mod(n_samples, bin_factor),:); %chopping the number of samples to fit bin_factor
n_samples_binned=n_samples/bin_factor;
binned_trials=zeros(n_samples_binned,n_trials);
for ii=1:n_samples_binned
    ixs=[1:bin_factor]+(ii-1)*bin_factor;
    binned_trials(ii,:)=sum(org_trials(ixs,:));
end

% binned_trials=squeeze(sum(reshape(org_trials_chop',n_trials,bin_factor,[]),2))';

if exist('fs','var')
    new_fs=fs/bin_factor;
end