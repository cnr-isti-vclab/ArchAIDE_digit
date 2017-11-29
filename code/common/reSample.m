function out = reSample( profile )
%
%
%        out = reSample( profile )
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

n = size(profile, 1);
if(~isempty(profile) & (n > 2))
    
    out = [];
    for i=1:(n - 1)
        delta = profile(i + 1,:) - profile(i,:);
        d = sqrt(sum((delta).^2));
        
        if(d > 2)
            dr = round(d);
            
            for j=0:2:dr
                p = round(delta * (j / dr)) + profile(i,:);
                
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

