function H = histImg(img, nBin)
%
%
%   H = histImg(img, nBin)
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
L = ClampImg(L, 0.0, 1.0);

H = zeros(nBin, 1);

x = ceil(L(:) * (nBin - 1) + 1);

tot = size(L(:), 1);

for i=1:nBin
    H(i) = length(find(x == i)) / tot;
end

end