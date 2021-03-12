% images = specMatch(images,rescaling,tarmag)
%
% Function for specifying the Fourier spectra of a set of images
%
% INPUT:
% (1) images: a cell (1xN or Nx1) that contains N source image matrices
%      Example 1: 
%       images = cell(3,1); 
%       images{1} = pic1; 
%       images{2} = pic2;
%       images{3} = pic3;
%      Example 2: 
%       [images,N] = readImages(pathname,imformat);
% (2) rescaling: optional; determines whether the luminance values
%     are rescaled (0=no rescaling, 1=rescale absolute max/min (default),
%     2=rescale average max/min) after Fourier amplitude specification 
% (3) tarmag: optional; target spectrum; if not specified,
%     the average spectrum across the input images is used
%
% OUTPUT:
% (1) images: cell containing the images equated in amplitude spectra

% ------------------------------------------------------------------------
% SHINE toolbox, May 2010
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

function images = specMatch(images,rescaling,tarmag)

if iscell(images) == 0
    error('The input must be a cell.')
elseif min(size(images)>1)
    error('The input cell must be of size 1 x numim or numim x 1.')
end
if nargin < 2
    rescaling = 1;
end
numim = max(size(images));
[xs,ys] = size(images{1});
angs = zeros(xs,ys,numim);
mags = zeros(xs,ys,numim);
for im = 1:numim
    if ndims(images{im}) == 3
        images{im} = rgb2gray(images{im});
    end
    im1 = double(images{im})/255;
    [xs1,ys1] = size(im1);
    if xs~=xs1 || ys~=ys1
        error('All images must have the same size.')
    end
    fftim1 = fftshift(fft2(im1));
    [angs(:,:,im),mags(:,:,im)] = cart2pol(real(fftim1),imag(fftim1));
end
if nargin < 3
    tarmag = mean(mags,3);
end
[xt yt] = size(tarmag);
if xs~=xt || ys~=yt
   error('The target spectrum must have the same size as the images.') 
end
for im = 1:numim
    [XX,YY] = pol2cart(angs(:,:,im),tarmag);
    newimage = XX+YY.*i;
    output = real(ifft2(ifftshift(newimage)));
    if rescaling == 0
        images{im} = uint8(output*255);
    else
        images{im} = output;
    end
end
if rescaling ~= 0
images = rescale(images,rescaling);
end

