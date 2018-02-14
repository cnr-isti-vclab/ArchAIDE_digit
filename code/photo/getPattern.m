function [p, out] = getPattern(debug)
%
%
%        [p, out] = getPattern(debug)
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

if(~exist('debug', 'var'))
   debug = 0; 
end

len = 32;
p = [];
out = ones(8 * len, 5 * len);

for i=1:4
    for j=1:7
        tmp(1) = i * len;
        tmp(2) = j * len;
        p = [p; tmp];
        
        if(j < 7)
            if(mod(j, 2) == 1 & mod(i, 2) == 1)
                out(tmp(2):(tmp(2)+len-1),tmp(1):(tmp(1)+len-1)) = 0;
            end
        end
        
        if(i < 4)
            if(mod(j, 2) == 0 & mod(i, 2) == 0)
                out(tmp(2):(tmp(2)+len-1),tmp(1):(tmp(1)+len-1)) = 0;
            end        
        end
    end
end

p(end,:) = [];
p(7,:) = [];

if(debug)
    figure(1);
    imshow(out);
    hold on;
    plot(p(:,1), p(:,2), 'r+');
    hold off;
end

end