function handles = extractDigit( handles )
%
%
%        handles = extractDigit( handles )
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

 [inside_profile, outside_profile, handle_ip, handle_op, axis_profile] = extractProfiles(handles.img, 0);
 
 handle_section = [];
 
 if(~isempty(handle_ip) & ~isempty(handle_op))
    handle_section =  extractHandleSection(handles.img, 0);
 end
 
 [scale_points, ratio_mm_pixels] = extractScale(handles.img, inside_profile, outside_profile);
 
 handles.inside_profile = inside_profile;
 handles.outside_profile = outside_profile;
 handles.handle_ip = handle_ip;
 handles.handle_op = handle_op;
 handles.ratio_mm_pixels = ratio_mm_pixels;
 handles.handle_section = handle_section;
 
 handles.axis_profile = axis_profile;
 handles.scale_points = scale_points;

end

