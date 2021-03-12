% avg = sfPlot(im,qplot)
%
% Computes and plots the rotational average of the Fourier energy spectrum
%
% INPUT:
% im: image matrix
% qplot: plot option; set to 0 to switch off plot
% 
% OUTPUT:
% avg: rotational average of the Fourier energy spectrum

% ------------------------------------------------------------------------
% SHINE toolbox, Nov 2010
% (c) Verena Willenbockel, Javid Sadr, Daniel Fiset, Greg O. Horne,
% Frederic Gosselin, James W. Tanaka
% ------------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is hereby
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%
% Please refer to the following paper:
% Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F.,
% Tanaka, J. W. (2010). Controlling low-level image properties: The
% SHINE toolbox. Behavior Research Methods, 42, 671-684.
%
% Kindly report any suggestions or corrections to verena.vw@gmail.com
% ------------------------------------------------------------------------
%
% Revision 1, 26/11/2010 (thanks to Diederick C. Niehorster)
% - Improved speed by using accumarray 
% - Output argument added; plot is now optional

function avg = sfPlot(im,qplot)

if nargin < 2
    qplot = true;
end
if ndims(im) == 3
    im = rgb2gray(im);
end
[xs ys] = size(im);
fftim = abs(fftshift(fft2(double(im)))).^2;
f2 = -xs/2:xs/2-1;
f1 = -ys/2:ys/2-1;
[XX YY] = meshgrid(f1,f2);
[t r] = cart2pol(XX,YY);
if mod(xs,2)==1 || mod(ys,2)==1
    r = round(r)-1;
else
    r = round(r);
end
avg = accumarray(r(:)+1,fftim(:))./accumarray(r(:)+1,1);
avg = avg(2:floor(min(xs,ys)/2)+1);
if qplot
    figure;loglog(1:floor(min(xs,ys)/2),avg);
    xlabel('Spatial frequency (cycles/image)');
    ylabel('Energy');
end