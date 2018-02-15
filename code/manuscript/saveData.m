function saveData(nameOut, handles)
%
%
%        saveData(nameOut, handles)
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

data = [];
data.PathName = handles.PathName;
data.file_name = handles.file_name;
data.nameOut = handles.nameOut;
data.outputFolder = handles.outputFolder;
data.inside_profile = handles.inside_profile;
data.outside_profile = handles.outside_profile;
data.handle_ip = handles.handle_ip;
data.handle_op = handles.handle_op;

if(exist('data.uncertain_profile', 'var'))
    data.uncertain_profile = handles.uncertain_profile;
else
    data.uncertain_profile = [];
end

data.handle_section = handles.handle_section;
data.axis_profile = handles.axis_profile;
data.scale_points = handles.scale_points;
data.inside_profile_mm = handles.inside_profile_mm;
data.outside_profile_mm = handles.outside_profile_mm;
data.handle_ip_mm = handles.handle_ip_mm;
data.handle_op_mm = handles.handle_op_mm;
data.axis_profile_mm = handles.axis_profile_mm;
data.dataFor3D = handles.dataFor3D;
data.bImageRescale = handles.bImageRescale;

if(exist('data.file_ext', 'var'))
    data.file_ext = handles.file_ext;
else
    data.file_ext = [];
end

save([handles.outputFolder, nameOut, '_data.mat'], 'data');

end