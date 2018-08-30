function thickness = findMedianThicknessInProfiles(ip, op)
%
%
%        thickness = findMedianThicknessInProfiles(ip, op)
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

n = size(op, 1);

values = zeros(n, 1);

for i=1:n
    [v, ~] = findClosestPointInProfile(ip, op(i,:));
    values(i) = v;
end

values = sqrt(values);

thickness = median(values);

end