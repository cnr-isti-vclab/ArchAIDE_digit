function out = cleanCorners(img, corners, bDebug)
%
%
%      out = cleanCorners(img, corners, bDebug)
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

if(~exist('bDebug', 'var'))
    bDebug = 0;
end

if(bDebug)
    figure(21);
    imshow(img);
    hold on;    
    plot(corners(:, 1), corners(:, 2), 'r+');
end

n = size(corners, 1);
touched = zeros(n,1);
out = [];
threhsold_pixels = 16;

for i=1:n
    if(~touched(i))
        touched(i) = 1;  
        
        p = corners(i,:);

        d = sqrt((corners(:,1) - p(1)).^2 + (corners(:,2) - p(2)).^2);
        
        index = find((d <= threhsold_pixels) & (d > 0.5));
        
        n_i = length(index);
        if(n_i > 0)
            p_tmp = p;
            p_m = 1;
            for j=1:n_i
                k = index(j);
                if(~touched(k))                    
                    touched(k) = 1;
                    p_m = p_m + 1;
                    p_tmp = p_tmp + corners(k,:);
                end
            end
            
            out = [out; round(p_tmp / p_m)];
        else
            out = [out; p];            
        end
    end
end

if(bDebug)
    plot(out(:, 1), out(:, 2), 'yo');
    hold off;    
end

hold off;

end