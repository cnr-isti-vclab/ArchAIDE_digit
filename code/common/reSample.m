function out = reSample( profile, threshold )
%
%
%        out = reSample( profile, threshold )
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

if(~exist('threshold', 'var'))
   threshold = 2; %this is for profiles with values in pixels 
end

n = size(profile, 1);
delta = zeros(n - 1, size(profile, 2));
d = zeros(n - 1, 1);

for i=1:(n - 1)
    delta(i, :) = profile(i + 1,:) - profile(i,:);    
    d(i) = sqrt(sum((delta(i,:)).^2));
end

if(threshold < 0)
    threshold = median(d);
end

n = size(profile, 1);
if(~isempty(profile) && (n > 2))           
    out = [];
    for i=1:(n - 1)        
        if(d(i) > threshold)
            %d(i) should be rounded
            
            for j=0:threshold:d(i)
                t = j / d(i);
                p = delta(i,:) * t + profile(i,:);
                
                out = [out; p];
            end
        else
            out = [out; profile(i,:)];
        end
    end

else
    out = [];
end

end

