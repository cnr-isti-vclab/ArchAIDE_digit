function out = smoothProfile(profile, lambda)
%
%
%       out = smoothProfile(profile, lambda)
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

if(size(profile, 1) < 32)
    return;
end

if(~exist('lambda', 'var'))
    lambda = 0.5;
end

n = size(profile, 1);

if(n < 3)
    return;
end

out = profile;

for i=2:(n - 1)
    p1 = profile(i - 1, :);
    p2 = profile(i + 1, :);
    c = (p1 + p2) / 2;
    
    delta = profile(i, :) - c;

    out(i, :) = c + delta * lambda;
end

end