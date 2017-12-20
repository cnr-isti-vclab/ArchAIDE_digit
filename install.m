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
%

disp('Installing the ArchAIDE Digit Tools...');

folder = cellstr('apps');
folder = [folder, cellstr('common')];
folder = [folder, cellstr('manuscript')];


for i=1:length(folder)
    addpath([pwd(), '/code/', char(folder(i))], '-begin');
end

savepath

disp('done');