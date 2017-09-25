function out = ReFollow(lines, profile )
%
%
%        out = ReFollow(lines, profile )
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

if(~isempty(profile) & (size(profile, 1) > 2))

    lines(profile(1,2), profile(1,1)) = 0;
    lines(profile(end,2), profile(end,1)) = 0;

    out = lineCrawlerGen(lines, profile(2,1), profile(2,2));           
    out = [profile(1,:); out; profile(end,:)];
else
    out = [];
end

end

