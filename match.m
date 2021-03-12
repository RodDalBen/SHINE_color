% tim = match(im,target,mask)
%
% Function for exact histogram specification
%
% INPUT:
% (1) im: source image matrix
% (2) target: optional; target "histogram" in the form of a sorted list 
%     of luminance values (vector with values between 0 and 255 in 
%     ascending order);
%     Example 1: target = sort(double(image(:)));
%     Example 2: target = hist2list(imhist(image));
% (3) mask: template of the same size as the image with ones where the
%     histogram modification occurs and zeros everywhere else
%
% OUTPUT:
% (1) tim: image with new histogram

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

function tim = match(im,target,mask)

if ndims(im) == 3
    im = rgb2gray(im);
end
tim = double(im);
rand('seed',sum(100*clock));
if nargin == 3
    if sum(size(mask) ~= size(im)) > 0
        error('The size of the mask must equal the size of the image.')
    elseif numel(mask(mask==1)) == 0
        error('The mask must contain some ones.')
    end
    [svim,iim] = sort(tim(mask==1)+rand(size(tim(mask==1)))*.1);
    svim(iim) = target(round(1:(length(target)-1)/(length(iim)-1):length(target)));
    tim(mask==1) = svim;
else
    [svim, iim] = sort(tim(:)+rand(size(tim(:)))*.1);
    svim(iim) = target(round(1:(length(target)-1)/(length(iim)-1):length(target)));
    tim(:) = svim;
end
%tim = uint8(tim); 

