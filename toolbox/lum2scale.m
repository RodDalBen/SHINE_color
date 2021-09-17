% v2scale
%
% Converts rgb to hsv color space, then extracts the Value channel and
% scale it to 0-255 (grayscale values).
% ------------------------------------------------------------------------
% SHINE_color toolbox, February 2019, version 0.0.1
% (c) Rodrigo Dal Ben
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
% Kindly report any suggestions or corrections dalbenwork@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, September 2021, version 0.0.3
% (c) Rodrigo Dal Ben
%
% - Converts rgb to cielab color space, then extracts the L channel and
% scale it to 0-255 (grayscale values).
% - Renamed the function from 'v2scale' to 'lum2scale' to account for both
% colorspaces.
% ------------------------------------------------------------------------

function y = lum2scale(x, cs)
if size(x,3)==3
    if cs == 1 % HSV
        hsv = rgb2hsv(x);
        v = hsv(:,:,3);
        y = uint8(v*255);
        
    elseif cs == 2 % CIELab
        lab = rgb2lab(x);
        l = lab(:,:,1);
        y = uint8(l*2.55);
    end 
else
    error('Input must be a rgb')
end
