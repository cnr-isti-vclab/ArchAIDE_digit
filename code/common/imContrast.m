function imgOut = imContrast(img)
%
%
%        img = imContrast(img)
%
%        This function adds a safety frame and increases the contrast of
%        img.
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

img = lum(img.^2.2);
[r,c] = size(img);

value = MaxQuart(img, 0.5);

imgOut = ones(r + 16, c + 16) * value;
imgOut(8:(r + 7), 8:(c + 7)) = img;

end