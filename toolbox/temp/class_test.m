% Oct 07, 2022
% Goal: create a script to mimic the class behavior with RGB layers.
% Useufl reference of built-in matlab imgs: https://www.mathworks.com/help/matlab/import_export/matlab-example-data-sets.html#mw_d7b7b839-5281-47b0-a838-6c6fe5ec32c2

% read rgb images
im1 = imread('street1.jpg');
im2 = imread('street2.jpg');

% combine both images into a cell and create an index
all_images = {im1, im2};
nim = length(all_images);

% create cell to store rgb channels
rgb_channels = cell(nim, 3);

% extract channels
for im = 1:nim
    
    img = all_images{im}; 
    
    channel1{im} = img(:,:,1); % red channel
    channel2{im} = img(:,:,2); % green channel
    channel3{im} = img(:,:,3); % blue channel
    
    % keep all channels in a single cell, each img in one row
    rgb_channels{im, 1} = channel1{im};
    rgb_channels{im, 2} = channel2{im};
    rgb_channels{im, 3} = channel3{im};
    
end

images = rgb_channels;

% index: {row, column}
% {1,1} = first image, channel 1 (red)
% {1,2} = first image, channel 2 (green)
% {1,3} = first image, channel 3 (blue)
% ...

% how to access elements from the cell array
first_column = images(:,1);
second_column = images(:,2);
third_column = images(:,3);




