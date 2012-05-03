function v_filt=gaussfilt(v_in,win_size,winSD,creat_tail)
if ~exist('creat_tail','var') || isempty(creat_tail)
    creat_tail=false;
end
v_in=v_in(:);

% enforcing odd win size:
if mod(win_size,2)==0
    win_size=win_size+1;
end

win=my_gausswin(win_size,winSD);

if creat_tail
    tail_leng=floor(win_size/2);
    v_in = ...
        [v_in(tail_leng:-1:1);
        v_in;
        v_in(end:-1:end-tail_leng+1)];
end

v_filt=filtfilt(win,1,v_in);

if creat_tail
    v_filt=v_filt(tail_leng+1:end-tail_leng);
end
