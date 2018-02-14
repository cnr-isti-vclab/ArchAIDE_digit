function out = imFillSmallHolesInMask(mask)
%
%
%       out = imFillSmallHolesInMask(mask)
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

mask_inv = 1.0 - mask;
[labels, ~] = bwlabel(mask_inv, 4);
selected = unique(labels);

for i=1:length(selected)
    j = selected(i);
    indx = find(labels == j);
    if(numel(indx) <= 2000)     
        mask(indx) = 1;
    end
end

out = mask;

end