function [lines, axis_output, y_axis, labels] = imExtraction(img_bw_o, cleaningIterations, bFlip, bAxis)
%
%
%       [lines, axis_output, y_axis, labels] = imExtraction(img_bw_o, cleaningIterations, bFlip, bAxis)
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

%
%clean the image removing unwanted stuff
%

img_bw = imPreprocessingClean(img_bw_o, cleaningIterations);
 
if(mean(img_bw(:)) > 0.999)
    disp('imPreprocessingClean: fail');
    img_bw_o = imPreprocessingClean(img_bw_o, 0);
end


if(bFlip)
    if(detectLeftRightSide(img_bw_o))
       disp('Flipping image...');
       img_bw = fliplr(img_bw); 
       img_bw_o = fliplr(img_bw_o); 
    end
end
 
%
%lines
%
lines = bwmorph(logical(1 - img_bw_o), 'remove');

if(~bAxis)
    lines = bwmorph(logical(1 - img_bw_o), 'remove');
    axis_output = getMainLine( lines );
    if(isempty(axis_output))
        bAxis = 0;
    else
        axis_output(:,1) = round((axis_output(1,1) + axis_output(2,1)) / 2);
    end
end

if(bAxis || isempty(axis_output))
    h = figure(2);
    imshow(lines);
    axis_output = ginput(2);
    axis_output(:,1) = round((axis_output(1,1) + axis_output(2,1)) / 2);
    close(h);
end

y_axis = round((axis_output(1,1) + axis_output(2,1)) / 2);
x_axis = round((axis_output(1,2) + axis_output(2,2)) / 2);

%
%rotation part left out
%

img_bw = logical(1 - img_bw);



labels = bwlabel(img_bw, 8);
lst = unique(labels(labels > 0));
n = length(lst);

[r,c] = size(img_bw_o);
nPixels = r * c;
perCent = 0.0005;

%remove small isolated things
for i=1:n
    indx = find(labels == lst(i));

    l_size = length(indx);
    if(l_size < (nPixels * perCent))
        img_bw(indx) = 0;
        labels(indx) = 0;
    end  
end

%unique labels
lst = unique(labels(labels > 0));
n = length(lst);

labels(:, y_axis:end) = 0;

l_size_max = 1e20;
lst_index_max = -1;
for i=1:n    
    mt = zeros(r, c);
    mt(labels == lst(i)) = 1;
    [yr,xc] = find(mt > 0.5);

    dist = ((yr - x_axis).^2 + (xc - y_axis).^2);
    distindex = find(yr <= y_axis);
    
    sign_label = mean(xc - y_axis);

    if(~isempty(distindex) & sign_label < 0)        
        v = sqrt(min(dist(distindex))) / length(xc);

        if(v < l_size_max)
            l_size_max = v;
            lst_index_max = i;
        end
    end        
end

img_bw = zeros(r, c);
if(lst_index_max > 0)
    img_bw(labels == lst(lst_index_max)) = 1;
end

if(bDebug)
    figure(31);
    imshow(labels);
    figure(33);
    imshow(img_bw);
end

lines = bwmorph(img_bw, 'remove');

lines(:, y_axis:end) = 0;

lines = single(lines);
lines = bwmorph(lines, 'thin');

%modify labels
labels(:, y_axis:end) = 0;
if(lst_index_max > 0)
    labels(labels == lst(lst_index_max)) = 0;
end

end