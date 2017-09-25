function lines = cleanLines(lines, profile, clean_value )
%
%
%           lines = cleanLines(lines, profile, clean_value )
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

if(~exist('clean_value', 'var'))
    clean_value = 0;
end

n = size(profile, 1);

for i=1:n    
    lines(profile(i,2), profile(i,1)) = clean_value;
end


end

