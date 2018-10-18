function handles = readSVG(name)
%
%
%       handles = readSVG(name)
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

handles = [];

handles. inside_profile_mm = [];
handles. outside_profile_mm = [];
handles. handle_ip_mm = [];
handles. handle_op_mm = [];
handles. handle_section_mm = [];
handles. axis_profile_mm = [];

try
    fid = fopen(name, 'r');
    
    bToken = 0;
    bPath = 0;
    
    while(~feof(fid))
       tline = fgetl(fid);
       
       if(contains(tline, '<path'))
           bToken = 1;
           current_path = [];
       end
       
       if(bToken)
           ind = strfind(tline, 'd="M ');
           if(~isempty(ind))
               tline = strrep(tline, 'd="M ', 'L');
               bPath = 1;
           end
       end
       
       if(bPath)
           tline = strrep(tline, 'L', ' ');
           data = sscanf(tline, '%f');
           
           path = [data(1:2:end) data(2:2:end)];
           
           current_path = [current_path; path];
           
           if(contains(tline, '"'))
               bPath = 0; 
           end
       end
       
       if(bToken)
           if(contains(tline, 'inner_base_profile'))
              handles.inside_profile_mm = current_path;
           end
           
           if(contains(tline, 'outer_base_profile'))
              handles.outside_profile_mm = current_path;
           end

           if(contains(tline, 'inner_handle_profile'))
              handles.handle_ip_mm = current_path;
           end

           if(contains(tline, 'outer_handle_profile'))
              handles.handle_op_mm = current_path;
           end
           
           if(contains(tline, 'handle_section'))
              handles.handle_section_mm = current_path;
           end           
           
           if(contains(tline, 'axis'))
              handles.axis_profile_mm = current_path;
           end           
           
       end
                 
       if(contains(tline, '/>'))
           bToken = 0;
       end
    end
    
    fclose(fid);

catch expr
    disp(expr);
    
end

end