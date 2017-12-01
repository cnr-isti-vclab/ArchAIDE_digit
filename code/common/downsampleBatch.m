function downsampleBatch(format)
%
%
%      downsampleBatch(format)
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

lst = dir(['*.', format]);

for i=1:length(lst)
    disp(lst(i).name);
    img = double(imread(lst(i).name)) / 255.0;
    imgOut = downsampleHighRes(img);
    
    name = RemoveExt(lst(i).name);
    imwrite(imgOut, [name, '_downsampled.', format]);
end

end