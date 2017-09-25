function [v, index] = findClosestPointInProfile(profile, point, p_t)
%
%
%       [v, index] = findClosestPointInProfile(profile, point, p_t)
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

dx = profile(:,1) - point(1);
dy = profile(:,2) - point(2);
d = dx.^2 + dy.^2;
[v_tmp, index_tmp] = min(d);

if(~exist('p_t', 'var'))
    v = v_tmp;
    index = index_tmp;
else
    n_d = sqrt(d);
    dx = dx ./ n_d;
    dy = dy ./ n_d;

    s = 1 - (dx * p_t(1) + dy * p_t(2));
    d2 = d .* s;
    
    [~, index] = min(d2(n_d > 0.0));
    
    v = d(index);
    
    v_s = sqrt(v);
    v_tmp_s = sqrt(v_tmp);
    
    if(abs(v_s - v_tmp_s) > 100)
        v = v_tmp;
        index = index_tmp;
    end
end

end