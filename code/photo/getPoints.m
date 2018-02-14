function [x,y] = getPoints(img, numPoints)
%
%
%   [x,y] = getPoints(img, numPoints)
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

hf = figure(4001);
imshow(img);
hold on;
[x,y] = ginput(numPoints);
x = round(x);
y = round(y);    
hold off;
close(hf);

end