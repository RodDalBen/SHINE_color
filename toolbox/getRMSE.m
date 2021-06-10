% rmsqe = getRMSE(im1,im2) 
%
% Computes the root mean square error 
%
% INPUT: 
% (1) im1: the first image being compared 
% (2) im2: the second image being compared
%
% OUTPUT: 
% (1) rmsqe: root mean square error value

% ------------------------------------------------------------------------
% SHINE toolbox, May 2010
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

function rmsqe = getRMSE(im1,im2)

im1 = double(im1);
im2 = double(im2);
rmsqe = sqrt(mean((im1(:)-im2(:)).^2));

