% scale2v
%
% Scale Value channel from 0-255 to hsv values (0-1).
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
% - Scale L channel from 0-255 to CIELab values (0-100).
% - Renamed the function from 'scale2v' to 'scale2lum' to account for both
% colorspaces.
% ------------------------------------------------------------------------

function y = scale2lum(x, cs)
if size(x,3) == 1
    x = double(x);
    if cs == 1 % hsv
        y = (x/255);
        
    elseif cs == 2 % cielab
        y = (x/2.55);
    end
else
    error('Input must be a value channel')
end
