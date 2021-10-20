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
% SHINE_color toolbox, October 2021, version 0.0.4
% (c) Rodrigo Dal Ben
%
% - Plots are now done directly on the manipulated channels (pre and
% post). The previous version re-read & transformed rgb images.
% ------------------------------------------------------------------------

function diag_plots(images_orig, images, imname, cs, mode)

% set input and output dir
output_folder_diagnostics = fullfile(pwd,'SHINE_color_OUTPUT', 'DIAGNOSTICS');

% set mode
md = mode;

% set initial msg
if md == 1
    disp('Progress: diag_plots not available for luminance match');
    return
else
    disp('Progress: diag_plots in progress, please wait');
end

% set mode for 2 graphs
if md == 2 || md == 3 || md == 4
    md2 = md;
elseif md == 5 || md == 7
    md2 = [2, 3];  % histogram + sf
elseif md == 6 || md == 8
    md2 = [2, 4]; % histogram + spectrum
end
                
% set color space tag
if cs == 1 % hsv
    cs_tag = 'hsv';
elseif cs == 2 % lab
    cs_tag = 'cielab';
end

% set img indices for loops
numim = length(images_orig);
nummd = length(md2);
j = 1:2:numim*2;
k = 2:2:numim*2;

% set number of figures
if md ~= 1
    for h = 1:nummd
        if nummd == 2
            md = md2(h);
        end
        
        % open figure
        fig = figure('visible','off'); % turn on for live preview
        fig.Position = [100 100 numim*320 numim*180]; % [x y width height] full HD proportions
    
        for i = 1:numim
            sp(i) = subplot(numim, 2, j(i)); % 2 img per line (numim/2), 2 columns, variable position
            if md == 2
                plot_name = '_histogram_pre_post';
                % for a bar plot with thicker bars, uncomment next 2 lines and comment 'imhist'
                %[counts, grayLevels] = imhist(images_orig{i}, 256);
                %bar(grayLevels, counts, 'BarWidth', 5),
                imhist(images_orig{i});
                title(imname{i}, 'FontSize', 8);
            
            elseif md == 3
                plot_name = '_spatial_freq_pre_post';
                sfPlot(images_orig{i}, true, cs, true); 
                title(imname{i}, 'FontSize', 8)
            
            elseif md == 4
                plot_name = '_spectrum_pre_post';
                spectrumPlot(images_orig{i}, true, cs, true); 
                title(imname{i}, 'FontSize', 8)                     
            end
            % set axis limits
            axis(sp(i), 'tight');
            
            for l = 2:2:numim*2
                sp(i+1) = subplot(numim, 2, k(i));
                if md == 2
                    %[counts, grayLevels] = imhist(images{i}, 256);
                    %bar(grayLevels, counts, 'BarWidth', 5),
                    imhist(images{i});
                    title(strcat(cs_tag, '-', imname{i}), 'FontSize', 8);
                    % common labs and title
                    labs = axes(fig,'visible','off'); 
                    labs.Title.Visible='on';
                    labs.XLabel.Visible='on';
                    labs.YLabel.Visible='on';
                    title(labs, {'Luminance channel','Pre vs. Post', ''}); % avoid overlay
                    ylabel(labs,{'Number of Pixels', ''});
                    xlabel(labs,{'','Grayscale Luminance (0-255)'});  
                    
                elseif md == 3         
                    sfPlot(images{i}, true, cs, true);
                    title(strcat(cs_tag, '-', imname{i}), 'FontSize', 8)
                    % common labs and title
                    labs = axes(fig,'visible','off'); 
                    labs.Title.Visible='on';
                    labs.XLabel.Visible='on';
                    labs.YLabel.Visible='on';
                    title(labs, {'Luminance channel', 'Pre vs. Post', ''});
                    ylabel(labs,{'Energy', ''});
                    xlabel(labs,{'','Spatial frequency (cycles/image)'});
                
                elseif md == 4
                    spectrumPlot(images{i}, true, cs, true); 
                    title(strcat(cs_tag, '-', imname{i}), 'FontSize', 8)
                    % common labs and title
                    labs = axes(fig,'visible','off'); 
                    labs.Title.Visible='on';
                    labs.XLabel.Visible='on';
                    labs.YLabel.Visible='on';
                    title(labs, {'Luminance channel', 'Pre vs. Post', ''});
                    ylabel(labs,{'Amplitude', ''}); 
                    xlabel(labs,{'','Amplitude'});
                end
                % set axis limits
                axis(sp(i+1), 'tight');
                % link axes
                linkaxes(sp,'xy');
            end
        end
        % save plot
        saveas(fig, fullfile(output_folder_diagnostics, strcat(cs_tag, plot_name)),'png')
    end

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
