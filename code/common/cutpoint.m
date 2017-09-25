function [x_cut, y_cut] = cutpoint(lines, y_axis, i_start)
%
%
%        [x_cut, y_cut] = cutpoint(lines, y_axis, i_start)
%
%        This function computes, given as input an y-axis (x coordinate) and a
%        starting height (i_start), the first hit point (x_cut, y_cut) from
%        y-axis to the profile.
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

r = size(lines, 1);

%cut profile inside
x_cut = -1;
y_cut = -1;

for i=i_start:r
    white = 0;
    firstHit = 0;
    for j=y_axis:-1:1
        white = white + lines(i,j);
        if(lines(i,j) == 1 & white == 1)
            firstHit = j;
            break;
        end
    end
    
    if(firstHit ~= 0)
        x_cut = firstHit;
        y_cut = i;
        break;
    end
end

end