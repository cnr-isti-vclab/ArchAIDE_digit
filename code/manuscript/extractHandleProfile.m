function [handle_op, handle_ip] = extractHandleProfile(lines, op, ip, op_mouth, op_handle, axis)
%
%
%        [handle_op, handle_ip] = extractHandleProfile(lines, op, ip, op_mouth, op_handle, axis)
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

handle_ip = [];
handle_op = [];

bDebug = 0;

lines = cleanLines(lines, op(2:(end - 1), :), 0);
lines = cleanLines(lines, ip(2:(end - 1), :), 0);
%lines = cleanLines(lines, op(2:(end - 1), :), 0, axis);
%lines = cleanLines(lines, ip(2:(end - 1), :), 0, axis);


if(~isempty(op_mouth) & ~isempty(op_handle))

    handle_op = lineCrawlerGen(lines, op_mouth(end,1), op_mouth(end,2));
    
    handle_ip = lineCrawlerGen(lines, op_handle(1,1),  op_handle(1,2));
end

if(bDebug)
  figure(55)
  imshow(lines);
  hold on;
            
  drawPolyLine(op, 'red');
  drawPolyLine(handle_ip, 'blue');
  drawPolyLine(handle_op, 'yellow');   
end

end