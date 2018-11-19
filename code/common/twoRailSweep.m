function [ pos, tri, nSamples_base ] = twoRailSweep(out_profile, in_profile, base_profile, bFlip, bDebug)
%
%
%       [ pos, tri, nSamples_base ] = twoRailSweep(out_profile, in_profile, base_profile, bFlip, bDebug)
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

pos = [];
tri = [];

if(~exist('bFlip', 'var'))
    bFlip = 0;
end

if(~exist('bDebug', 'var'))
    bDebug = 0;
end
    
delta = 5;

nSamples_base = 128;

if(isempty(out_profile) | isempty(in_profile))
    disp('TwoRailSweep: no geometry created');
else    
    if(isempty(base_profile))
        a = 1.5491;
        b = 0.8403;
        t = ((nSamples_base:-1:1) / nSamples_base) * pi * 2;
        px = cos(t) * a;
        py = sin(t) * b;
                
        base_profile = [px', py'];    
        base_profile = removeMeanStd(base_profile);   
        disp('TwoRailSweep: using the standard shape for handle section');        
    else
        base_profile = removeMeanStd(base_profile);
        
        R = pca(base_profile);
        tmp = R' * base_profile';
        base_profile = tmp';

        base_profile = removeMeanStd(base_profile);
        
        %check if it is clockwise or counter-clockwise
        orientation = getPolylineOrientation( base_profile, delta);
        if(~orientation)
            base_profile = flipud(base_profile);
        end
        
        %resample
        dt_base = 1 / (nSamples_base - 1);
        bp_tmp = [];
        for t = 0:dt_base:1
            p = getPointFromProfile(base_profile, t);  
            bp_tmp = [bp_tmp; p];
        end
        
        base_profile = bp_tmp;
                
        if(bDebug)
            figure(2);
            plot(base_profile(:,1), base_profile(:,2), '+');
        end
    end
    
    %find min point
    y_min = min(base_profile(:,2));
    [~, ind_mp] = findClosestPointInProfile(base_profile, [0.0, y_min]);

    %create geometry
    n = size(out_profile, 1);
    
    base_profile_3d = [base_profile, zeros(size(base_profile, 1), 1)];
    n_bp = size(base_profile_3d, 1);
    
    pOut = zeros(size(base_profile_3d));
        
    if(bDebug)
        figure(1);
        hold on;
    end
    
    %points
    counter = 0;
    
    %compute the center point for having the reference scale
    p_center = out_profile(round(n/2),:);
    [v_center, ~] = findClosestPointInProfile(in_profile, p_center);        
    v_center = sqrt(v_center);
        
    %follow the rail...
    nSamples = 100;
    dt = 1 / (nSamples - 1);
    
    for t = 0:dt:1
        p = getPointFromProfile(out_profile, t);
        p_next = getPointFromProfile(out_profile, t + 10 * dt);
        
        p_up = getPointFromProfile(in_profile, t);
        v = getPointDistance(p, p_up);
        
        %scale the base
        vx = weightFunction(v, v_center);
        vy = v;
        tmp_profile = base_profile_3d;
        tmp_profile(:,1) = tmp_profile(:,1) * vx;
        tmp_profile(:,2) = tmp_profile(:,2) * vy;
        
        
        %create the rotation 3D matrix
        [bOut, M_rot] = CreateRotationMatrix(p, p_next, p_up, 0);
          
        if(bOut)
            pOut = RotateProfile(tmp_profile, M_rot, p, ind_mp);
            
            pos = [pos; pOut];

            if(bDebug)
                plot3(pOut(:,1), pOut(:,2), pOut(:,3), 'bo');
            end
            
            counter = counter + 1;    
        end
        
    end
      
    %triangulation
    if(~isempty(pos))
        shift = 0;
        
       for i=1:(counter - 1)
           for j=0:(n_bp - 2)
               k = j + shift ;
               
               if(bFlip)
                   tri1 = [k + n_bp, k , (k + 1)];
                   tri2 = [k + n_bp + 1, k + n_bp, (k + 1)];                                      
               else
                   tri1 = [k, k + n_bp, (k + 1)];
                   tri2 = [k + n_bp, k + n_bp + 1, (k + 1)];                   
               end
               
               tri = [tri; tri1; tri2];
           end
           
           k = (n_bp - 1) + shift;
           
           if(bFlip)
               tri1 = [k + n_bp, k, shift];
               tri2 = [shift + n_bp, k + n_bp, shift];
           else
               tri1 = [k, k + n_bp, shift];
               tri2 = [k + n_bp, shift + n_bp, shift];
           end
           
           tri = [tri; tri1; tri2];   
           
           shift = shift + n_bp;
           
       end
    end    
    
    if(bDebug)
        plot3(zeros(size(in_profile, 1)), in_profile(:,2), in_profile(:,1), 'r+');
        plot3(zeros(size(out_profile, 1)), out_profile(:,2), out_profile(:,1), 'r+');
    end
end

end

%
%
%
%
%
function out = weightFunction(v, v_center)
    weight = exp(-(v - v_center).^2 / (2 * (v_center / 8)^2));
    out = ((1 - weight) * v_center + weight * v) / (weight + (1 - weight));
end

%
%
%       AUX code
%
%
function [bOut, M_rot] = CreateRotationMatrix(p, p_next, p_up, bFlip)
    %create the rotation 3D matrix
    if(bFlip)
        Z = [0, p(2) - p_next(2), p(1) - p_next(1)];
    else
        Z = [0, p_next(2) - p(2), p_next(1) - p(1)];
    end
    Y = [0, p_up(2)   - p(2), p_up(1)   - p(1)];  

    nZ = norm(Z);
    nY = norm(Y);

    bOut = 1;
    if(nY > 0 & nZ > 0)
        Z = Z / nZ;
        Y = Y / nY;
        X = cross(Z, Y);
        X = X / norm(X);
        M_rot = [X; Y; Z];
    else
        M_rot = [];
        bOut = 0;
    end
end

%
%
%
%
%
function pOut = RotateProfile(profile, M_rot, p, ind_mp)

    p3d = [0 p(2) p(1)];

    n_bp = size(profile, 1);
    
    pOut = zeros(n_bp, 3);
    
    for k=1:n_bp
        tmp = M_rot' * profile(k, :)';                  
        pOut(k,:) = tmp' + p3d;
    end    

    vec_shift = p3d - pOut(ind_mp, :);

    for k=1:3
        pOut(:,k) = pOut(:,k) + vec_shift(k);
    end
end