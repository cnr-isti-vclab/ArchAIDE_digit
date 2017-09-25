function writeSVG(name, ip, op, handle_ip, handle_op, handle_sec, axis, scale_factor, fracture_p)
%
%
%       writeSVG(name, ip, op, handle_ip, handle_op, handle_sec, axis, scale_factor, fracture_p)
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

if(isempty(ip) | isempty(op))
   return; 
end

if(~exist('fracture_p', 'var'))
    fracture_p = [];
end

fid = fopen(name, 'w');

fprintf(fid, '<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n');
fprintf(fid, '<!-- Created with MATLAB -->\n');

fprintf(fid, '<svg\n');
fprintf(fid, '   xmlns:dc="http://purl.org/dc/elements/1.1/"\n');
fprintf(fid, '   xmlns:cc="http://creativecommons.org/ns#"\n');
fprintf(fid, '   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"\n');
fprintf(fid, '   xmlns:svg="http://www.w3.org/2000/svg"\n');
fprintf(fid, '   xmlns="http://www.w3.org/2000/svg"\n');
fprintf(fid, '   version="1.1"\n');
fprintf(fid, '   width="%f mm"\n',  round(max(ip(:,1)) * 1.1));
fprintf(fid, '   height="%f mm"\n', round(max(ip(:,2)) * 1.1));
fprintf(fid, '   id="svg2">\n');
fprintf(fid, '  <defs\n');
fprintf(fid, '     id="defs4" />\n');
fprintf(fid, '  <metadata\n');
fprintf(fid, '     id="metadata7">\n');
fprintf(fid, '    <rdf:RDF>\n');
fprintf(fid, '      <cc:Work\n');
fprintf(fid, '         rdf:about="">\n');
fprintf(fid, '        <dc:format>image/svg+xml</dc:format>\n');
fprintf(fid, '        <dc:type\n');
fprintf(fid, '           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />\n');
fprintf(fid, '        <dc:title></dc:title>\n');
fprintf(fid, '      </cc:Work>\n');
fprintf(fid, '    </rdf:RDF>\n');
fprintf(fid, '  </metadata>\n');

if(~isempty(ip))
    writeLine(fid, ip, [255 0 0], 'inner_base_profile');
    writeCircle(fid, ip(1,1), ip(1,2), 5, 'rim_point');   
    
    mouth_radius = abs(ip(1,1) - axis(1,1));
    writeText(fid, 0, 24, ['mouth_radius: ', num2str(mouth_radius)]);
end

if(~isempty(op) & ~isempty(ip))
    writeLine(fid, op, [0 255 0], 'outer_base_profile');

    %check if base point is close to the axis
%    if(abs(op(end,1) - axis(1,1)) < 8)
    
    [v_op, ind_op] = max(op(:,2));
    [v_ip, ind_ip] = max(ip(:,2));
    
    if(v_op > v_ip)
        writeCircle(fid, op(ind_op,1), op(ind_op,2), 5, 'base_point');     
    else
        writeCircle(fid, ip(ind_ip,1), ip(ind_ip,2), 5, 'base_point');             
    end
%    end
end

if(~isempty(handle_ip))
    writeLine(fid, handle_ip, [0 0 255], 'inner_handle_profile');
end

if(~isempty(handle_op))
    writeLine(fid, handle_op, [255 255 0], 'outer_handle_profile');
end

if(~isempty(handle_sec))
    writeLine(fid, handle_sec, [0 255 255], 'handle_section');
end

if(~isempty(axis))
    writeLine(fid, axis, [0 0 255], 'axis');
end

if(~isempty(fracture_p))
    writeLine(fid, fracture_p, [255 0 255], 'fracture');
end

writeText(fid, 0, 48, ['ratio_mm_pixels: ', num2str(scale_factor)]);

fprintf(fid, '</svg>\n');

fclose(fid);

end

function writeText(fid, x, y, text_string)
    fprintf(fid, '<text x="%f" y="%f" font-family="Verdana" font-size="12">\n', x, y);
    fprintf(fid, '%s\n', text_string); 
    fprintf(fid, '</text>\n');
end

function writeLine(fid, profile, color, id_string)
    fprintf(fid, '  <g\n');
    fprintf(fid, '     id="layer1">\n');
    fprintf(fid, '    <path\n');
    fprintf(fid, '       d="M %f %f ', profile(1,1), profile(1,2));
    
    for i=2:size(profile, 1)
        fprintf(fid, 'L%f %f ', profile(i,1), profile(i,2));
    end
    fprintf(fid, '"\n');
     
    fprintf(fid, '       id="%s"\n', id_string);
    fprintf(fid, '       style="fill:none;stroke:#%s;stroke-width:2;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none" />\n', rgb2hex(color(1), color(2), color(3)));
    fprintf(fid, '  </g>\n');
end

function writeCircle(fid, cx, cy, radius, id_string)
    fprintf(fid, '<circle cx="%f" cy="%f" r="%f" fill="red" id="%s"/>\n', cx, cy, radius, id_string); 
end

function h = rgb2hex(r, g, b)
    h = sprintf('%.2x%.2x%.2x',r,g,b);
end