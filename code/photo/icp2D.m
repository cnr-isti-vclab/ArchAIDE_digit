function refOut = icp2D(ref, pc, bDebug, ft_ref, ft_pc)
%
%
%       refOut = icp2D(ref, pc, bDebug)
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

n = size(ref, 1);

function err = residuals(p)
    
    err = 0;    
    tVec = [p(1), p(2)];    
    mtx = getRotationMatrix2D(p(3));
    s = p(4);
    cx = mean(ref(:,1));
    cy = mean(ref(:,2));
    
    t_ref(:,1) = ref(:,1) - cx;
    t_ref(:,2) = ref(:,2) - cy;
    
    for j=1:n
        tmp_j = (mtx * t_ref(j,:)' * s);
        tmp_j = tmp_j' + [cx cy] + tVec;
        
        d = ((pc(:,1) - tmp_j(1)).^2 +  (pc(:,2) - tmp_j(2)).^2);
        
        err = err + sqrt(min(d));
    end
    
    if(s < 1.0)
       err = 1e20; 
    end
    
    err = err / n;
end

square_size = EstimateSquareSize(pc);

if(bDebug)
    plot(pc(:,1), pc(:,2), 'm+'); 
end

out_pc = [];
for k=1:n
    t_k = pc(k,:);
    
    dist = sqrt((pc(:,1) - t_k(1)).^2 + (pc(:,2) - t_k(2)).^2); 
    
    index = find( (dist < (square_size * 0.75)) &...
                  (dist > 16));
    
    if(isempty(index))
        out_pc = [out_pc; t_k];
    end
end

pc = out_pc;

square_size_tmp = EstimateSquareSize(pc);
if(square_size_tmp > 0)
    square_size = square_size_tmp;
end

n = size(ref, 1);

if(bDebug)
    plot(pc(:,1), pc(:,2), 'bo'); 
end

d = (ref(:,1) - ref(1,1)).^2 + (ref(:,2) - ref(1,2)).^2;
d = sqrt(min(d(d > 0)));
scale =  square_size / d;

%[angle, t] = estimateR(ref, pc);
cR = mean(ref);
tx = median(pc(:,1)) - cR(1);
ty = median(pc(:,2)) - cR(2);

ref = applyTransform(ref, [tx, ty, 0.0, scale], eye(2));

c = 0;
err = 1e20;
if(bDebug)
    plot(ref(:,1), ref(:,2), 'r*');
end

%
% ICP
%
while(err > 1e-6 & c < 1000)
    [R, angle, t] = estimateR(ref, pc, ft_ref, ft_pc);    
    c = c + 1;
    ref = applyTransform(ref, [t(1), t(2), angle, 1.0], R);
    err = getError(ref, pc);
end

disp(err);

if(bDebug)
    plot(ref(:,1), ref(:,2), 'yo');
end

%'Display', 'iter',
fMin = 1e20;
steps = 72;
opts = optimset('MaxIter', 1000, 'TolFun', 1e-6, 'TolX', 1e-6);
for i=1:steps
    angle = pi * 2 * i / steps;
    [p_tmp, f_tmp] = fminsearch(@residuals, [0.0, 0.0, angle, 1.0], opts);
    
    if(f_tmp < fMin)
        fMin = f_tmp;
        p = p_tmp;
    end
end

%final adjustment
opts = optimset('MaxIter', 10000, 'TolFun', 1e-12, 'TolX', 1e-12);
[p_final, f_final] = fminsearch(@residuals, p, opts);

if(f_final < fMin)
    p = p_final;
end

ref = applyTransform(ref, p, []);    

refOut = ref;

if(bDebug)
    plot(refOut(:,1), refOut(:,2), 'g+');
end

end

%
%
%   additional functions
%
%

function out = applyTransform(ref, p, R)
    tx = p(1);
    ty = p(2);
    scale = p(4);
    
    if(isempty(R))
        R = getRotationMatrix2D(p(3));
    end
    
    cx = mean(ref(:,1));
    cy = mean(ref(:,2));
    
    ref(:,1) = ref(:,1) - cx;
    ref(:,2) = ref(:,2) - cy;
    
    out =[];
    for i=1:size(ref,1)
        tmp_i = (R * ref(i,:)' * scale);
        tmp_i = tmp_i' + [cx, cy] + [tx, ty];
        out = [out; tmp_i];
    end
end

function mtx = getRotationMatrix2D(a)
    mtx = [cos(a) -sin(a); sin(a) cos(a)]';
end

function err = getError(p1, p2)
    
    err = 0; 
    n = size(p1, 1);
    for i=1:n     
        d = (p2(:,1) - p1(i,1)).^2 +  (p2(:,2) - p1(i,2)).^2;        
        err = err + sqrt(min(d));
    end
    
    err = err / n;
end

function square_size = EstimateSquareSize(pc)
    if(size(pc, 1) < 2)
        square_size = -1;
        return;
    end
    
    m_d = [];
    for k=1:size(pc, 1)
        t_k = pc(k,:);
        dist = sqrt((pc(:,1) - t_k(1)).^2 + (pc(:,2) - t_k(2)).^2);
        closest = min(dist(dist > 0));
        m_d = [m_d; closest];
    end
    
    square_size = median(m_d);
end