% function [sens,mssim] = ssim_sens(x,y,L)
%
% Function for computing the SSIM index and SSIM gradient
%
% INPUT:
% (1) x: image matrix 1
% (2) y: image matrix 2
% (3) L: optional; default = 255
%
% OUTPUT:
% (1) sens: SSIM gradient
% (2) mssim: SSIM value

% ----------------------------------------------------------------------
% Copyright(c) Alireza N. Avanaki (avanaki@yahoo.com)
%
% Please refer to the following paper:
% Avanaki, A. N. (2009). Exact global histogram specification
% optimized for structural similarity. Optical Review, 16,
% 613-621.
%
% This piece of code comes with absolutely no warranty.
% Non-commercial use (at your own risk) is permitted.
% ----------------------------------------------------------------------

function [sens,mssim]=ssim_sens(x,y,L)

[M N] = size(x);
% window=fspecial('gaussian',21,3);
window=fspecial('gaussian',11,1.5);
K(1) = 0.01; % default settings
K(2) = 0.03;
% K(1) = 0.004;
% K(2) = 0.004;
if nargin==2, L = 255; end
C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
window = window/sum(sum(window));
% mx=filter2(window,x,'valid');
% my=filter2(window,y,'valid');
mx=filter2(window,x);
my=filter2(window,y);
m2x=mx.*mx;
m2y=my.*my;
mxmy=mx.*my;
% mx2=filter2(window,x.*x,'valid');
% my2=filter2(window,y.*y,'valid');
mx2=filter2(window,x.*x);
my2=filter2(window,y.*y);
sx=mx2-m2x;
sy=my2-m2y;
% sxy=filter2(window,x.*y,'valid')-mxmy;
sxy=filter2(window,x.*y)-mxmy;

% y=y(6:size(y,1)-5,6:size(y,2)-5);
% x=x(6:size(x,1)-5,6:size(x,2)-5);

sxPsyPC2=sx+sy+C2;
m2xPm2yPC1=m2x+m2y+C1;
TwosxyPC2=2*sxy+C2;
TwomxmyPC1=2*mxmy+C1;

den=m2xPm2yPC1.*sxPsyPC2;
ssim=TwomxmyPC1.*TwosxyPC2./den;

m1=mx.*(TwosxyPC2-TwomxmyPC1)-my.*ssim.*(sxPsyPC2-m2xPm2yPC1);
m1=filter2(window,2*m1./den);
sens=m1;

m1=2*TwomxmyPC1./den;
m1=filter2(window,m1).*x;
sens=sens+m1;

m1=-ssim./sxPsyPC2;
m1=2*filter2(window,m1).*y;
sens=sens+m1;
sens=sens/prod(size(sens));
mssim=mean2(ssim); % ssim: contains SSIM map