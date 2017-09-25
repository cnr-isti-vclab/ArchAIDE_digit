function bLeftRight = detectLeftRightSide(img)
%
%
%       bLeftRight = detectLeftRightSide(img)
%
%
% Digit
% An automatic MATLAB app for the digitalization of archaeological drawings. 
% http://vcg.isti.cnr.it
% 
% Copyright (C) 2016-17
% Visual Computing Laboratory - ISTI CNR
% http://vcg.isti.cnr.it
% Main author: Francesco Banterle
% 
% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/.
%

img = 1 - img;
[r, c] = size(img);
[X, ~] = meshgrid(1:c,1:r);
X = X / c;

cX = X .* img;

direction = mean(cX(img > 0.5));

bLeftRight = direction > 0.5;

end