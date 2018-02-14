function [checker_length_pixels, points, imgOut, refOut] = extractCheckBoard(img)
%
%
%      [checker_length_pixels, points, imgOut, refOut] = extractCheckBoard(img)
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

bDebug = 0;
bDebug2 = 0;

L = lum(img);

%corners
corners = corner(L, 'Harris', 100);
corners = cleanCorners(L, corners, bDebug);

if(bDebug2)
    hf = figure(32);
    imshow(img);
    hold on;
end

[pattern, pattern_img] = getPattern();

ft_p = extractFeatures(pattern_img, pattern);
ft_img = extractFeatures(L, corners);

refOut = icp2D(pattern, corners, bDebug2, ft_p, ft_img);

ps = 3;
cx1 = round((refOut(7,1) + refOut(8,1) +  refOut(14,1) + refOut(15,1)) / 4);
cy1 = round((refOut(7,2) + refOut(8,2) +  refOut(14,2) + refOut(15,2)) / 4);

cx1_1 = max((cx1 - ps), 1);
cx1_2 = (cx1 + ps);
cy1_1 = max((cy1 - ps), 1);
cy1_2 = (cy1 + ps);
c1 = mean(mean(img(cy1_1:cy1_2, cx1_1:cx1_2, :)));

%
%
%

cx2 = round((refOut(14,1) + refOut(15,1) +  refOut(21,1) + refOut(22,1)) / 4);
cy2 = round((refOut(14,2) + refOut(15,2) +  refOut(21,2) + refOut(22,2)) / 4);

cx2_1 = max((cx2 - ps), 1);
cx2_2 = (cx2 + ps);
cy2_1 = max((cy2 - ps), 1);
cy2_2 = (cy2 + ps);
c2 = mean(mean(img(cy2_1:cy2_2, cx2_1:cx2_2, :)));

checker_length_pixels = sqrt((cx2 - cx1)^2 + (cy2 - cy1)^2);

points = [cx1 cy1; cx2 cy2];

if(sum(c2) > sum(c1))
    c1 = c2; 
    points = [points; cx2 cy2];
else
    points = [points; cx1 cy1];
end

if(bDebug2)
    plot(cx1, cy1, 'r+');
    plot(cx2, cy2, 'r+');
    hold off;
end

imgOut = imWhiteBalance(img, c1);

end


