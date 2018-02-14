function profile = LiveWire(img, p_s, p_f, bSnapping)
%
%
%       profile = LiveWire(img, p_s, p_f, bSnapping)
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

img = single(img);

L = lum(img).^2.2;

fZ = (1.0 - edge(L, 'log'));

hY = [1 2 1; 0 0 0; -1 -2 -1];
hX = [-1 0 1; -2 0 2; -1 0 1];

gx = imfilter(L, hX);
gy = imfilter(L, hY);

G = sqrt(gx.^2 + gy.^2);

G_prime = G - min(G(:));
fG = 1 - (G_prime / max(G_prime(:)));

%
%
%

pointers = zeros(size(L,1), size(L,2), 2);

%init
e = zeros(size(L));

g = 1e20 * ones(size(L));

if(isempty(p_s) && isempty(p_f))
   hf = figure(1);
   imshow(img);
   hold on;
   [x, y] = ginput(1);
   p_s(1) = round(x);
   p_s(2) = round(y);

   plot(p_s(1), p_s(2), 'r+');
   
   [x, y] = ginput(1);
   p_f(1) = round(x);
   p_f(2) = round(y);
     
   plot(p_f(1), p_f(2), 'r+');

   hold off;
   close(hf);
end

%
% SNAPPING
%

if(bSnapping)
    x = p_s(1);
    y = p_s(2);
    pSize = 4;
    patch = G((y - pSize):(y + pSize), (x - pSize):(x + pSize));
    [I,J] = find(patch == max(patch(:)));
    p_s(1) = x + J(1) - pSize;
    p_s(2) = y + I(1) - pSize;
end

%
%
%

%disp(p_s); 
%disp(p_f);

g(p_s(2), p_s(1)) = 0;

list = p_s;

nx = [-1 0 1 -1 1 -1 0 1];
ny = [1 1 1 0 0 -1 -1 -1];


[h, w] = size(L);

while(~isempty(list))
   [q, index] = getMinCost(list, g);   
   list(index, :) = [];
   
   g_q = g(q(2), q(1));
   
   e(q(2), q(1)) = 1;
   
   for i=1:8
       r(1) = q(1) + nx(i);
       r(2) = q(2) + ny(i);
       
       if(r(1) <= w & r(1) > 0 & r(2) <= h & r(2) > 0 )
           if(~e(r(2), r(1)))
               g_tmp = g_q + getCost(q, r, fZ, fG, gx, gy);

               [bR, index] = checkList(list, r);

               if(bR & g_tmp < g_q)
                   list(index, :) = [];
               end

               if(~bR)
                   g(r(2), r(1)) = g_tmp;
                   pointers(r(2), r(1), 1) = q(1);% - r(1);
                   pointers(r(2), r(1), 2) = q(2);% - r(2);
                   list = [list; r];
               end
           end
       end
   end
     
end



% figure(2);
% [x,y] = meshgrid(1:w, 1:h);
% quiver(x,y,pointers(:,:, 1),pointers(:,:, 2));
% hold on;
% plot(p_s(1), p_s(2), 'ro');
% hold off;


% m = p_s;
% passed = zeros(size(L));
% profile = p_s;

% while(1)
%     if(isempty(m))
%         break;
%     end
%     
%     if(m(1) < 1 & m(1) > w & m(2) < 1 & m(2) > h)
%         break;
%     end
%         
%     passed(m(2), m(1)) = 1;
%     
%     t = [];
%     
%     tMin = 1e20;
%     for j=1:8
%         r(1) = m(1) + nx(j);
%         r(2) = m(2) + ny(j);
%            
%         if(r(1) > 0 & r(1) <= w & r(2) > 0 & r(2) <= h)
% 
%                tx = pointers(r(2), r(1), 1);
%                ty = pointers(r(2), r(1), 2);
%                tG = g(r(2), r(1));
% 
%                if(tx == m(1) & ty == m(2) & (passed(r(2), r(1)) < 0.5) & tG < tMin )
%                   t = r;
%                   tMin = tG;
%                end       
%         end
%     end
%     
%     profile = [profile; t];
%     m = t;
% end

m = p_f;
passed = zeros(size(L));
profile = p_f;

while(1)
    if(m(1) == p_s(1) & m(2) == p_s(2))
        break;
    end
        
    
    if(isempty(m))
        break;
    end
    
    if(m(1) < 1 & m(1) > w & m(2) < 1 & m(2) > h)
        break;
    end
        
    tx = pointers(m(2), m(1), 1);
    ty = pointers(m(2), m(1), 2);    
        
    t = [tx ty];

    
    profile = [profile; t];
    m = t;
end

bDebug = 0;

if(~isempty(profile) & bDebug)
    figure(64);
    imshow(img);
    hold on;
    drawPolyLine(profile, 'green');
    hold off;
end

end

%
%
%
%
%

function out = getCost(p, q, fZ, fG, gx, gy)
    
    out =       0.43 * fZ(q(2), q(1));
    
    out = out + 0.14 * fG(q(2), q(1)) / norm(p - q);    
    
    %
    %   fD
    %
    Dp = [gy(p(2), p(1)) -gx(p(2), p(1))];
    
    if(norm(Dp) > 0.0)
        Dp = Dp / norm(Dp);
    end
    
    Dq = [gy(q(2), q(1)) -gx(q(2), q(1))];
    
    if(norm(Dq) > 0.0)
        Dq = Dq / norm(Dq);
    end
    
    delta_qp = q - p;
    
    if(Dp * delta_qp' >= 0.0)
        L = delta_qp;
    else
        L = -delta_qp;
    end
    
    if(norm(L) > 0.0)
        L = L / norm(L);
    end
    
    dp_pq = Dp * L';
    dq_pq = L * Dq';
    
    fD = (acos(dp_pq) + acos(dq_pq)) * 2 / (3 * pi);
    
    %
    %   total
    %
    
    out = out + 0.43 * fD;
end

function [b, index] = checkList(list, p)
    b = 0;
    index = -1;
    
    for i=1:size(list, 1)
        if(list(i,1) == p(1) && list(i,2) == p(2))
           index = i;
           b = 1; 
        end
    end
end

function [q, index] = getMinCost(list, G)
    q = [];
    index = -1;
    qMin = 1e30;
    
    for i=1:size(list, 1)
        tmp = G(list(i, 2), list(i, 1));
        if(tmp < qMin)
            index = i;
            q = list(i, :);
            qMin = tmp;
        end
    end
end