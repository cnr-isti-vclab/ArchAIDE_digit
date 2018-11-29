function [imgOut, bS, factor] = imRescaleBinary(img, bImageRescale)
%
%
%       [imgOut, bS, factor] = imRescaleBinary(img, bImageRescale)
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

bS = 0;

[rs, cs, ~] = size(img);

if(bImageRescale)

    numPixels = rs * cs;

    if(rs > cs)
        r2 = 1600;
        c2 = cs * (r2 / rs); 
    else
        c2 = 1600;
        r2 = rs * (c2 / cs);         
    end

    r2 = round(r2);
    c2 = round(c2);

    if(numPixels < 1e6)
        img = imBinary(img);
        [r, c, ~] = size(img);
        while((r * c) < 1e6)
            img = EPX(img);
            bS = bS + 1;
            [r, c, ~] = size(img);
        end

        imgOut = imBinary(imresize(img, [r2, c2], 'bilinear'));
    else
        if(numPixels > 2e6)
            imgOut = imBinary(imresize(img, [r2, c2], 'bilinear'));        
        else
            imgOut = imBinary(img);
        end
    end
else
    bS = -1;
    imgOut = imBinary(img);
end

[re, ce] = size(imgOut);

factor = ((re / rs) + (ce / cs)) / 2;

end