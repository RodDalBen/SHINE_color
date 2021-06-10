% v2rgb, February 2019, version 0.1
% (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Scale Value channel from 0-255 to hsv values (0-1).

function y = scale2v(x)
if size(x,3)==1
    x = double(x);
    y = (x/255);
else
    error('Input must be a value channel')
end