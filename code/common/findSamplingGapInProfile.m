function [b, i1, i2] = findSamplingGapInProfile(profile, start)
%
%
%        [b, i1, i2] = findSamplingGapInProfile(profile, start)
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

if(~exist('start', 'var'))
    start = 1;
end
n = size(profile, 1);

i1 = -1;
i2 = -1;
b = 0;
for i=start:(n - 1)
    diff = sqrt(sum((profile(i, :) - profile(i + 1, :)).^2));
    
    if(diff > 4) %in theory sqrt(2)...\
        i1 = i;
        i2 = i + 1;
        b = 1;
        break;
    end
end

end