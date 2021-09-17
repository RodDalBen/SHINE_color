% 
% SHINE_color toolbox, September 2021, version 0.0.3
% (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Diagnostic plots for pre and pos transformation images, depending on 
% transformation will plot:
%   - Histogram;
%   - sfPlot;
%   - spectrumPlot;
% Plots saved in SHINE_color_OUTPUT/DIAGNOSTICS.
%  
% ------------------------------------------------------------------------

function diag_plots(input_folder, output_folder, imformat, cs, mode)

% Set input and output source and name pattern
src_input = dir(fullfile(strcat(input_folder, filesep, '*.', imformat))); 
src_output = dir(fullfile(strcat(output_folder, filesep, '*.', imformat)));
output_folder_diagnostics = fullfile(pwd,'SHINE_color_OUTPUT', 'DIAGNOSTICS');

% set mode
md = mode;

% set initial msg
if md ~= 1
    disp('Progress: diag_plots in progress, please wait');
end

% set mode for 2 graphs
if md == 2
    md2 = md;
elseif md == 3
    md2 = md;
elseif md == 4
    md2 = md;
elseif md == 5 || md == 7
    md2 = [2, 3];  % histogram + sf
elseif md == 6 || md == 8
    md2 = [2, 4]; % histogram + spectrum
end
                
% set cs tag
if cs == 1 % hsv
    cs_tag = 'hsv';
elseif cs == 2 % lab
    cs_tag = 'cielab';
end

% set img indices for loops
numim = length(src_input);
nummd = length(md2);
j = 1:2:numim*2;
k = 2:2:numim*2;

% read images
for z = 1:numim
    file_name1 = strcat(input_folder, filesep, src_input(z).name); 
    file_name2 = strcat(output_folder, filesep, src_output(z).name);
    
    % rgb images
    img1{z} = imread(file_name1);
    img2{z} = imread(file_name2);
    
    % scaled luminance
    lum_img1{z} = lum2scale(img1{z}, cs);
    lum_img2{z} = lum2scale(img2{z}, cs);
    
end

if md ~= 1
    for h = 1:nummd
        if nummd == 2
            md = md2(h);
        end
        
        % open figure
        fig = figure('visible','off'); % turn on for live preview
        fig.Position = [100 100 numim*320 numim*180]; % [x y width height] full HD proportions
    
        for i = 1:numim
            subplot(numim, 2, j(i)), % 2 img per line (numim/2), 2 columns, variable position
            if md == 2
                plot_name = '_histogram_pre_pos';
                % for a bar plot with thicker bars, uncomment next 2 lines and comment 'imhist'
                %[counts, grayLevels] = imhist(lum_img1{i}, 256);
                %bar(grayLevels, counts, 'BarWidth', 5),
                imhist(lum_img1{i});
                title(src_input(i).name, 'FontSize', 8)
                ylim([0 inf])
                xlim([-10 266]) % ensure that extreme values are visible
            elseif md == 3
                plot_name = '_spatial_freq_pre_pos';
                sfPlot(img1{i}, true, cs, true); 
                title(src_input(i).name, 'FontSize', 8)
                ylim([-inf inf])
                xlim([-inf inf])                          
            elseif md == 4
                plot_name = '_spectrum_pre_pos';
                spectrumPlot(img1{i}, true, cs, true); 
                title(src_input(i).name, 'FontSize', 8)
                ylim([-inf inf])
                xlim([-inf inf])                     
            end
            
            for l = 2:2:numim*2
                subplot(numim, 2, k(i))
                if md == 2
                    %[counts, grayLevels] = imhist(lum_img2{i}, 256);
                    %bar(grayLevels, counts, 'BarWidth', 5),
                    imhist(lum_img2{i});
                    title(strcat(cs_tag, '-', src_input(i).name), 'FontSize', 8) % cs + same index
                    ylim([0 inf])
                    xlim([-10 266]) 
                    
                    % common labs and title
                    labs = axes(fig,'visible','off'); 
                    labs.Title.Visible='on';
                    labs.XLabel.Visible='on';
                    labs.YLabel.Visible='on';
                    title(labs, {'Luminance channel','Pre vs. Pos', ''}); % avoid overlay
                    ylabel(labs,{'Number of Pixels', ''});
                    xlabel(labs,{'','Grayscale Luminance (0-256)'});
                elseif md == 3         
                    sfPlot(img2{i}, true, cs, true);
                    title(strcat(cs_tag, '-', src_input(i).name), 'FontSize', 8)
                    ylim([-inf inf])
                    xlim([-inf inf])
                
                    % common labs and title
                    labs = axes(fig,'visible','off'); 
                    labs.Title.Visible='on';
                    labs.XLabel.Visible='on';
                    labs.YLabel.Visible='on';
                    title(labs, {'Luminance channel', 'Pre vs. Pos', ''});
                    ylabel(labs,{'Energy', ''});
                    xlabel(labs,{'','Spatial frequency (cycles/image)'});
                elseif md == 4
                    spectrumPlot(img2{i}, true, cs, true); 
                    title(strcat(cs_tag, '-', src_input(i).name), 'FontSize', 8)
                    ylim([-inf inf])
                    xlim([-inf inf])
                    
                    % common labs and title
                    labs = axes(fig,'visible','off'); 
                    labs.Title.Visible='on';
                    labs.XLabel.Visible='on';
                    labs.YLabel.Visible='on';
                    title(labs, {'Luminance channel', 'Pre vs. Pos', ''});
                    ylabel(labs,{'Amplitude', ''}); 
                    xlabel(labs,{'','Amplitude'});
                end
            end
        end
        % save plot
        saveas(fig, fullfile(output_folder_diagnostics, strcat(cs_tag, plot_name)),'png')
    end
%end

% final msgs
if mode == 2
    disp('Progress: diag_plots sucessful (histogram)');
elseif mode == 3
    disp('Progress: diag_plots sucessful (spatial frequency)');
elseif mode == 4
    disp('Progress: diag_plots sucessful (spectrum)');
elseif mode == 5 || mode == 7
    disp('Progress: diag_plots sucessful (histogram and spatial frequency)');
elseif mode == 6 || mode == 8
    disp('Progress: diag_plots sucessful (histogram and spectrum)');
end

% final
disp('Progress: plot(s) are in OUTPUT/DIAGNOSTICS');
end
end
