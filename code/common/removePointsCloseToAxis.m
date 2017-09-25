function out = removePointsCloseToAxis(profile, y_axis, threshold)
%
%
%       out = removePointsCloseToAxis(profile, y_axis, threshold)
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

if(~isempty(profile))
    d = abs(profile(:,1) - y_axis);
    
    px = profile(:,1);
    py = profile(:,2);

    px(d < 5) = [];
    py(d < 5) = [];
    out = [px, py];
    
    %snap last point to axis
    if(~isempty(out))
        px = out(end, 1);

        if(abs(px - y_axis) < threshold)
            out(end, 1) = y_axis;
        end
    else
        out = profile;
    end
else
    out = profile;
end

end