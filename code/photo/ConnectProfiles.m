function connection_lines = ConnectProfiles(ip, op)
%
%
%        connection_lines = ConnectProfiles(ip, op)
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

pi = ip(1,:);
po = op(1,:);

d = sqrt(sum(pi - po).^2);

if(d > 0.5)
    connection_lines = [connection_lines; po; pi];
end

pi = ip(end,:);
po = op(end,:);

d = sqrt(sum(pi - po).^2);

if(d > 0.5)
    connection_lines = [connection_lines; po; pi];
end

end