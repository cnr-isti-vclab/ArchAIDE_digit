function [scale_points, ratio_mm_pixels] = extractScaleUI(img, scaleValue_in_cm)
%
%
%       [scale_points, ratio_mm_pixels] = extractScaleUI(img, scaleValue_in_cm)
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

hf = figure(256);
imshow(img);

scale_points(1,:) = ginput(1);
scale_points(2,:) = ginput(1);

dist = sqrt(sum((scale_points(1,:) - scale_points(2,:)).^2));

ratio_mm_pixels = scaleValue_in_cm * 10 / dist;

close(hf);

end

