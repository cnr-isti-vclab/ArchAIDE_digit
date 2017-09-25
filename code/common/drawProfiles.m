function drawProfiles(inside_profile, outside_profile )
%
%
%        drawProfiles(inside_profile, outside_profile )
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

%
%inside profile
%    

if(~isempty(inside_profile))
    drawPolyLine(inside_profile, 'red');
end

%
%outside profile
%

if(~isempty(outside_profile))
    drawPolyLine(outside_profile, 'green');
end

end

