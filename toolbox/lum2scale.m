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
% SHINE_color toolbox, March 2023, version 0.0.5
% adapted by Rodrigo Dal Ben
%
% ReadImages now performs:
% - RGB to HSV or CIELab transformation, channel extraction, scaling
% ------------------------------------------------------------------------

function y = lum2scale(x, cs)

if cs == 1 % HSV
    y = uint8(x*255);
    
elseif cs == 2 % CIELab
    y = uint8(x*2.55);

end
end
