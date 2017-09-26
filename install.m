%
%     HDR Toolbox Installer
%
%     Copyright (C) 2011-2013  Francesco Banterle
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
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