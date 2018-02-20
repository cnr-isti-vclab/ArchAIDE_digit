function [R, angle, t] = estimateR(p1, p2, ft1, ft2)
%
%
%      [R, angle, t] = estimateR(p1, p2, ft1, ft2)
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

c1 = mean(p1);

c2 = zeros(size(c1));
n = size(p1, 1);
m = size(p2, 1);
ind = zeros(n, 1);

for i=1:n
    p = p1(i,:);
    d = sqrt((p2(:,1) - p(1)).^2 + (p2(:,2) - p(2)).^2);

    d_ft = zeros(size(d));
    for j=1:m
        d_ft(j) = sum(abs(ft2(j,:) - ft1(i,:)));
    end

    d = d + d_ft;
    
    [~, j] = min(d);
    ind(i) = j;
    c2 = c2 + p2(j, :);
end
c2 = c2 / n;

H = zeros(2);
for i=1:size(p1,1)
    j = ind(i);
    t1 = p1(i,:) - c1;
    t2 = p2(j,:) - c2;
    H = H + t1' * t2;
end

[U,S,V] = svd(H);

R = V * U';
if(det(R) < 0)
    V(:,2) = -V(:,2);
    R = V * U';
end

R = real(R);
angle = real(acos(R(1,1)));
t = c2 - (R * c1')';

end