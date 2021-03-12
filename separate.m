% [mask_fgr,mask_bgr,background] = separate(image,fig,background)
%
% Function for simple figure-ground segregation
%
% INPUT:
% (1) image: source image 
% (2) fig: optional; if set to 1, the mask is plotted as a binary image, 
%     in which the background is black and the foreground is white
% (3) background: optional; background luminance (e.g., 255); if not 
%     otherwise specified, it is the value that occurs most frequently in
%     the current image
%
% OUTPUT:
% (1) mask_fgr: matrix of the same size as the source image; contains 
%     ones for the foreground and zeros elsewhere
% (2) mask_bgr: matrix of the same size as the source image; contains 
%     ones for the background and zeros elsewhere
% (3) background: optional; specifies the luminance value that was used to
%     define the background in the original image 

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
% Improved speed

function [mask_fgr,mask_bgr,background] = separate(image,fig,background)

if ndims(image) == 3
    image = rgb2gray(image);
end
if nargin < 3 || background > 255 || background < 0
    background = image(find(max(imhist(image))));
end
idx = image==background;
image(idx) = 0;
image(~idx) = 1;
mask_fgr = medfilt2(image);
mask_bgr = uint8((double(mask_fgr)-1)*(-1));
if nargin > 1
    if fig
        figure;imshow(mask_fgr*255);
    end
end
if nargout < 3
   clear background 
end
