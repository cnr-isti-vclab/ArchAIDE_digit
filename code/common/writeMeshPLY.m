function writeMeshPLY(points, tri, color, name)
%
%
%       writeMeshPLY(points, tri, color, name)
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
    fid = fopen(name, 'wt');
    
    size_points = size(points, 1);
    
    
    if(~isempty(color))
        bColor = 1;
        bCV = size(color, 1) == 1;
    else
        bColor = 0;
    end
    
%     bColor = ~isempty(colors);
    
    fprintf(fid, 'ply \n');
    fprintf(fid, 'format ascii 1.0 \n');
    fprintf(fid, 'element vertex %d \n' , size_points);
    fprintf(fid, 'property float x \n');
    fprintf(fid, 'property float y \n');
    fprintf(fid, 'property float z \n');
    
    if(bColor)
        fprintf(fid, 'property uchar red \n');
        fprintf(fid, 'property uchar green \n');
        fprintf(fid, 'property uchar blue \n');
        fprintf(fid, 'property uchar alpha \n');
    end    
    
    if(~isempty(tri))
        fprintf(fid, 'element face %d\n', size(tri, 1));
        fprintf(fid, 'property list uchar int vertex_indices\n');
    end
    

    
    fprintf(fid, 'end_header \n');
    
%     if(isa(colors, 'double'))
%         colors = round(colors * 255);
%     end
    
    for i=1:size_points
          fprintf(fid, '%.3f %.3f %.3f' , points(i,1), points(i,2), points(i,3)); 
   
        if(bColor)
            if(bCV)
                fprintf(fid, ' %d %d %d 255' , color(1), color(2), color(3)); 
            else
                fprintf(fid, ' %d %d %d 255' , color(i,1), color(i,2), color(i,3)); 
            end
        end
        
        fprintf(fid, '\n');
    end
    
    for i=1:size(tri, 1)
          fprintf(fid, '3 %d %d %d\n' , tri(i,1), tri(i,2), tri(i,3));         
    end
    
    fclose(fid);
    
end