function out = LiveWireProfile(img, profile)
%
%
%        out = LiveWireProfile(img, profile)
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

out = [];

n = size(profile, 1);

figure(7001);
imshow(img);
    hold on;
    
for i=1:16:n
    pOut = LiveWire(img, profile(i,:));
    
    if(~isempty(pOut))
    
        drawPolyLine(pOut, 'green');

    end
end

hold off;

end