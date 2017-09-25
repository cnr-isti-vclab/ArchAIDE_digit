function drawAxis(axis)
%
%
%        drawAxis(axis)
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

if(~isempty(axis))
    plot(axis(:,1), axis(:,2), 'LineWidth', 2, 'Color', 'blue');

    plot(axis(1,1), axis(1,2), 'x', 'LineWidth', 2, 'Color', 'blue');
    plot(axis(2,1), axis(2,2), 'x', 'LineWidth', 2, 'Color', 'blue');
end

end

