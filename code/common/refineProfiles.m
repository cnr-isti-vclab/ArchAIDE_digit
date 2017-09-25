function [op_handle, op_mouth] = refineProfiles(ip, op_handle, op_mouth)
%
%
%       [op_handle, op_mouth] = refineProfiles(ip, op_handle, op_mouth)
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

if(isempty(ip) | isempty(op_handle) | isempty(op_mouth))
   return 
end

h = size(op_handle, 1);
m = size(op_mouth, 1);

if(h < 3 | m < 3)
    return
end

maxIterations = 10000;

f_oh_i = -1;
f_om_i = -1;
err = 1e20;

for i=1:maxIterations
    oh_i = ClampImg(round(rand() * h / 2), 2, h - 1);
    om_i = ClampImg(round(rand() * m * 3 / 4 + m * 1 / 4), 2, m - 1);

    v_oh_op = op_handle(oh_i, :);
    v_om_op = op_mouth(om_i, :);
    
    d_op = v_om_op - v_oh_op;
    dist_op = sqrt(sum(d_op(:).^2));
    d_op = d_op / dist_op;
    
    [d1, oh_ip] = findClosestPointInProfile(ip, v_oh_op);
    [d2, om_ip] = findClosestPointInProfile(ip, v_om_op);
    
    v_oh_ip = ip(oh_ip, :);
    v_om_ip = ip(om_ip, :);    
    
    d_ip = v_om_ip - v_oh_ip;
    d_ip = d_ip / sqrt(sum(d_ip(:).^2));
    
    
    t_err = (1 - d_op * d_ip') + d1 + d2 + 0.2 * dist_op^2;
    
    if(t_err < err)
        err = t_err;
        f_oh_i = oh_i;
        f_om_i = om_i;        
    end
    
end

op_handle = op_handle(f_oh_i:end, :);
op_mouth = op_mouth(1:f_om_i, :);
    

end

% %optional refinement
% function err = residual(r)
%     
%     th = ClampImg(round(r(1)), 2, size(op_handle, 1) - 1);
%     tm = ClampImg(round(r(2)), 2, size(op_mouth, 1) - 1);
%     toh = op_handle(th:end, :);
%     tom = op_mouth(1:tm, :);
%     
%     dm = size(size(tom,1), 1);
%     for i=1:size(tom,1)
%         dx = ip(:,1) - tom(i, 1);
%         dy = ip(:,2) - tom(i, 2);
%         d = dx.^2 + dy.^2;
%         dm(i) = min(d);       
%     end
%     
%     dh = size(size(toh,1), 1);
%     for i=1:size(toh,1)
%         dx = ip(:,1) - toh(i, 1);
%         dy = ip(:,2) - toh(i, 2);
%         d = dx.^2 + dy.^2;
%         dh(i) = min(d);      
%     end  
%     
%     
%    %disp([max(dh) max(dm)]);
%    err = max(dh) + max(dm);
% end
% 
% 
% opts = optimset('Display', 'none', 'TolFun', 1e-12, 'TolX', 1e-12);
% 
% h = round(size(op_handle,1) / 6) ;
% m = size(op_mouth,1) /2;
% 
% r = fminsearch(@residual, [h, m], opts);
% th = ClampImg(round(r(1)), 2, size(op_handle,1) - 1);
% tm = ClampImg(round(r(2)), 2, size(op_mouth,1) - 1);
% 
% op_handle = op_handle(th:end, :);
% op_mouth = op_mouth(1:tm, :);