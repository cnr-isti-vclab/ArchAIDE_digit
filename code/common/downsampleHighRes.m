function imgOut = downsampleHighRes(img)
%
%
%      imgOut = downsampleHighRes(img)
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

img_bw  = imBinary( img );

[r, c, col] = size(img_bw);

while(r > 2000)    
    img_bw = imerode(img_bw, ones(3));
    
    img_bw = imresize(img_bw, 0.5, 'bilinear');

    img_bw  = imBinary( img_bw, 0 );

    r = round(r / 2);
end

if(r > 1000)
    [r, c, col] = size(img_bw);
    img_bw = imresize(img_bw, [1600, (c / r * 1600)], 'bilinear');
    img_bw  = imBinary( img_bw, 0 );    
end

imgOut = img_bw;

end