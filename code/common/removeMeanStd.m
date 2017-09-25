function out = removeMeanStd( profile )
%
%
%       out = removeMeanStd( profile )
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

x = profile(:, 1);
y = profile(:, 2);

mX = mean(x);
mY = mean(y);

x = (x - mX);
y = (y - mY);

nY = abs(max(y) - min(y));

x = x / nY;
y = y / nY;

out = [x, y];

end

