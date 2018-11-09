function p = getPointFromProfile(profile, t, t_delta)
%
%
%       p = getPointFromProfile(profile, t)
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

if(isempty(profile))
    p = [];
    return
end

if(~exist('t_delta', 'var'))
    t_delta = 1e-6;
else
    t_delta = t_delta / 2.0;
end

tMax = 1.0 - t_delta;

if((t > t_delta) && (t < tMax))
    n = size(profile, 1);

    n1 = n - 1;

    t = t * n1;
    t_f = floor(t);
    delta = t - t_f;

    it = t_f;
    it1 = (t_f + 1);

    if(it > n)
        it = n;
    end

    if(it < 1)
        it = 1;
    end

    if(it1 > n)
        it1 = n;
    end

    if(it1 < 1)
        it1 = 1;
    end

    p = profile(it1, :) * delta + (1 - delta) *  profile(it, :);
else    
    if(t <= t_delta)
       p = profile(1, :);
    end
    
    if(t >= tMax)
       p = profile(end, :);
    end
end

end