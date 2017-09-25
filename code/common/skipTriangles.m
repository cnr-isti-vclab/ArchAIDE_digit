function out = skipTriangles(tri_list, tri_to_be_skipped)
%
%
%       out = skipTriangles(tri_list, tri_to_be_skipped)
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

n = size(tri_list, 1);
for i=1:n
    if(isempty(find(tri_to_be_skipped == i)))
        out = [out; tri_list(i,:)];
    end
end

end