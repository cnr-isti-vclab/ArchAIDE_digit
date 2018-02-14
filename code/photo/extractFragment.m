function fragment = extractFragment(img, bAuto, cb_points)
%
%
%        fragment = extractFragment(img, bAuto, cb_points)
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

if(~exist('bAuto', 'var'))
    bAuto = 0;
end

if(~exist('cb_points', 'var'))
    cb_points = [];
end

[r,c,~] = size(img);
img = imresize(img, 0.5, 'bilinear');

data = load('color_model_data.mat');

mu_c = data.mu_c;
mu_c = mu_c /sum(mu_c);
L = img(:,:,1) * mu_c(1) + img(:,:,2) * mu_c(2) + img(:,:,3) * mu_c(3);
%imwrite(L, 'L.png');
%L = log(L + 1);

if(bAuto)

    mask = ones(size(L));
    
    if(~isempty(cb_points))
        cb_points = round(cb_points / 2);

        [rl, cl] = size(L);
        [X,Y] = meshgrid(1:cl,1:rl);

        tmp_cb_points = cb_points;
        tmp_cb_points(1,:) = [];

        dist = (tmp_cb_points(:,1) - cb_points(1,1)).^2 + ...
               (tmp_cb_points(:,2) - cb_points(1,2)).^2;
        v = sqrt(min(dist));

        for i=1:size(cb_points, 1)

            dist = (X - cb_points(i,1)).^2 +...
                   (Y - cb_points(i,2)).^2;
            dist = sqrt(dist);
            mask(dist < v) = 0.0;
        end

        for i=1:size(img,3)
            img(:,:,i) = img(:,:,i) .* mask;
        end
        
    end
    
    P_map = applyRBF(img.^(1.0/2.2), data.colors, data.var_distance); 
    [r_p, c_p, ~] = size(P_map);
    
    [X,Y] = meshgrid(1:c_p, 1:r_p);
    x = round(mean(X(P_map > 0.5)));
    y = round(mean(Y(P_map > 0.5)));    
    
    P_map(P_map > 1.0) = 1.0;
    P_map(P_map < 0.0) = 0.0;
else
    [x,y] = getPoints(img, 1);
    patch = img( (y - 8):(y + 8), (x - 8):(x + 8), :);
    color = mean(mean(patch));
    P_map = getPMap(img, color, 0, 0.5);
end

% 
[P, ~] = LischinskiMinimization(L, P_map);

%imwrite(P_map, 'P_map.png');
%imwrite(P, 'P.png');

mask = zeros(size(P));
mask(P >= 0.75) = 1;

%imwrite(mask, 'mask.png');

mask = imFillSmallHolesInMask(mask);
iter = 3;
for i=1:iter
    mask = imerode(mask, ones(3));
end

for i=1:iter
    mask = imdilate(mask, ones(3));
end

[labels, ~] = bwlabel(mask);

%maxLabel = -1;
label = -1;
maxLabel = 1e6;

selected = unique(labels);
for i=1:length(selected)
    j = selected(i);
    
    if(j > 0)
        [I,J] = find(labels == j);
        x_l = mean(J(:));
        y_l = mean(I(:));
        
        d = (x_l - x)^2 + (y_l - y)^2;
        if(d < maxLabel)
            label = j;%d;
            maxLabel = d;% numel(indx);
        end
    end
%     if(numel(indx) > maxLabel & j>0 &)
%         label = j;
%         maxLabel = numel(indx);
%     end    
end


fragment = zeros(size(P));

if(label > -1)
    fragment(labels == label) = 1;
end

iter = 0;
for i=1:iter
    fragment = imerode(fragment, ones(3));
end

for i=1:iter
    fragment = imdilate(fragment, ones(3));
end

fragment = imresize(fragment, [r,c], 'bilinear');
fragment(fragment > 0.5) = 1;
fragment(fragment < 0.5) = 0;

end

