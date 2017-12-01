function xy_long = getMainLine(BW , bVerticalCheck, debug)
%
%
%       xy_long = getMainLine( BW , bVerticalCheck)
%
%       This function extract the longest line; either horizontal or
%       vertical depending on bVerticalCheck
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

if(~exist('bVerticalCheck', 'var'))
    bVerticalCheck = 1;
end

[H, T, R] = hough(BW);
P  = houghpeaks(H, 10, 'threshold', ceil(0.2 * max(H(:))));
lines = houghlines(BW, T, R, P, 'FillGap', 5, 'MinLength', 7);
max_len = 0;
xy_long = [];

if(debug)
    figure(88);
    imshow(BW);
    hold on;
end

%for each extracted line
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   % determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   
   if(debug)
       drawAxis(xy);
   end
   
   dx = abs(xy(1,1) - xy(2,1));
   dy = abs(xy(1,2) - xy(2,2));
  
   if(bVerticalCheck)
       if ( len > max_len &  (dy > dx))
          max_len = len;
          xy_long = xy;
       end
   else
       if(len > max_len &  (dx > dy))
          max_len = len;
          xy_long = xy;
       end
   end
end

if(isempty(xy_long))%last hope
    disp('last hope...');
    [r, ~] = size(BW);
    values = sum(BW, 1);
    [v, x] = max(values);
    
    if((v * 6) > r)
        xy_long = [x, 1; x, r];
    end
end

if(debug)
    hold off;
end

end

