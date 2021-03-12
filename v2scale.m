% rgb2v, February 2019, version 0.1
% (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Converts rgb to hsv color space, then extracts the Value channel and
% scale it to 0-255 (grayscale values).

function y = v2scale(x)
if size(x,3)==3
    hsv = rgb2hsv(x);
    v = hsv(:,:,3);
    y = uint8(v*255);
else
    error('Input must be a rgb')
end