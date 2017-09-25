function digitBatch(PathName, format, ratio_mm_pixels, bImageRescale, bHandles, bCreate3D)
%
%        digitBatch(PathName, format, ratio_mm_pixels, bImageRescale, bHandles, bCreate3D)
%
%        input:
%               -PathName: path of the folder where files to be processed
%               are.
%               -format: format of input files.
%               -ratio_mm_pixels: is the ratio mm over pixels. If it is
%               set to a value below 0.0, the program will extract the
%               scale automatically using TesseractOCR.
%               -bImageRescale: is a boolean flag. If true (i.e., 1), the program
%                will rescale input images to maintain tested thresholds.
%               Otherwise, (i.e., 0) threhsolds will be updated.
%               -bHandles: is a boolean flag. If true (i.e., 1), the
%               program will extract handles in drawings. Otherwise, it
%               will not.
%               -bCreate3D: is a boolean flag. If true (i.e., 1), the
%               program will compute a 3D model of the drawing. Otherwise, 
%               it will not.
%
%        c  ---->   ratio_mm_pixels = 330 / 1730
%                   bImageRescale = 0
%                   bHandles = 0;  
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
lst = dir([PathName, '/*.', format]);

bFlip = 0;
bAxis = 0;
bMPC = 0;
bCut = 1;
cleaningIterations = 4;

if(exist('output', 'dir') ~= 7)
   mkdir('output'); 
end

outputFolder = [PathName(1:(end - 1)), '_output/'];
        
for i=1:length(lst)
    
    try        
        handles = [];

        FileName = lst(i).name;
        disp(FileName);
        full_path = [PathName, '/', lst(i).name];

        %name = RemoveExt(FileName);
        %outputFolder = [PathName, '_output/', name];
        %mkdir(outputFolder);  
  
        img_tmp = double(imread(full_path)) / 255;
        [img_tmp, bS] = imRescaleBinary(img_tmp, bImageRescale);
        
        handles.bS = bS;
        handles.img = img_tmp;

        %
        %pixels
        %
        handles.file_name = FileName;
        handles.outputFolder = outputFolder;
        handles.inside_profile = [];
        handles.outside_profile = [];
        handles.handle_ip = [];
        handles.handle_op = [];
        handles.handle_section = [];
        handles.axis_profile = [];
        handles.scale_points = [];
        handles.handle_section = [];
        
        %
        %mm
        %
        handles.inside_profile_mm = [];
        handles.outside_profile_mm = [];
        handles.handle_ip_mm = [];
        handles.handle_op_mm = [];
        handles.handle_section_mm = []; 
        handles.axis_profile_mm = [];

        handles.PathName = PathName;
        handles.dataFor3D = 0;    

        %
        %extract profiles
        %
         disp('Exctraction of profiles');
         tic

         [inside_profile, outside_profile, handle_ip, handle_op, axis_profile, labels] = ... 
             extractProfiles(handles.img, bMPC, bFlip, bAxis, bHandles, 0, cleaningIterations);

         handles.labels = labels;
         toc


         if(ratio_mm_pixels < 0.0)

             disp('Exctraction of scale');
             tic     
             [scale_points, ratio_mm_pixels] = ...
                 extractScale(handles.img, inside_profile, outside_profile, handles.bS);
             toc
         else
             scale_points = [];
         end

         %
         %extract the handle section if it exists
         %
         handle_section = [];

         if(~isempty(handle_ip) & ~isempty(handle_op))

             disp('Exctraction of handle section');

             tic

            value = 1;
            if(value > 0.5)
                handle_section = extractHandleSection(handles.labels, 0);
            else
                handle_section = [];
            end

            toc
         end 

         %
         %into mm
         %
         inside_profile_mm = inside_profile * ratio_mm_pixels;
         outside_profile_mm = outside_profile * ratio_mm_pixels;
         handle_ip_mm = handle_ip * ratio_mm_pixels;
         handle_op_mm = handle_op * ratio_mm_pixels;
         handle_section_mm = handle_section * ratio_mm_pixels;
         axis_profile_mm = axis_profile * ratio_mm_pixels;

         nameOut = RemoveExt(handles.file_name);

         handles.nameOut = nameOut;

         %
         %export profiles into an SVG file
         %
         name_svg = [outputFolder, nameOut, '.svg'];
         writeSVG(name_svg, inside_profile_mm, outside_profile_mm, handle_ip_mm, handle_op_mm, handle_section_mm, axis_profile_mm, ratio_mm_pixels);

         handles.inside_profile_mm = inside_profile_mm;
         handles.outside_profile_mm = outside_profile_mm;
         handles.handle_ip_mm = handle_ip_mm;
         handles.handle_op_mm = handle_op_mm;
         handles.handle_section_mm = handle_section_mm; 
         handles.axis_profile_mm = axis_profile_mm;

         handles.dataFor3D = 1;
         handles.inside_profile = inside_profile;
         handles.outside_profile = outside_profile;
         handles.handle_ip = handle_ip;
         handles.handle_op = handle_op;
         handles.handle_section = handle_section;
         handles.axis_profile = axis_profile;
         handles.scale_points = scale_points;    
         
         save([outputFolder, nameOut, '_data.mat'], 'handles');
         
         %
         %create a 3D model and export it into a PLY file
         %
         if(bCreate3D & handles.dataFor3D)    
             disp('Create 3D Model');
             tic
             create3DModels(handles, bCut);
             toc
         end
     
    catch expr
        disp(expr);
    end
end

end