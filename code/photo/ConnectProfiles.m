function [connection_lines, ip, op] = ConnectProfiles(ip, op)
%
%
%        [connection_lines, ip, op] = ConnectProfiles(ip, op)
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

connection_lines = [];

if(isempty(ip) | isempty(op))
   return 
end

pi1 = ip(1,:);
pi2 = ip(end,:);
po = op(1,:);

d1 = sqrt(sum(pi1 - po).^2);
d2 = sqrt(sum(pi2 - po).^2);

pi = pi1;
d = d1;
if(d1 > d2)
    d = d2;
    ip(:,1) = flipud(ip(:,1));
    ip(:,2) = flipud(ip(:,2));
    pi = pi2;
    ind_e = 1;
end

if(d > 0.5)
    connection_lines = [connection_lines; po; pi];
end

pi = ip(end,:);
po = op(end,:);

d = sqrt(sum(pi - po).^2);

if(d > 0.5)
    connection_lines = [connection_lines; po; pi];
end


%y grows down
if( ip(end,2) < ip(1,2) )
    ip(:,1) = flipud(ip(:,1));
    ip(:,2) = flipud(ip(:,2));    
end

if( op(end,2) < op(1,2) )
    op(:,1) = flipud(op(:,1));
    op(:,2) = flipud(op(:,2));    
end

end