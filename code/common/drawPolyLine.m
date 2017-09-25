function drawPolyLine(line, color)
%
%
%       drawPolyLine(line, color)
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

if(~isempty(line))
    plot(line(:,1), line(:,2), 'LineWidth',2,'Color', color);

    %end points
    plot(line(1,1), line(1,2), 'o', 'LineWidth',2,'Color', color);
    plot(line(end,1), line(end,2), 'x','LineWidth',2, 'Color', color);
end

end