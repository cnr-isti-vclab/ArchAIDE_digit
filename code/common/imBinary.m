function img_bw  = imBinary( img )
%
%
%       img_bw  = imBinary( img )
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

img = imContrast(img);

for i=1:8
    img = bilateralFilter(img, [], 0.0, 1.0, 16, 0.05);
end

img_bw = img;
min_v = min(img_bw(:));
max_v = max(img_bw(:));
mean_v = (min_v + max_v ) / 2.0;
img_bw(img_bw >= mean_v) = 1.0;
img_bw(img_bw < mean_v) = 0.0;

end

