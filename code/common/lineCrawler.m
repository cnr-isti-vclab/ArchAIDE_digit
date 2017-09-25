function pos = lineCrawler(img, x, y, direction, y_stop)
%
%
%       pos = lineCrawler(img, x, y, direction, y_stop)
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

if(~exist('direction', 'var'))
   direction = 0;   
end

r = size(img, 1);

if(~exist('y_stop', 'var'))
    y_stop = r;
end

if(x < 1 & y < 1)
    error('linecrawler: not valid starting point');
end

pos = [x, y];

direction_x =  cos(direction);
direction_y = -sin(direction);

%choose direction
img(y, x) = 0;
stop = 2;

dx = [-1 -1 -1  0 0  1 1 1];
dy = [-1  0  1 -1 1 -1 0 1];
n = sqrt(dx.^2 + dy.^2);
closest = zeros(8, 1);
for i=1:8
    closest(i) =  (dx(i) / n(i)) * direction_x + (dy(i) / n(i)) * direction_y;
end

[~, indx] = sort(closest, 'descend');

dx = dx(indx);
dy = dy(indx);

%priority
x_n = x;
y_n = y;
for i=1:8
    if(img(y + dy(i), x + dx(i)) > 0.5)
        x_n = x + dx(i);
        y_n = y + dy(i);
        stop = 1;
        break;
    end        
end

if(stop == 1)    
    pos = [pos; lineCrawlerGen(img, x_n, y_n, y_stop, dx, dy)];
end
    
end