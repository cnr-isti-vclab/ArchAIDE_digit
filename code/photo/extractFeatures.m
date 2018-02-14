function H = extractFeatures(img, points)
%
%
%      [R, angle, t] = estimateR(p1, p2, ft1, ft2)
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

L = lum(img);
pS = 4;

H = [];
for i=1:size(points, 1)
   
    x = points(i, 1);
    y = points(i, 2);
    
    try
    p = L((y - pS):(y + pS), (x - pS):(x + pS));
    
    mu_p = mean(mean(p));
    
    p(p >  mu_p) = 1;
    p(p <= mu_p) = 0;

    h = histImg(p, 8) * 32;
    
    catch 
        h = zeros(1,8)';
    end
    H = [H; h'];  

end

end