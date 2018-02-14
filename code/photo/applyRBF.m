function out = applyRBF(img, colors, var_dst)
%
%
%      out = applyRBF(img, colors, var_dst)
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

[r_o,c_o,~] = size(img);
img = imresize(img, 0.5, 'bilinear');
[r,c,~] = size(img);

out = zeros(r,c);

for i=1:r
    for j=1:c
         out(i,j) = RBF(img(i,j,:), colors, var_dst);
    end
end

out = imresize(out, [r_o, c_o], 'nearest');


end