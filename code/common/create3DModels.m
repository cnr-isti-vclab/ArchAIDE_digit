function create3DModels(handles, bCut)
%
%
%       create3DModels(handles)
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

if(handles.dataFor3D) 
    outputFolder = [handles.outputFolder, '/'];
    
    nameOut = handles.nameOut;
    [pIP, tIP] = revolve3DProfile(handles.inside_profile_mm, handles.axis_profile_mm(1,1), 60, 1);
    
    [pOP, tOP] = revolve3DProfile(handles.outside_profile_mm, handles.axis_profile_mm(1,1), 60, 0);
                
    [pH, tH, nsb ] = twoRailSweep(handles.handle_op_mm, handles.handle_ip_mm, handles.handle_section_mm, 0);
        
    
    %flip
    originFlip = max([pIP(:,2); pOP(:,2)]);
    pIP(:,2) = originFlip - pIP(:,2);
    pOP(:,2) = originFlip - pOP(:,2);    

    %center
    originCenter = min([pIP(:,2); pOP(:,2)]);
    pIP(:,2) = pIP(:,2) - originCenter;
    pOP(:,2) = pOP(:,2) - originCenter;

    %green --> outside
    cOP = zeros(size(pOP, 1), 3);
    cOP(:,2) = 255;
    
    %red --> inside
    n = size(pIP, 1);
    cIP = zeros(n, 3);
    cIP(:,1) = 255;        
    
    %set new origin
    minY = min([pIP(:,2); pOP(:,2)]);
    ori = [handles.axis_profile_mm(1,1), minY , handles.axis_profile_mm(1,1)];
    pIP = setNewOrigin(pIP, ori);
    pOP = setNewOrigin(pOP, ori);
        
    if(~isempty(pH))
        pH(:,2) = originFlip - pH(:,2);
        pH(:,2) = pH(:,2) - originCenter;
        pH(:,1) = pH(:,1) + handles.axis_profile_mm(1,1);
               
        %blue --> hanlde
        cH = zeros(size(pH, 1), 3);
        cH(:,3) = 255;    
        
        %handle 1
        pH = setNewOrigin(pH, ori);                
        [pH1, tri1] = snapVerticesToMesh(pH, nsb, pOP, tOP);
        writeMeshPLY(pH1, tH, cH, [outputFolder, nameOut, '_handle_1.ply']);
        
        %handle 2
        pH = flipGeometryAxis(pH, 3, 0);
        tH = flipTriangles(tH);
        [pH2, tri2] = snapVerticesToMesh(pH, nsb, pOP, tOP);        
        writeMeshPLY(pH2, tH, cH, [outputFolder, nameOut, '_handle_2.ply']);
                    
        if(bCut)
            tOP = skipTriangles(tOP, [tri1; tri2]);            
        end
    end
    
    
    writeMeshPLY([pIP; pOP], [tIP; tOP + n], [cIP; cOP], [outputFolder, nameOut, '_base.ply']);
end

end

