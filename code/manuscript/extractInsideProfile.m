function [ip, x_cut, y_cut] = extractInsideProfile(lines, y_axis, bHandles)
%
%
%        [ip, x_cut, y_cut] = extractInsideProfile(lines, y_axis, bHandles)
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

bDebug = 0;

%sanity check
lines = bwmorph(lines, 'thin');

maxSearch = round(size(lines, 1) / 2);
dist = zeros(maxSearch, 1);
cuts = zeros(maxSearch, 2);

j = 1;
for i=1:maxSearch
    [x_cut, y_cut] = cutpoint(lines, y_axis, i);

    if(x_cut > 0 && y_cut > 0)
        cuts(j, 1) = x_cut;
        cuts(j, 2) = y_cut;
        dist(j) = (x_cut - y_axis)^2 + y_cut.^2;
        j = j + 1;
    end
end

if(bHandles)
    [~, index] = min(dist); %min for amphorae
else
    [~, index] = max(dist); %min for amphorae
end

if(index > 0)
    x_cut = cuts(index, 1);
    y_cut = cuts(index, 2);
        
    if(index > 1)
        tx_cut = cuts(index - 1, 1);
        ty_cut = cuts(index - 1, 2);
        lines(ty_cut, tx_cut) = 0;
    end
    
    ip = lineCrawlerGen(lines, x_cut, y_cut);
    
    figure(10);
    imshow(lines);
    hold on;
    plot(x_cut, y_cut, 'go');
    
    if(~isempty(ip))
        [~, indx] = max(ip(:,2));

        if(indx ~= size(ip, 1))
            ip((indx + 1):end, :) = [];
        end
    end
else
    x_cut = -1;
    y_cut = -1;    
    ip = [];
end

if(~isempty(ip))
    d = abs(ip(:,1) - y_axis);  
    
    tmp = find(d < 5);
    
    if(~isempty(tmp))
        indx = min(tmp);
    
        ip = ip(1:indx, :);
        ip(end, 1) = y_axis;
    end
end


if(bDebug)
    figure(48);
    imshow(lines);
    hold on;               
    drawPolyLine(ip, 'red');
    hold off;
end

end