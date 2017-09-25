function handle_section = extractHandleSection(labels, bDebug)
%
%
%       handle_section = extractHandleSection(labels, bDebug)
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

if(~exist('bDebug', 'var'))
    bDebug = 0;
end

handle_section = [];

lst = unique(labels(labels>0));
n = length(lst);

if(n == 1)
    labels(labels > 0) = 1;
    img_bw = labels;
else
    img_bw = zeros(size(labels));
    l_size_max = 0;
    l_size_index = -1;
    for i=1:n
        indx = find(labels == lst(i));

        l_size = length(indx);
        if(l_size > l_size_max)
            l_size_max = l_size;
            l_size_index = i;
        end    
    end
    
    if(l_size_index > 0)
        img_bw(labels == lst(l_size_index)) = 1;
    end
end

lines = bwmorph(logical(img_bw), 'remove');
lines(:,1) = 0;
lines(:,end) = 0;
lines(1,:) = 0;
lines(end,:) = 0;
[y,x] = find(lines > 0.5);


if(~isempty(x))
    handle_section = lineCrawlerGen(lines, x(1), y(1));

    if(bDebug)
        figure(1);
        imshow(img_ori);
        hold on;
        drawPolyLine(handle_section, 'blue');
        hold off;

    end
end

end