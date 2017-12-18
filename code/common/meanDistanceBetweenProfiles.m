function d = meanDistanceBetweenProfiles(p1, p2)
%
%
%      d = meanDistanceBetweenProfiles(p1, p2)
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

if(isempty(p1) || isempty(p2))
    error('distanceBetweenProfiles');
end

d = 0;
n = size(p1, 1);
for i=1:n
    
    point = p1(i, :);
    [v, ~] = findClosestPointInProfile(p2, point);
    
    d = d + v;
end

d = d / n;

end