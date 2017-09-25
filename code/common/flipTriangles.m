function out = flipTriangles(tri)
%
%
%   out = flipTriangles(tri)
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

if(~isempty(tri))
    out = zeros(size(tri));
    out(:,1) = tri(:,2);
    out(:,2) = tri(:,1);
    out(:,3) = tri(:,3);
end

end