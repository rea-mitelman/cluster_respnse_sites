function [jit_ixs, corr_mat]=get_temp_jit(signal, stim_times, Fs, resp_dur, us_factor)

% The function corrects for temporal jitters in response vectors, in an
% itterative manner, by minimizing an (integer) jitter, different per
% response.
% org_mat is a matrix of the responses, sized (n_responses X n_samples)
% i.e. each row is a response.
% max_jit_per_itt is the maximal temporal jitter examined (in samples), per
% itteration, in both directions (i.e. positive and negative).
% jit_ixs is a column vector sized n_responses, which defines the correction
% required per response.
% corr_mat is the corrected matrix, sized
% (n_responses X n_samples-2*max_jit_per_itt
%
%
%
% %test
% % org_mat = rand(200,5);
% close all
% max_jit_per_itt=2;
% max_itter=100;
% N=200;
%
% t=0:100;
% jit=round((rand(N,1)-.5)*2*5);
% jit=repmat(jit,1,101);
% tt=repmat(t,N,1);
% tt=tt+jit;
% org_mat=sin(pi*tt/10).*exp(-tt/10);%+randn(size(tt))*0.1;
%
% % org_mat=repmat(sin(pi*t/10).*exp(-t/25),20,1);
% % org_mat=org_mat+randn(size(org_mat))*.5;
% %%
% 
% org_mat=get_resp_mat(signal, stim_times, Fs, resp_dur)';

max_jit_per_itt=1;
max_jit=ceil(us_factor)/2;
do_corr=true;
n_itter=0;
jit_vec=-max_jit_per_itt:max_jit_per_itt;

max_itter=200;
do_plot=false;

% shift_vec=max_jit_per_itt+[1:n_samp];
% for ii=1:2*max_jit_per_itt+1
%     jit=jit_vec(ii);
%     ixs(ii,:)=jit+shift_vec ;
% end
n_samp = (resp_dur(2)-resp_dur(1))*Fs+1;
n_resp = length(stim_times);
jit_ixs=zeros(n_resp,1);

while do_corr && n_itter<max_itter
    stim_times_corrected=stim_times+jit_ixs/Fs/1000;
    corr_mat = get_resp_mat(signal, stim_times_corrected, Fs, resp_dur)';

    if do_plot
        figure(1)
        clf
        subplot(2,1,1),hold on
        plot(corr_mat'), plot(mean(corr_mat),'k','LineWidth',2)
        title(sprintf('#%1.0f',n_itter))
        subplot(2,1,2), plot(std(corr_mat))
        drawnow
    end

    n_itter=n_itter+1;
    % 	pad_mat=[NaN(n_resp,max_jit_per_itt) , corr_mat , NaN(n_resp,max_jit_per_itt)];
    mean_resp_mat=repmat(mean(corr_mat),n_resp,1);
%     mean_resp_mat=repmat(median(corr_mat),n_resp,1);
    diff_vec=zeros(n_resp,2*max_jit_per_itt+1);
    for ii=1:2*max_jit_per_itt+1 %trying all possible jitters
        
        %         jittered_mat=corr_mat(:,ixs(ii,:));
        dt=jit_vec(ii)/Fs/1000;
        jittered_mat = get_resp_mat(signal, stim_times_corrected+dt, Fs, resp_dur)';
        diff_vec(:,ii)=mean((jittered_mat-mean_resp_mat).^2,2) ;
        %         diff_vec(:,ii)=mean(abs(jittered_mat-mean_resp_mat),2) ;
    end
    
    last_jit_ixs=jit_ixs;
    [~,min_ixs]=min(diff_vec,[],2);
    jit_ixs=jit_ixs+min_ixs-max_jit_per_itt-1;
    jit_ixs=min(max(jit_ixs,-max_jit),max_jit);

%     for jj=1:n_resp %taking the best jitter per response
%         corr_mat(jj,:)=pad_mat(jj,ixs(min_ixs(jj),:));
%     end
    if do_plot
        std_vec(n_itter)=mean(std(corr_mat));
    end
    
    if isequal(last_jit_ixs, jit_ixs)
        do_corr=false;
    end
    
end
fprintf('Temporal jitter is between %1.0f and %1.0f samples. Converged after %1.0f itterations.\n',...
    min(jit_ixs), max(jit_ixs), n_itter);

if do_plot
    figure(1)
    clf
    plot(jit_ixs)
    keyboard
end