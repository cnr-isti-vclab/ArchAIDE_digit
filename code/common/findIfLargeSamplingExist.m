function [o_cur, o_next, index] = findIfLargeSamplingExist( line )
%
%
%        [o_cur, o_next, index] = findIfLargeSamplingExist( line )
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

n = size(line, 1);

o_cur = [];
o_next = [];
index = -1;

for i=1:(n - 1)
    p_cur = line(i, :);
    p_next = line(i + 1, :);
    
    delta = p_cur - p_next;
    dist = sqrt(sum(delta.^2));
    
    if(dist > 3)
        index = i ;
        o_cur = p_cur;
        o_next = p_next;
        break;
    end
end

end

