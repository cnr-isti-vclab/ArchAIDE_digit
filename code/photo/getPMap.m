function p = getPMap(img, color, bRGB, sigma)
%
%
%       p = getPMap(img, color, bRGB, sigma)
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

if(~bRGB)
    img = ConvertRGBtosRGB(img, 1);
    img = ConvertRGBtoXYZ(img, 0);
    img = ConvertXYZtoCIELab(img, 0);

    color = reshape(color, 1, 1, 3);
    color = ConvertRGBtosRGB(color, 1);
    color = ConvertRGBtoXYZ(color, 0);
    color = ConvertXYZtoCIELab(color, 0);

    delta = zeros(3, 1);
    for i=1:3
        delta(i) = max(max(img(:,:,i))) - min(min(img(:,:,i)));       
    end
    
    sigma = delta * sigma;
else
    sigma = ones(3,1) * sigma;
end

[r,c,col] = size(img);

p = zeros(size(r,c));

for i=1:col
    p = p + (img(:,:,i) - color(i)).^2 / (2 * sigma(i).^2);
end

p = exp(-p);

end