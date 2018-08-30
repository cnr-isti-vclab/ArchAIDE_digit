function orientation = getPolylineOrientation( profile, shift)
%
%
%        orientation = getPolylineOrientation( profile, shift)
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

if(~exist('shift', 'var'))
    shift = -1;
end

if(shift <= 1)
    shift = 2;
end

shift2 = shift * 2;

counter = zeros(1, 2);

for i=1:(size(profile, 1) - shift2)
    A = profile(i, :);
    B = profile(i + shift, :);
    C = profile(i + shift2, :);

    O = [[1 A]; [1 B]; [1 C]];
    detO = det(O);

    if(detO < 0)
        counter(1) = counter(1) + 1;
    else
        counter(2) = counter(2) + 1;
    end
end

if(counter(1) > counter(2))
    orientation = 1; %clockwise;
else
    orientation = 0; %counter-clockwise;
end

end

