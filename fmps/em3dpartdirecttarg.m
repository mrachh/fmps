function [U]=em3dpartdirecttarg(zk,nsource,source,ifcjvec,cjvec,ifcmvec,cmvec,ifevec,ifhvec,ntarget,target,ifevectarg,ifhvectarg)
%EM3DPARTDIRECTTARG Maxwell dipole interactions in R^3, direct evaluation.
%
% Maxwell interactions in R^3: evaluate all pairwise dipole
% interactions (ignoring self-interaction) and interactions with targets.
%


if( nargin == 7 ) 
  ifevec = 1;
  ifhvec = 1;
  ntarget = 0;
  target = zeros(3,1);
  ifevectarg = 0;
  ifhvectarg = 0;
end

if( nargin == 9 ) 
  ntarget = 0;
  target = zeros(3,1);
  ifevectarg = 0;
  ifhvectarg = 0;
end

if( nargin == 11 ) 
  ifevectarg = 1;
  ifhvectarg = 1;
end

evec=zeros(3,1)+1i*zeros(3,1);
hvec=zeros(3,1)+1i*zeros(3,1);
evectarg=zeros(3,1)+1i*zeros(3,1);
hvectarg=zeros(3,1)+1i*zeros(3,1);

if( ifevec == 1 ), evec=zeros(3,nsource)+1i*zeros(3,nsource); end;
if( ifhvec == 1 ), hvec=zeros(3,nsource)+1i*zeros(3,nsource); end;
if( ifevectarg == 1 ), evectarg=zeros(3,ntarget)+1i*zeros(3,ntarget); end;
if( ifhvectarg == 1 ), hvectarg=zeros(3,ntarget)+1i*zeros(3,ntarget); end;

mex_id_ = 'em3dpartdirecttarg(i dcomplex[x], i int64_t[x], i double[], i int64_t[x], i dcomplex[], i int64_t[x], i dcomplex[], i int64_t[x], io dcomplex[], i int64_t[x], io dcomplex[], i int64_t[x], i double[], i int64_t[x], io dcomplex[], i int64_t[x], io dcomplex[])';
[evec, hvec, evectarg, hvectarg] = fmpslib(mex_id_, zk, nsource, source, ifcjvec, cjvec, ifcmvec, cmvec, ifevec, evec, ifhvec, hvec, ntarget, target, ifevectarg, evectarg, ifhvectarg, hvectarg, 1, 1, 1, 1, 1, 1, 1, 1, 1);

if( ifevec == 1 ), U.evec=evec; end;
if( ifhvec == 1 ), U.hvec=hvec; end;
if( ifevectarg == 1 ), U.evectarg=evectarg; end;
if( ifhvectarg == 1 ), U.hvectarg=hvectarg; end;



