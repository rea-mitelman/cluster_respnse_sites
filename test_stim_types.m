% test_stim_types
clear all;
% dat.mean=load('test_resp.mat');
% dat.med=load('test_resp_med.mat');
load('test_resp_med.mat');
mm={'med'};
locs={'thal','ctx'};
% t=dat.med.t;
d=3;
K=3;
cols='kmcrgby';
for l=1:2
    clear St
    %     dat_mat = dat.med.all_resp.(locs{l});
    dat_mat = all_resp.(locs{l});
    dat_mat(t>-2 & t<1.1,:)=0;
    [U,S,V] = svds(dat_mat,d);
    
    %         IDX=kmeans(V(:,1:2),2);
    [~,ix_sort]=sort(abs(V));
    %         V_sort=V(ix_sort);
    %         St.mu=([zeros(1,d);V_sort(end,:)]);
    %         St.Sigma(:,:,1)=cov(V_sort(1:end/2,:));
    %         St.Sigma(:,:,2)=cov(V_sort(end/2+1:end,:));
    %         St.PComponent=
    %         obj = gmdistribution.fit(V,K,'Start',St);
    opts_obj.MaxIter=200;
    obj = gmdistribution.fit(V,K,'Replicates',2000,'Options',opts_obj);
    
    IDX = cluster(obj,V);
    clf
    subplot(2,2,1)
    hold on
    [~,sort_clust_ixs]=sort(sum(obj.mu.^2,2).^.5);
    sort_clust_ixs=sort_clust_ixs';
    for j=1:K
        kk=sort_clust_ixs(j);
        if d>=3
            plot3(V(IDX==kk,1),V(IDX==kk,2),V(IDX==kk,3),['.' cols(j)]);
        elseif d==2
            plot(V(IDX==kk,1),V(IDX==kk,2),['.' cols(j)]);
        else
            plot(ones(sum(IDX==kk),1),V(IDX==kk),['.' cols(j)]);
        end
    end
    title('Projection on PCs, sorted by EM')
    subplot(2,2,3)
    plot(t,U)
    xlabel('Time (msec)')
    title('PCs')
    legend(num2cell(num2str([1:d]')))
    %         suptitle(sprintf('%s activity in %s, %g clusters based on %g PCs',med,locs{l},K,d));
    for j=1:K
        kk=sort_clust_ixs(j);
        subplot(K,2,2*j)
        %             this_mat=dat_mat(:,IDX==j);
        %             this_mat=repmat(2*[0:size(this_mat,2)-1],size(this_mat,1),1)+this_mat;
        %             plot(t,this_mat)
        %             ylim([-inf inf])
        plot(t,dat_mat(:,IDX==kk),cols(j))
        
        if j==1
            tit='Clustered as non-responsive';
        else
            tit=sprintf('Clustered as type %g response',j-1);
        end
        title(sprintf('%s, %g sites',tit,sum(IDX==kk)))
        ylabel('# MADs from Median')
        if j==K
            xlabel('Time (msec)')
        end
    end
    
    keyboard
    %         [U,S,V]=svds(dat_mat,25);
    %         figure
    %         for pc=1:25
    %             subplot(5,5,pc)
    %             hist(sum(abs(V(:,1:pc)),2),100);
    %             title(num2str(pc))
    %         end
end


%% now, run over all the sites, and save in each of the correct data file the correct response index (responsive / not responsive)



