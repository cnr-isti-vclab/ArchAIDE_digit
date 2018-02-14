function out = lineSimplificationDP(profile, ls_epsilon)
%
%
%      out = lineSimplification(profile, ls_epsilon)
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

if(~exist('ls_epsilon', 'var'))
    ls_epsilon = 0.15;
end

if(isempty(profile))
   out = [];
   return
end

if(ls_epsilon <= 1e-6)
    out = profile;
    return
end

dmax = 0;
index = 0;
n = size(profile, 1);

for i=2:(n - 1)
    d = pointLineDistance(profile(i,:), profile(1,:), profile(end,:));
    if ( d > dmax ) 
        index = i;
        dmax = d;
    end
end

if ( dmax > epsilon ) 
    profile1 = DouglasPeucker(profile(1:(index - 1),:), epsilon);
    profile2 = DouglasPeucker(profile(index:end,:), epsilon);
    out = [profile1; profile2];
else
    out = [profile(1,:); profile(end,:)];
end

end

function d = pointLineDistance(x, p1, p2)
    n1 = (p2(2) - p1(2)) * x(1);
    n2 = (p2(1) - p1(1)) * x(2);
    n3 = p2(1) * p1(2);
    n4 = p2(2) * p1(1);
    
    num = abs(n1 - n2 + n3 - n4);
    
    dnum = sqrt((p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
    
    d = abs(num) / dnum;
end