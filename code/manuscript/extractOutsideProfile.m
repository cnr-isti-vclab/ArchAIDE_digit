function [op, ip, op_mouth, op_base, op_handle, bBrokenLoop] = extractOutsideProfile(lines, ip, y_axis, x_cut, y_cut, bMPC, bHandles)
%
%
%        [op, ip, op_mouth, op_base, op_handle, bBrokenLoop] = extractOutsideProfile(lines, ip, x_cut, y_cut, bMPC)
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

disp('extractOutsideProfile');

op = [];
op_mouth = [];
op_base = [];
op_handle = [];
bBrokenLoop = 0;
bDebug = 0;

lines2 = cleanLines(lines, ip);

if(bDebug)
    imwrite(lines2, 'lines2.png');
end

if(x_cut < 1 | y_cut < 1)
    disp('Warning -- extractOutsideProfile');
else
    r = size(lines, 1);

    n = size(ip, 1);

    x_hit_old = -1;
    
    for i=1:n
        x = ip(i,1);
        y = ip(i,2);

        r_h = round(r / 2);
        if(y < r_h)
            [num_changes, x_hit, ~] = getChanges(lines, x, y);
            if(num_changes > 2)
                op_handle = [op_handle; x_hit, y];           
            end
        else
            break;
        end
    end 
    
   

    %check for loops
    bLoop = 0;
    tmp_lines2 = cleanLines(lines, ip, 0);
    
    for i=1:size(op_handle, 1)
        p = op_handle(i, :);
        
        op_tmp = lineCrawlerGen(tmp_lines2, p(1), p(2), max(size(lines)));
        
        if(~isempty(op_tmp))
            ps = op_tmp(1, :);
            pe = op_tmp(end, :);
            dse = sqrt(sum((ps - pe).^2));

            if(dse < sqrt(2)) %is it a loop?           
                [~, indx] = max(op_tmp(:,2));          
                op_handle = op_tmp(1:indx, :);
                bLoop = 1;
                break;
            end
        end

    end    
        
    if(~bLoop)
        if(~isempty(op_handle)) %broken loop case
            
            %op_handle may have gaps so it needs fixing
            op_handle = reFollow(lines2, op_handle );
            
            %refinement
            if(~isempty(op_handle))
                y_cut_ext = op_handle(end, 2);

                [~, ~, x_cut_ext] = getChanges(lines, op_handle(end, 1), op_handle(end, 2));

                if(x_cut_ext > 0)
                    op_base = lineCrawler(lines2, x_cut_ext, y_cut_ext, pi * 3/2 );
                end

                [op_base, op_handle] = refineProfiles(ip, op_base, op_handle);

                bBrokenLoop = 1;
            end            
        else
            op_handle = [];
        end        
    end
    
    %
    %
    % external profile cut
    %
    %
    
    if(~isempty(op_handle) & bHandles)
        %compute mouth
        op_mouth = lineCrawler(lines2, x_cut, y_cut, pi, min(op_handle(:,2)) - 1);
                
        %compute base
        y_cut_ext = op_handle(end, 2);
       
        [~, ~, x_cut_ext] = getChanges(lines2, op_handle(end, 1), op_handle(end, 2));
        
        if(x_cut_ext > 0)
            op_base = lineCrawler(lines2, x_cut_ext, y_cut_ext, pi * 3/2 );
        end
                        
        if(bDebug)
           figure(1);
           imshow(lines);
           hold on;
           drawPolyLine(op_mouth, 'red');
           drawPolyLine(op_base, 'green');
           drawPolyLine(op_handle, 'blue');
           hold off;
        end
        
        if(~bMPC)
             [op_base, op_handle] = refineProfiles(ip, op_base, op_handle);
        else            
            hf = figure(1024);
            imshow(1 - imdilate(lines, ones(5)));
            hold on;
            drawPolyLine(op_base, 'red');
            
            b1 = 1;
            index_old = -1;
            while(b1 == 1)
                [x, y, b1] = ginput(1);
                [~, index] = findClosestPointInProfile(op_base, [x y]);
                
                plot(op_base(index,1), op_base(index,2), 'g+');

                index_old = index;
            end
            
            if(index_old > 0)
                op_base = op_base(index:end, :);
            end
            
            hold off;
            close(hf);
        end
      
        if(~bBrokenLoop)
            if(~bMPC)
                 [op_handle, op_mouth] = refineProfiles(ip, op_handle, op_mouth);
            else
                hf = figure(2048);
                imshow(1 - imdilate(lines, ones(5)));
                hold on;
                drawPolyLine(op_handle, 'red');
                drawPolyLine(op_mouth, 'green');

                b1 = 1;
                index_old = -1;
                while(b1 == 1)
                    [x, y, b1] = ginput(1);
                    [~, index] = findClosestPointInProfile(op_handle, [x y]);

                    plot(op_handle(index,1), op_handle(index,2), 'g+');

                    index_old = index;
                end

                if(index_old > 0)
                    op_handle = op_handle(index:end, :);
                end

                b1 = 1;
                index_old = -1;
                while(b1 == 1)
                    [x, y, b1] = ginput(1);
                    [~, index] = findClosestPointInProfile(op_mouth, [x y]);

                    plot(op_mouth(index,1), op_mouth(index,2), 'r+');

                    index_old = index;
                end

                if(index_old > 0)
                    op_mouth = op_mouth(1:index, :);
                end            

                hold off;
                close(hf);            
            end
        end
%         if(abs(op_handle(1,2) - op_mouth(end,2)) < 4)   
%             op_mouth  = skipPointsUntilSmoothUp( op_mouth, op_handle(1,1), op_handle(1,2) );
%         end
% 
%         if(abs(op_handle(1,1) - op_mouth(end,1)) > 4)        
%          op_handle  = skipPointsUntilSmooth( op_handle, op_mouth(end,1), op_mouth(end,2), 2);
%         end
% 
        if(~isempty(op_mouth) & ~isempty(op_handle) & ~isempty(op_base))
            x = [op_mouth(:,1); op_handle(:,1); op_base(:,1)];
            y = [op_mouth(:,2); op_handle(:,2); op_base(:,2)];        
            op = [x, y];
        else
            op = [];
        end
    end
    
    if(isempty(op)) %no handle case
        tmp_lines2 = cleanLines(lines2, ip, 0);
        op = lineCrawlerGen(tmp_lines2, x_cut, y_cut, size(lines2,1));
    end
    
    [ip, op] = rimPointAdjustment(ip, op);         
end

%
%
%refine inside profile
%
%
if(~isempty(op) & ~isempty(ip))

    x_cut = ip(1,1);
    y_cut = ip(1,2);

    ip = lineCrawlerGen(cleanLines(lines, op, 0), x_cut, y_cut);
    ip = [op(1,:) ;ip];

    %snap to the axis
    px = ip(end, 1);

    if(abs(px - y_axis) < 4)
        ip(end, 1) = y_axis;
    end

    px = op(end, 1);

    if(abs(px - y_axis) < 4)
        op(end, 1) = y_axis;
    end
end

disp('extractOutsideProfile end');


end