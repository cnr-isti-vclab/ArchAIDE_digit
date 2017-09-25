function out = EPX(img)
%
%
%       out = EPX(img)
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

[r,c] = size(img);

out = imresize(img, 2, 'nearest');

for i=2:(c - 1)

    i2 = i * 2;
    
    for j=2:(r - 1)
        j2 = j * 2;
        
        P = img(j, i);
        A = img(j - 1, i);
        B = img(j, i + 1);
        C = img(j, i - 1);
        D = img(j + 1, i);
        
        out(j2, i2) = P;
        out(j2 + 1, i2) = P;
        out(j2, i2 + 1) = P;
        out(j2 + 1,  i2 + 1) = P;        
        
        if(C == A & C ~= D & A ~= B)
            out(j2, i2) = A;
        end

        if(A == B & A ~= C & B ~= D)
            out(j2, i2 + 1) = B;
        end
        
        if(D == C & D ~= B & C ~= A)
            out(j2 + 1, i2) = C;
        end
        
        if(B == D & B ~= A & D ~= C)
            out(j2 + 1,  i2 + 1) = D;
        end

    end
end

end