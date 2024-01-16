function mpout=rotprojvar(beta,mpole,nterms,m1,m2)
%ROTPROJVAR Rotate the complex spherical harmonics expansion about the y-axis.
%
%  MPOUT = rotprojvar(BETA,MPOLE,NTERMS) rotates the complex spherical 
%  harmonics expansion of degree NTERMS about the y-axis by degree BETA. 
%
%  MPOUT = rotprojvar(BETA,MPOLE,NTERMS,M1,M2) rotates the complex spherical 
%  harmonics expansion of degree NTERMS about the y-axis by degree BETA. 
%  Only modes up to degree M1 in the input MPOLE expansion and modes up 
%  to degree M2 in the output expansion MPOUT will be used. 
%
%  Both MPOUT and MPOLE are (NTERMS+1)-by-(2*NTERMS+1) complex matrices.
%
%
%  Fast and stable algorithm for applying rotation operator about
%  the y-axis determined by angle beta.
%
%  The method is based on computing the induced potential and
%  its theta-derivative on the rotated equator
%  for each order (first index). The coefficients of  the rotated
%  expansion can then be obtained by FFT and projection.
%
%  There is some loss in speed over using recurrence relations 
%  but it is stable to all orders whereas the recurrence schemes 
%  are not.
%
%  Our definition of complex spherical harmonics is
%
%  Ynm(theta,phi)= sqrt( 2n+1) sqrt((n-m)!/(n+m)!) 
%                  Pnm(cos theta) e^(im phi), 
%  Yn,-m(theta,phi) = sqrt( 2n+1) sqrt((n-m)!/(n+m)!) 
%                  Pnm(cos theta) e^(-im phi),   for m >= 0.
%       
%  Note that we do not include the Condon-Shortley phase (-1)^m, if m<0.
%


if (nargin < 4 )
m1=nterms;
end

if (nargin < 5 )
m2=nterms;
end

mpout = zeros(nterms+1,2*nterms+1)+1i*zeros(nterms+1,2*nterms+1);

lmp = nterms;
lmpn = nterms;

mex_id_ = 'rotviaprojvarf90(i double[x], i int[x], i int[x], i int[x], io dcomplex[], i int[x], io dcomplex[], i int[x])';
[mpole, mpout] = fmpslib(mex_id_, beta, nterms, m1, m2, mpole, lmp, mpout, lmpn, 1, 1, 1, 1, 1, 1);


