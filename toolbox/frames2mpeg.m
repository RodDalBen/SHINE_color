% frames2mpeg
%
% Create an mpeg video from images
%
% (c) Todd Karin
%
% This function is an adaptation of the imageFolder2mpeg function by
% Todd Karin.
%
% The frame rate is now provided by the video2frames function, quality was
% increased, and external player was turned off.
% SHINE_color, April 2019, version 0.1.
% Rodrigo Dal Ben (dalbenwork@gmail.com)
% ------------------------------------------------------------------------
%
% Todd Karin
% IMAGEFOLDER2MPEG - create an mpeg video from images
%
% imageFolder2mpeg(folderName) creates an mpeg (.mp4) video by stitching
% together the images in the folder named folderName. The images are read
% in and exported out individually so that no memory overload occurs. It is
% important that the only files in the folder are the images to be turned
% into a movie.
%
% Also, note that alphabetical ordering can be messed up for certain
% numbering schemes. For example 'file2.jpg' comes before 'file18.jpg'. To
% get around this, label your images 'file02.jpg' and 'file18.jpg'
%
% The format of the image files can be anything readable by matlab's imread
% function. jpg and png formats have been tested extensively.
%
% The movie is saved in the current directory as 'folderName.mp4' by
% default
%
% OPTIONS
%
%   frameRate - default is 24 (fps).
%
%   numsToExport - vector of integers showing which of the files in
%   folderName to export, where the files are numbered in alphabetical
%   order.
%
%   quality - video quality, can be 1-100. Default is 75
%
%   openInExternalPlayer - [{1} 0] Whether or not to open the movie in the
%   default video player on the computer after completion. This option has
%   only been tested on mac OS.
%
%   movieFname - file name to save the movie as. Default is
%   'folderName.mp4'
%
%
% EXAMPLES
%
%   Simple call:
%
%   >> imageFolder2mpeg('exampleImages')
%
%   Set frame rate:
%
%   >> imageFolder2mpeg('exampleImages','frameRate',30)
%
%   Only export images 1 through 10
%
%   >> imageFolder2mpeg('exampleImages','numsToExport',1:10)
%
%
% Todd Karin
% 09/04/2013
% ------------------------------------------------------------------------
% SHINE_color toolbox, April 2019, version 0.1
% adapted by Rodrigo Dal Ben
%
% Frame rate is now provided by the original video.
% The video files is renamed according to SHINE_color names.
% The output directory is specified according to the SHINE_color output
% folder.


function frames2mpeg(output_folder,frame_rate,varargin)

% Do some validity checking on param-value pairs
paramPairs = varargin;
if (rem(length(paramPairs),2) ~= 0)
  error(['Invalid input syntax. Optional parameters and values' ...
	 ' must be in pairs.']);
end

% Default param values
frameRate = frame_rate; % SHINE_color: frame rate comes from the video2frame function.
quality = 100;
numsToExportOn = 0;
openInExternalPlayer = 0; % SHINE_color: external player off.
movieFname = ['SHINE_color_video.mp4']; %SHINE_color: rename video.

% Process param-value pairs
for k = 1:2:length(paramPairs)
    param = lower(paramPairs{k});
    if (~ischar(param))
        error('Optional parameter names must be strings');
    end
    value = paramPairs{k+1};
    switch (param)
        case 'framerate'
            frameRate = value;
        case 'quality'
            quality = value;
        case 'numstoexport'
            numsToExportOn = 1;
            numsToExport = value;
        case 'openinexternalplayer'
            openInExternalPlayer = value;
        case 'moviefname'
            movieFname = value;
        otherwise
            error('Option not recognized')
    end
end


% Get all the file names in the folder
fnames = getAllFilesInFolder(output_folder);
N = length(fnames);
disp(['Found ' num2str(N) ' images '])


% Set up video writer object
writerObj = VideoWriter(fullfile(output_folder, movieFname),'MPEG-4'); %SHINE_color: output directory specified.
set(writerObj,'FrameRate',frameRate,...
    'Quality',quality)

disp('Writer object parameters:')
get(writerObj)
open(writerObj);

if ~numsToExportOn
    numsToExport=1:N;
end

N = length(numsToExport);
disp(['Number of images to export: ' num2str(N) 10 10])
disp('Running Export...')
% Read in and export the images. Print time elapsed
tic
tlast=0;
disp(['Percent Done (%)'   9  'Time Remaining (s)']);
for j=numsToExport

    % Write the video
    writeVideo(writerObj, imread(fullfile(output_folder, fnames{j})) );

    % print out progress
    tnow=toc;
    if tnow>tlast+1
        tlast = tlast+.5;
        %disp(['Percent Done: ' num2str(100*j/N,'%2.2f') '%' 9 9 'Time Remaining: ' num2str(tnow/j*N-tnow,'%2.1f') ' s']);
        disp(['  ' num2str(100*j/N,'%2.2f') ' ' 9 9 '  ' num2str(tnow/j*N-tnow,'%2.1f') ]);

    end

end

disp([10 'Elapsed time for creating the video: ' num2str(toc,2) 's' 10]); %SHINE_color: explicitly says that the elapsed time is related to the video.
close(writerObj);

if openInExternalPlayer
    disp('Opening in external player:')
    unix(['open' movieFname]);
end
