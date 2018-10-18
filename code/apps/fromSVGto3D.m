function fromSVGto3D(path, bCut)
%
%        fromSVGto3D(path, bCut)
%
%        input:
%           -path: path of the folder where files to be processed are.
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

setlib();

if(~exist('bCut', 'var'))
   bCut = 1; 
end

if(path(end) == '/')
   path = path(1:(end - 1)); 
end

lst = dir([path, '/*.svg']);

path_out = [path, '_3D'];

if(exist(path_out, 'dir') ~= 7)
   mkdir(path_out); 
end
        
for i=1:length(lst)
    
    name = RemoveExt(lst(i).name);
    nameIn = [path, '/', lst(i).name];
    
    handles = readSVG(nameIn);
    
    try
        handles.dataFor3D = 1;
        handles.outputFolder = path_out;
        handles.nameOut = [name, '.ply'];
        
        create3DModels(handles, bCut);
    catch expr
        disp(expr);
    end
end

end