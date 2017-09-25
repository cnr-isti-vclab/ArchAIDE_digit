function pos = lineCrawlerGen(img, x, y, y_stop, dx, dy)
%
%
%       pos = lineCrawlerGen(img, x, y, y_stop)
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

if(~exist('y_stop', 'var'))
    y_stop = -1;
end

%pos = []; previous working version
pos = [x, y];
stop = 1;
c = 0;

if(~exist('dx', 'var') | ~exist('dy', 'var'))
    dx = [-1 -1 -1  0 0  1 1 1];
    dy = [-1  0  1 -1 1 -1 0 1];
end

r = size(img, 1);
c = size(img, 2);

if( x < 1 | x > c | y < 1 | y > r)
    pos = [];
    return;
end

while (stop)
    img(y, x) = 0;
    stop = 0;
    x_n = x;
    y_n = y;
    
    for j=1:8  
        mx = x + dx(j);
        my = y + dy(j);
        if(mx > 0 & my > 0 & mx <= c & my <= r)
            if(img(my, mx))
                x_n = x + dx(j);
                y_n = y + dy(j);
                stop = 1;       
            end
        end
    end
    
    if(stop == 1)
        pos = [pos; x_n, y_n];
        c = c + 1;
        x = x_n;
        y = y_n;
    end
    
    if((y_stop > 0) & (y >= y_stop))
        stop = 0;
    end    
end
    
end