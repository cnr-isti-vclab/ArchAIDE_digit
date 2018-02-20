function varargout = mockup(varargin)
% MOCKUP MATLAB code for mockup.fig
%      MOCKUP, by itself, creates a new MOCKUP or raises the existing
%      singleton*.
%
%      H = MOCKUP returns the handle to a new MOCKUP or the handle to
%      the existing singleton*.
%
%      MOCKUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOCKUP.M with the given input arguments.
%
%      MOCKUP('Property','Value',...) creates a new MOCKUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mockup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mockup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
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

% Edit the above text to modify the response to help mockup

% Last Modified by GUIDE v2.5 14-Feb-2018 14:41:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mockup_OpeningFcn, ...
                   'gui_OutputFcn',  @mockup_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mockup is made visible.
function mockup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mockup (see VARARGIN)

% Choose default command line output for mockup
handles.output = hObject;

handles = ResetHandles(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mockup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mockup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_auto.
function button_auto_Callback(hObject, eventdata, handles)
% hObject    handle to button_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
% extract checker board
%
img_lin = (handles.img).^2.2;
[checker_length_pixels, points, img_f_wb, cb_points] = extractCheckBoard(img_lin);
handles.img = img_f_wb.^(1.0/2.2);    
%imwrite(handles.img,'wb.png');

handles.points_scale = points(1:2, :);
handles.point_wb = points(3,:);

%
% extract fragment
%
fragment_mask = extractFragment(img_f_wb, 1, cb_points);   

lines = bwmorph(fragment_mask, 'remove');
lines = bwmorph(lines, 'thin');
handles.op = extractOutsideProfilePhoto(lines, 0); 

handles.fragment_mask = fragment_mask;

%
% extract scale
%
mm_length = str2num(get(handles.edit_mm_size, 'String'));
mm_over_pixels = mm_length / checker_length_pixels;
handles.mm_over_pixels = mm_over_pixels;
disp(['mm over pixels: ', num2str(mm_over_pixels)]);    

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);

% --- Executes on button press in button_scale.
function button_scale_Callback(hObject, eventdata, handles)
% hObject    handle to button_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mm_length = str2num(get(handles.edit_mm_size, 'String'));

[mm_over_pixels, points_scale] = extractScaleFromCheckers(handles.img, mm_length);

handles.points_scale = points_scale;
handles.mm_over_pixels = mm_over_pixels;

handles.b_scale = 0;

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);

function edit_mm_size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mm_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mm_size as text
%        str2double(get(hObject,'String')) returns contents of edit_mm_size as a double


% --- Executes during object creation, after setting all properties.
function edit_mm_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mm_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function drawThings(hObject, eventdata, handles)

hold on;

axes(handles.axes1);
cla(handles.axes1);  

if(isempty(handles.fragment_mask))
    imshow(handles.img);
else
    imshow(handles.img);

    mask = handles.fragment_mask;
    mask(mask < 0.5) = 0.5;
    alpha(mask);
end

if(~isempty(handles.points_scale))
    plot(handles.points_scale(1,1), handles.points_scale(1,2), 'r+');
    plot(handles.points_scale(2,1), handles.points_scale(2,2), 'r+');
end

if(~isempty(handles.point_wb))
    plot(handles.point_wb(1), handles.point_wb(2), 'go');
end

if(~isempty(handles.connection_lines))
    n = size(handles.connection_lines, 1);
    for i=1:2:n
        line = handles.connection_lines(i:(i + 1),:);
        drawPolyLine(line, 'magenta');
    end
end

if(~isempty(handles.ip))
%    ip = DouglasPeucker(handles.ip, 1);    
    ip = lineSimplification(handles.ip, 32);    
    drawPolyLine(ip, 'red');
end

if(~isempty(handles.op))
%    op = DouglasPeucker(handles.op, 1);    
    op = lineSimplification(handles.op, 32);    
    drawPolyLine(op, 'green');
end


% --- Executes on button press in button_wb.
function button_wb_Callback(hObject, eventdata, handles)
% hObject    handle to button_wb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(~exist('handles.img', 'var'))
   
    [img_f_wb, color_wb, pos_wb] = imWhiteBalance(handles.img.^2.2, []);    
    img_f_wb = img_f_wb.^(1.0/2.2);
    handles.img = img_f_wb;
    handles.point_wb = pos_wb;
    handles.b_wb = 0;

    drawThings(hObject, eventdata, handles);
    
    guidata(hObject, handles);
end


% --- Executes on button press in button_fragment.
function button_fragment_Callback(hObject, eventdata, handles)
% hObject    handle to button_fragment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fragment_mask = extractFragment(handles.img);
    
lines = bwmorph(fragment_mask, 'remove');
lines = bwmorph(lines, 'thin');
handles.op = extractOutsideProfilePhoto(lines, 0); 

[handles.connection_lines, handles.ip, handles.op] = ConnectProfiles(handles.ip, handles.op);

handles.fragment_mask = fragment_mask;
handles.b_fragment_mask = 0;

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in button_define_inner.
function button_define_inner_Callback(hObject, eventdata, handles)
% hObject    handle to button_define_inner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

b_manual = get(handles.cb_ip_manual, 'Value');

