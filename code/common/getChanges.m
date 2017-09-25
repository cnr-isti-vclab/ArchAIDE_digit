function [num_changes, x_first_hit, x_last_hit] = getChanges(lines, x, y)
%
%
%       [num_changes, x_first_hit, x_last_hit] = getChanges(lines, x, y)
%
%       This function computes the first hit (x_first_hit, y_first_hit) 
%       from (x,y) towards left, where num_changes is the number of times
%       there is a change from 0 to 1.
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

state = lines(y,x);
num_changes = 0;
first = 0;
x_first_hit = -1;
x_last_hit = -1;

for i=(x - 1):-1:1
    t = lines(y, i);
    
    if((t == 1) & (state == 0))
        num_changes = num_changes + 1;
        x_last_hit = i;
        
        if(first == 0)
            x_first_hit = i;
            first = 1;
        end
    end
    
    state = t;
end

end
