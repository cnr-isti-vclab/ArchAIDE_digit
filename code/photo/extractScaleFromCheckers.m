function [mm_over_pixels, points_scale] = extractScaleFromCheckers(img, mm)
%
%
%   [mm_over_pixels, points_scale] = extractScaleFromCheckers(img, mm)
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

size(img)

[x, y] = getPoints(img, 2);

points_scale = [x y];

pixels = sqrt((x(2) - x(1))^2 + (y(2) - y(1))^2);

mm_over_pixels = mm / pixels;

disp('Scale Extraction Info:');
disp(['- pixels: ', num2str(pixels)]);
disp(['- mm: ', num2str(mm)]);
disp(['- mm / pixels: ', num2str(mm_over_pixels)]);

end