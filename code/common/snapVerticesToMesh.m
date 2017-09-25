function [vertices_out, tri_list] = SnapVerticesToMesh(vertices, nsb, mesh_pos, mesh_tri)
%
%
%       [vertices_out, tri_list] = SnapVerticesToMesh(vertices, nsb, mesh_pos, mesh_tri)
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

n = size(mesh_tri, 1);
vertices_out = vertices;

tri_list = [];

for i=1:nsb
    o = vertices(i, :);
        
    dist = zeros(size(mesh_pos));
    
    for k=1:3
        dist(:,k) = mesh_pos(:,k) - o(k);
    end    
    tmp = sqrt(sum(dist.^2, 2));

    [~, indx] = min(tmp);
    vertices_out(i,:) = mesh_pos(indx, :);
    
    [r, ~] = find(mesh_tri == (indx - 1));
    tri_list = [tri_list; r];
end

tri_list = unique(tri_list);

m = size(vertices, 1);

for i=(m - nsb + 1):m   
    o = vertices(i, :);

    dist = zeros(size(mesh_pos));
    for k=1:3
        dist(:,k) = mesh_pos(:,k) - o(k);
    end    
    tmp = sqrt(sum(dist.^2, 2));
    
    [~, indx] = min(tmp);
    vertices_out(i,:) = mesh_pos(indx, :);

    [r, ~] = find(mesh_tri == (indx - 1));
    tri_list = [tri_list; r];
end

tri_list = unique(tri_list);

%
%remove all triangles with vertices in tri_list
%
% n = length(tri_list);
% for i=1:n
%   
%     j = tri_list(i);
%     for k=1:3
%         ind_v_k = mesh_tri(j, k);
%         
%         [r, ~] = find(mesh_tri == ind_v_k);
%         tri_list = [tri_list; r];
%     end    
% end

tri_list = unique(tri_list);

end
