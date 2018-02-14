function op = extractOutsideProfilePhoto(lines, debug)
%
%
%       op = extractOutsideProfilePhoto(lines, debug)
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

%find starting point
[r,c] = size(lines);

y_start = -1;
x_start = -1;

bFound = 0;
for i=1:r
    for j=1:c
        if(lines(i,j) == 1)
            y_start = i;
            x_start = j;
            bFound = 1;
            break;
        end
    end
    if(bFound)
        break;
    end
end

bFound = 0;
for i=y_start:r
    count = 0;
    for j=1:c
        if(lines(i,j) == 0)
            count = count + 1;
        else
            y_end = i;
            x_end = j;            
        end
    end
    
    if(count == c)
        break;
    end
end

lines(y_start,     min(x_start + 1,c)) = 0;
lines(min(y_start + 1, r), min(x_start + 1, c)) = 0;
lines(max(y_start - 1, 1), min(x_start + 1, c)) = 0;
lines(y_end, x_end) = 0;


op = lineCrawlerGen(lines, x_start, y_start);

if(debug)
    figure(100);
    imshow(lines);
    hold on;
    drawPolyLine(op, 'green');
    
    imwrite(lines, 'test_lines.png');

end

end