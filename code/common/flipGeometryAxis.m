function p = flipGeometryAxis(p, axis, axis_pos)
%
%
%        p = flipGeometryAxis(p, axis, axis_pos)
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

if(~exist('axis', 'var'))
    axis = 1;
end

if(~exist('axis_pos', 'var'))
    axis_pos = 0;
end

radius = p(:, axis) - axis_pos;

p(:, axis) = axis_pos - radius;


end