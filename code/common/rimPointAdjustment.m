function [ip, op] = RimPointAdjustment(ip, op)
%
%
%   [ip, op] = RimPointAdjustment(ip, op)
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

if(~isempty(ip) & ~isempty(op))
    [v_op, indx_op] = min(op(:,2));
    [v_ip, indx_ip] = min(ip(:,2));

    if(v_op < v_ip)        
        ip = [op(indx_op:-1:1,:); ip];

        if(indx_op > 1)
            op(1:(indx_op - 1),:) = [];
        end
    else    
        if(v_op > v_ip)
            op = [ip(indx_ip:-1:1,:); op];
            if(indx_ip > 1)
                ip(1:(indx_ip - 1),:) = [];  
            end
        end
    end
end

end