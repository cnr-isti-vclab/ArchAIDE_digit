function [scale_points, ratio_mm_pixels] = extractScale(img, inside_profile, outside_profile, bS)
%
%
%       [scale_points, ratio_mm_pixels] = extractScale(img, inside_profile, outside_profile)
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

scale_points = [];
ratio_mm_pixels = 1.0;

if(isempty(outside_profile) & isempty(outside_profile))
    return;
end

if(isempty(outside_profile))
    y_max = max(inside_profile(:, 2));
else    
    y_max = max([max(inside_profile(:, 2)), max(outside_profile(:,2))]);
end

y_crop = (y_max + 1);

img_crop = img(y_crop:end,:);

%extract the checkboard main line
%tmpLine = imPreprocessingClean( img_crop, 1);
scale = getMainLine( bwmorph(logical(1 - img_crop), 'remove'), 0);

%extract the text
img_crop = imPreprocessingClean( img_crop, 0);

tmp = 1 - img_crop;
total = -1;
index = -1;
for i=1:size(img_crop,1)
    count = 0;
    for j=1:size(img_crop, 2)
        if(tmp(i,j) == 1)
            count = count + 1;
        end
    end
    
    if(count > total)
        total = count;
        index = i;
    end
end


if(index > 0)    
    min_s = round(scale(1,1) * 0.85);
    max_s = round(scale(2,1) * 1.15);    
    img_crop = img_crop(:,min_s:max_s);
end

try
    img_crop = 1 - img_crop;

    %run tesseract-OCR
    for i=1:(bS - 2)
        img_crop = imerode(img_crop, ones(3));
    end
    
    imwrite(1 - img_crop, 'output/tmp.png');

    dos('/usr/local/Cellar/tesseract/3.05.01/bin/tesseract output/tmp.png output -l eng  -psm 3');

    fid = fopen('output.txt', 'r');
    str =fscanf(fid, '%s');
    fclose(fid);

    str = removeGarbageCharacters(str);

    [val,~,~,NEXTINDEX] = sscanf(str, '%f', 2);
    unit = sscanf(str(NEXTINDEX:end), '%s', 1);

    mm_scale = 10;
    if(~isempty(findstr(unit, 'cm')))
        mm_scale = 10;
    else
        if(~isempty(findstr(unit, 'mm')))
            mm_scale = 1;
        else
            if(~isempty(findstr(unit, 'm')))
                mm_scale = 100;
            else
                mm_scale = 10;
            end    
        end
    end
    
    if(isempty(val))
       val = 50; 
    end
        
    if(~isempty(scale) & ~isempty(val))
        scale(:,2) = scale(:,2) + y_crop;
        len = sqrt((scale(1,2) - scale(2,2)).^2 + (scale(1,1) - scale(2,1)).^2);
        scale_points = scale;
        
        disp(['-- Pixels: ', num2str(len)]);
        
        %ratio
        if(length(val) < 2)
            mm = val(1);
        else
            mm =  (val(2) - val(1));
        end
        
        if(mm < 1e-6)
            mm = 50;
        end
        
        ratio_mm_pixels = mm * mm_scale;

        disp(['-- Scale (mm): ', num2str(ratio_mm_pixels)]); 
        ratio_mm_pixels = ratio_mm_pixels / len;
        
        
        disp(['-- Ratio mm/pixels: ', num2str(ratio_mm_pixels)]);
    else
        disp('-- There is no scale!');
    end
    
catch expr
    disp(expr);
end

end

function str = removeGarbageCharacters(str)
   play_book = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.';
   
   for i=1:length(str)
        if(isempty(findstr(play_book, str(i))))
            str(i) =' ';
        end
   end
   
   str = strrep(str, ',', '.');   
end