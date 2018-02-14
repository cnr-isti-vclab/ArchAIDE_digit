function out = RBF(x, colors, var_dst)
%
%
%        out = RBF(x, colors, var_dst)
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

dst = zeros(size(colors, 1), 1);
for i=1:3
    dst = dst + (colors(:,i) - x(i)).^2;
end

out = sum(exp(-dst / (2 * var_dst)));

end