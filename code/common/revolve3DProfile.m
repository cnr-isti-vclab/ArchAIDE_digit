function [pos, tri] = revolve3DProfile(profile, y_axis, res_360, bFlip, bBottomCap)
%
%
%        [pos, tri] = revolve3DProfile(profile, y_axis, res_360, bFlip, bBottomCap)
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

tri = [];
pos = [];

if(isempty(profile))
    return;
end

if(~exist('res_360', 'var'))
    res_360 = 120;
end

if(~exist('bFlip', 'var'))
    bFlip = 0;
end

if(~exist('bBottomCap', 'var'))
    bBottomCap = 1;
end

res_360m1 = res_360 - 1;

%vertices
risy = 0;
    
nSamples = 240;
dt = 1 / (nSamples - 1);

lowest = 0;
for t = 0.0 : dt : 1.0
    p = getPointFromProfile(profile, t, dt);  
    if(~isempty(p))
        lowest = p(2);
        radius = p(1) - y_axis;

        for j=0:res_360m1
            phi = (pi * 2 * j) / res_360;
            x_t = cos(phi) * radius + y_axis;
            z_t = sin(phi) * radius + y_axis;
            pos = [x_t p(2) z_t; pos];
        end

        risy = risy + 1;
    end
end

%triangles
for j=1:(risy - 1)
    v = (j - 1) * res_360;

    for i=0:res_360m1
        if(i == res_360m1)
            tri = [tri; v, (v + res_360), (v + i + res_360)];
            tri = [tri; (v + i), v, (v + res_360 + i)];
        else
            tri = [tri; (v + i), (v + i + 1), (v + res_360 + i)];
            tri = [tri; (v + i + res_360), (v + i + 1), (v + res_360 + i + 1)];
        end
    end
end

if(bBottomCap)
    pos = [pos; y_axis lowest y_axis];
end

if(bBottomCap)
    m = size(pos, 1);
    
    v = 0;%(risy - 2) * res_360;

    for i=0:res_360m1
       if(i == res_360m1)
           tri = [tri; (v + i), (m - 1), v];
       else
           tri = [tri; (v + i), (m - 1), (v + i + 1)];
        end
    end
end
    
if(bFlip == 1)
    tri = flipTriangles(tri);
end


end