if(~isempty(handles.op))
    pStart = handles.op(1,:);
else
    pStart = [];
end

if(~b_manual)
    ip = LiveWireInteractive(handles.img, pStart, 0);
else
    ip = LineInteractive(handles.img, pStart);    
end

handles.ip = ip;
handles.b_ip = 0;

[handles.connection_lines, handles.ip, handles.op] = ConnectProfiles(handles.ip, handles.op);

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);

% --- Executes on button press in define_outer_profile.
function define_outer_profile_Callback(hObject, eventdata, handles)
% hObject    handle to define_outer_profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

b_manual = get(handles.cb_op_manual, 'Value');

if(~isempty(handles.ip))
    pStart = handles.ip(1,:);
else
    pStart = [];
end

if(~b_manual)
    op = LiveWireInteractive(handles.img, pStart, 0);
else
    op = LineInteractive(handles.img, pStart);    
end

handles.op = op;
handles.b_op = 0;

[handles.connection_lines, handles.ip, handles.op] = ConnectProfiles(handles.ip, handles.op);

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);

% --- Executes on button press in cb_ip_manual.
function cb_ip_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ip_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ip_manual


% --- Executes on button press in cb_op_manual.
function cb_op_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_op_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_op_manual


% --- Executes on button press in cb_flip_left_right.
function cb_flip_left_right_Callback(hObject, eventdata, handles)
% hObject    handle to cb_flip_left_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.img = fliplr(handles.img);

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of cb_flip_left_right


% --- Executes on button press in button_svg.
function button_svg_Callback(hObject, eventdata, handles)
% hObject    handle to button_svg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ip = handles.ip;

op = handles.op;

nameOut = [RemoveExt(handles.full_path), '.svg'];

if(~isempty(ip))
    ip = smoothProfile(ip);
    ip = lineSimplification(ip, 32);
%    ip = DouglasPeucker(ip, 0.15);  
end

if(~isempty(op))
    op = smoothProfile(op);
    op = lineSimplification(op, 32);    
%    op = DouglasPeucker(op, 0.15);    
end

ip_mm = ip * handles.mm_over_pixels;
op_mm = op * handles.mm_over_pixels;

fractures = [];
if(~isempty(handles.connection_lines))
    handles.connection_lines_mm = handles.connection_lines * handles.mm_over_pixels;

    if(size(handles.connection_lines, 1) == 2)
        fractures{1} = handles.connection_lines_mm;
    end
    
    if(size(handles.connection_lines, 1) == 4)
        fractures{1} = handles.connection_lines_mm(1:2,:);
        fractures{2} = handles.connection_lines_mm(3:4,:);
    end

end
    
writeSVG(nameOut, ip_mm, op_mm, [], [], [], [], handles.mm_over_pixels, fractures, 0);

% --------------------------------------------------------------------
function file_tag_Callback(hObject, eventdata, handles)
% hObject    handle to file_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_tag_Callback(hObject, eventdata, handles)
% hObject    handle to open_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = ResetHandles(handles);

[FileName, PathName, ~] = uigetfile('*.*', 'Select an image file...');

if(PathName(end) ~= '/')
    full_path = [PathName, '/', FileName];
else
    full_path = [PathName, FileName];
end

img = double(imread(full_path)) / 255;

info = imfinfo(full_path);

try
    switch info.Orientation
        case 2
            img = img(:, end:-1:1, :);         %right to left
        case 3
            img = img(end:-1:1, end:-1:1, :);  %180 degree rotation
        case 4
            img = img(end:-1:1, :,:);         %bottom to top
        case 5
            img = permute(img, [2 1 3]);     %counterclockwise and upside down
        case 6
            img = rot90(img, 3);              %undo 90 degree by rotating 270
        case 7
            img = rot90(img(end:-1:1, :, :));  %undo counterclockwise and left/right
        case 8
            img = rot90(img);                %undo 270 rotation by rotating 90
        otherwise
            warning('This orientation is not known!');        
    end
catch e
    disp(e);
end

dim_max = max(size(img, 1), size(img, 2));

if(dim_max > 1600)
   scale = 1600 / dim_max;
   
   img_g = filterGaussian(img, scale);
   img = imresize(img_g, scale, 'nearest');
end

handles.img = img;

handles.full_path = full_path;

cla(handles.axes1, 'reset')

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);

function handles = ResetHandles(handles)

handles.connection_lines = [];

handles.fragment_mask = [];
handles.b_fragment_mask = 1;

handles.full_path = '';

handles.ip = [];

handles.img = [];
handles.b_wb = 1;

handles.mm_over_pixels = -1;
handles.b_scale = 1;

handles.ip = [];
handles.b_ip = 1;

handles.op = [];
handles.b_op = 1;

handles.points_scale = [];
handles.point_wb = [];


% --- Executes on button press in pb_connect_profiles.
function pb_connect_profiles_Callback(hObject, eventdata, handles)
% hObject    handle to pb_connect_profiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[~, handles.ip, handles.op] = defineCutLinesProfiles(handles.img, handles.ip, handles.op);

[handles.connection_lines, handles.ip, handles.op] = ConnectProfiles(handles.ip, handles.op);

drawThings(hObject, eventdata, handles);

guidata(hObject, handles);

