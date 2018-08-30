function out = lineSimplification(profile, target_n)
%
%
%      out = lineSimplification(profile, target_n)
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
   out = [];
   return
end

n = size(profile, 1);

if(target_n > 0.0 & target_n < 1.0)
   target_n = round(target_n * n);
end

if((n < 5) | (target_n >= n) | (target_n < 2))
    out = profile;
    return
end

while (n > target_n)
    
    area = zeros(n - 2, 1);
    for i=1:(n - 2)
        Pi0 = profile(i    , :);
        Pi1 = profile(i + 1, :);
        Pi2 = profile(i + 2, :);
        
        a = sqrt(sum((Pi0 - Pi1).^2));
        b = sqrt(sum((Pi1 - Pi2).^2));
        c = sqrt(sum((Pi2 - Pi0).^2));
        
        s = (a + b + c) / 2;
        
        area(i) = sqrt(s * (s - a) * (s - b) * (s - c));
    end        
    
    [~, index] = min(area(:));
    
    profile(index + 1,:) = [];   
    
    n = size(profile, 1);
end

out = profile;

end