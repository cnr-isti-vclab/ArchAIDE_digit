function img_bw = imPreprocessingClean( img, iterations )
%
%
%       img_bw = imPreprocessingClean( img, iterations )
%
%
%       This function preprocess
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

if(~exist('iterations', 'var'))
    iterations = 4;
end

nh = strel('disk', 1);
 
for i=1:iterations
    img = imdilate(img, nh);
end

for i=1:iterations
    img = imerode(img, nh);
end

img_bw = img;

end

