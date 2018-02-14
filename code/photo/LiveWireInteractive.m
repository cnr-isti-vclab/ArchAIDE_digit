function profile = LiveWireInteractive(img, pStart, bSnapping)
%
%
%        profile = LiveWireInteractive(img, pStart, bSnapping)
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

bStart = ~isempty(pStart);

if(bStart)
    plot(pStart(1), pStart(2), 'go');
end

wS = 17;

img = filterGaussian(img, 1);

list = [];

i = 1;
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

       index = -1;
       for i=1:(size(list,1) - 1)
           c = (list(i, :) + list(i + 1, :)) / 2;
           r_i = sqrt(sum((list(i, :)  - c).^2));

           r_pos = sqrt(sum((pos - c).^2));

           if(r_pos < r_i)
               index = i;
           end       
       end

       if(index < 0)
          list = [list; pos];
       else
          list = [list(1:index,:); pos; list(index + 1:end,:)];
          hold off;
          imshow(img);
          hold on;
       end

       profile = [];
       for i=1:(size(list,1) - 1)
            x0 = round(list(i, 1));
            y0 = round(list(i, 2));

            x1 = round(list(i + 1, 1));
            y1 = round(list(i + 1, 2));

            x_min = min([x0 - wS, x1 - wS]);
            x_max = max([x0 + wS, x1 + wS]);

            y_min = min([y0 - wS, y1 - wS]);
            y_max = max([y0 + wS, y1 + wS]);

            img_sub = img(y_min:y_max, x_min:x_max);

            profile_i = LiveWire(img_sub, [x0 - x_min, y0 - y_min], [x1 - x_min, y1 - y_min], bSnapping);
            profile_i(:,1) = profile_i(:,1) + x_min;
            profile_i(:,2) = profile_i(:,2) + y_min;
            profile = [profile; flipud(profile_i)];
       end

       drawPolyLine(profile, 'red');
       i = i + 1;
    end
end

close(hf);

end