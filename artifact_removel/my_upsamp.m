function [upsamp_sig, upsamp_t]=my_upsamp(varargin)
% trying various methods of upsampling:
% 
if nargin==3
    x=varargin{1};
    t=varargin{2};
    r=varargin{3};
elseif nargin==2
    x=varargin{1};
    r=varargin{2};
else
    error('Wrong number of input arguments')
end
        
upsamp_sig=interp(x,r);

if nargin==3
    dt=mean(diff(t));
    %     upsamp_t=t(1):dt/r:(t(end)+dt*(r-1)/r);
    upsamp_t=linspace(t(1),(t(end)+dt*(r-1)/r),length(t)*r);
end