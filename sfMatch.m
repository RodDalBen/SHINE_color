% images = sfMatch(images,rescaling,tarmag)
%
% Function for specifying the rotational average of the Fourier amplitude 
% spectra for a set of images
%
% INPUT:
% (1) images: a cell (1xN or Nx1) that contains N source image matrices of
%     the same size
%      Example 1: 
%       images = cell(3,1); 
%       images{1} = pic1; 
%       images{2} = pic2;
%       images{3} = pic3;
%      Example 2: 
%       [images,N] = readImages(pathname,imformat);
% (2) rescaling: optional; determines whether the luminance values 
%     are rescaled after the image modification (0=no rescaling,
%     1=rescale absolute max/min, 2=rescale average max/min)
% (3) tarmag: optional; target spectrum; by default the average spectrum 
%     of all input images is used
%
% OUTPUT:
% (1) images: cell containing the sf-matched images

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
% Revision 1, 26/11/2010
% - Improved speed by using accumarray (Thanks to Diederick Niehorster for 
% suggesting this for the sfPlot function)
% - Use average DC component

function images = sfMatch(images,rescaling,tarmag)

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
if xs ~= xt || ys ~= yt
    error('The target spectrum must have the same size as the images.')
end
f1 = -ys/2:ys/2-1;
f2 = -xs/2:xs/2-1;
[XX YY] = meshgrid(f1,f2);
[t r] = cart2pol(XX,YY);
if mod(xs,2)==1 || mod(ys,2)==1
    r = round(r)-1;
else
    r = round(r);
end
for im = 1:numim
    fftim = mags(:,:,im);
    en_old = accumarray(r(:)+1,fftim(:));
    en_new = accumarray(r(:)+1,tarmag(:));
    coefficient = en_new./en_old;
    cmat = coefficient(r+1);
    cmat(r>floor(max(xs,ys)/2)) = 0;
    newmag = fftim.*cmat;
    [XX,YY] = pol2cart(angs(:,:,im),newmag);
    new = XX+YY*i;
    output = real(ifft2(ifftshift(new)));
    if rescaling == 0
        images{im} = uint8(output*255);
    else
        images{im} = output;
    end
end
if rescaling ~= 0
    images = rescale(images,rescaling);
end