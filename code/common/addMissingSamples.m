function profile_out = addMissingSamples(profile, bStop)
%
%
%       profile_out = addMissingSamples(profile)
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

if(~exist('bStop', 'var'))
    bStop = 0;
end

start = 1;
bFlag = 1;
profile_out = [];
i1 = -1;
i2 = -1;
i2_old = -1;
while(bFlag)
    
    [bFlag, i1, i2] = findSamplingGapInProfile(profile, start);
    
    if(bFlag)
        profile_out = [profile_out; profile(start:i1,:)];
        
        ps = profile(i1, :); %start
        pe = profile(i2, :); %end
        
        nSamples = round(sqrt((pe(1) - ps(1))^2 + (pe(2) - ps(2))^2)) + 1;
        s = [];
        
        if(nSamples > 0)
            dy = pe(2) - ps(2);
            dx = pe(1) - ps(1);
            
            if(dx == 0)
               for i=1:(nSamples - 1)
                   tmp(1, 1) = ps(1, 1);
                   tmp(1, 2) = ps(2) + i;
                   s = [s; tmp];
               end             
            else
               for i=1:(nSamples - 1)
                   tmp(1, 1) = ps(1) + round(dx / nSamples * i);
                   tmp(1, 2) = ps(2) + round(dy / nSamples * i);
                   s = [s; tmp];
              end            
            end            
        end
                
        i2_old = i2;
        profile_out = [profile_out; s];
                
        start = i2 + 1;
    end    
    
    if(bStop)
        bFlag = 0;
    end
end

if(i2_old > 0)
    profile_out = [profile_out; profile(i2_old:end,:)];
end

if(isempty(profile_out))
    profile_out = profile;
end

end
