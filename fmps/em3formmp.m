function [ampole,bmpole]=em3formmp(rk,source,cjvec,cmvec,center,nterms)
%em3formmp: Form the outgoing EM multipole expansion.
%
%  [ampole,bmpole]=em3formmp(rk,source,cjvec,cmvec,center,nterms);
%
%  All EM multipoles are (NTERMS+1)-by-(2*NTERMS+1) complex matrices.
%
%  Input parameters:
%
%    rk - the frequency parameter
%    center - center of the multipole expansion
%    source - real(3,nsource): the source locations in R^3
%    cjvec - complex(3,nsource): the strengths of the electric dipoles 
%    cmvec - complex(3,nsource): the strengths of the magnetic dipoles  
%    nterms - the number of terms in multipole expansion
%                 
%  Output parameters:
%
%    ampole,bmpole - complex(ncoefs): outgoing EM multipoles
%
%

npts=size(source,2);
ncoefs = (nterms+1)*(2*nterms+1);
ampole = zeros(ncoefs,1) + 1i*zeros(ncoefs,1);
bmpole = zeros(ncoefs,1) + 1i*zeros(ncoefs,1);

mex_id_ = 'em3formmp(i dcomplex[x], i double[], i dcomplex[], i dcomplex[], i int64_t[x], i double[], io dcomplex[], io dcomplex[], i int64_t[x])';
[ampole, bmpole] = fmpslib(mex_id_, rk, source, cjvec, cmvec, npts, center, ampole, bmpole, nterms, 1, 1, 1);


