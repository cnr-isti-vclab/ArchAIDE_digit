function profile = LineInteractive(img, pStart)
%
%
%        profile = LineInteractive(img, pStart)
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

profile = [];

hf = figure(95);
imshow(img);
hold on;

button = 1;
thr_pixels = 8;
i = 1;

bStart = ~isempty(pStart);

if(bStart)
    plot(pStart(1), pStart(2), 'go');
end

while(button ~= 3)
    [x,y,button] = ginput(1); 
    
    if(button ~= 3)
        plot(x, y, 'r+');
        pos = [x y];

        if((i == 1) & bStart)
            dist = sqrt(sum((pos - pStart).^2));
            if(dist < thr_pixels)
                pos = pStart;
            end
        end

        profile = [profile; pos];

        drawPolyLine(profile, 'red');

        i = i + 1;
    end
end

close(hf);