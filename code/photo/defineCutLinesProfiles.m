function [out, ip_out, op_out] = defineCutLinesProfiles(img, ip, op)
%
%
%       [out, ip_out, op_out] = defineCutLinesProfiles(img, ip, op)
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

out = [];

if(isempty(ip) | isempty(op))
    return
end

hf = figure(391);
imshow(img);
hold on;

drawPolyLine(ip, 'red');
drawPolyLine(op, 'green');

button = 1;

c = 1;
prevX = -1;
prevY = -1;
x = -1;
y = -1;
while(button ~= 3)
    prevX = x;
    prevY = y;
    [x,y,button] = ginput(1); 
    
    if(mod(c, 2) == 0)
        plot([prevX, x], [prevY, y], 'LineWidth',2,'Color', 'green');
    end
    
    if(button ~= 3)
        out = [prevX prevY; x y];
        plot(x, y, 'r+');
        c = c + 1;
    end
end



i = 1;
p_op = out(i, :);
p_ip = out(i + 1, :);

[v, ind_op] = findClosestPointInProfile(op, p_op);
out(i,:) = op(ind_op, :);

[v, ind_ip] = findClosestPointInProfile(ip, p_ip);
out(i + 1,:) = ip(ind_ip, :);


d1 = sum((p_ip - ip(1,:)).^2);
dend = sum((p_ip - ip(end,:)).^2);

if(d1 < dend)
    op_out = op(ind_op:end, :);
    ip_out = ip(ind_ip:end, :);    
else
    op_out = op(1:ind_op, :);
    ip_out = ip(1:ind_ip, :);    
end

close(hf);

end