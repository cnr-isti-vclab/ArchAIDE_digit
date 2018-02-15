function varargout = digit(varargin)
% DIGIT MATLAB code for digit.fig
%      DIGIT, by itself, creates a new DIGIT or raises the existing
%      singleton*.
%
%      H = DIGIT returns the handle to a new DIGIT or the handle to
%      the existing singleton*.
%
%      DIGIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGIT.M with the given input arguments.
%
%      DIGIT('Property','Value',...) creates a new DIGIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before digit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to digit_OpeningFcn via varargin.
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


% Edit the above text to modify the response to help digit

% Last Modified by GUIDE v2.5 05-Dec-2017 16:18:22

setlib;
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @digit_OpeningFcn, ...
                   'gui_OutputFcn',  @digit_OutputFcn, ...
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

% --- Executes just before digit is made visible.
function digit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to digit (see VARARGIN)

% Choose default command line output for digit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using digit.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes digit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = digit_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in button_compute.
function button_compute_Callback(hObject, eventdata, handles)
% hObject    handle to button_compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(~isempty(handles.img))
    
% axes(handles.axes2); 

 bProfiles = get(handles.checkExtractProfiles, 'Value');
 
 if(bProfiles)
     bMPC = get(handles.checkManualProfileCut, 'Value');
     
     bFlip = get(handles.checkAutoFlip, 'Value');

     bAxis = get(handles.cbSetAxis, 'Value');
     
     bHandles = get(handles.cbExtractHandles, 'Value');

     bFracture = get(handles.labelFracture, 'Value');
     
     cleaningIterations = str2num(get(handles.editCleaningIterations, 'String'));

     bLid = get(handles.checkboxLid, 'Value');
     
     disp('Exctraction of profiles');
     tic          
     [inside_profile, outside_profile, handle_ip, handle_op, axis_profile, labels, uncertain_profile] = ... 
         extractProfiles(handles.img, bMPC, bFlip, bAxis, bHandles, bFracture, cleaningIterations, 0, bLid);
     handles.labels = labels;
     toc

     inside_profile = lineSimplification(inside_profile, 0.1);
     outside_profile = lineSimplification(outside_profile, 0.1);
     handle_ip = lineSimplification(handle_ip, 0.1);
     handle_op = lineSimplification(handle_op, 0.1);
          
     disp('Exctraction of scale');
     scale_points = [];
     
     %Conspectus:ratio_mm_pixels = 330 / 1730;
     ratio_mm_pixels = str2double(get(handles.editMMperPixel, 'String'));
     
     if(ratio_mm_pixels <= 1e-6)                       
         bSetScale = get(handles.setScale, 'Value');

         if(~bSetScale)        
             tic
             [scale_points, ratio_mm_pixels] = ...
                 extractScale(handles.img, inside_profile, outside_profile, handles.bS);
             toc
         else             
             scaleValue_in_cm = str2num(get(handles.scaleValue, 'String'));
             [scale_points, ratio_mm_pixels] = ...
                 extractScaleUI(handles.img, scaleValue_in_cm);                          
             disp(['Ratio mm/pixels:', num2str(ratio_mm_pixels)]);

         end
     else
         if(handles.bImageRescale)
             ratio_mm_pixels = ratio_mm_pixels / handles.factor_scale;
             disp(['Ratio mm/pixels:', num2str(ratio_mm_pixels)]);
         end
     end
            
     handle_section = [];

     %if(~isempty(handle_ip) | ~isempty(handle_op))

     bHandleSection = get(handles.checkExtractHandleSection, 'Value');
     if(bHandleSection)
         disp('Exctraction of handle section');
        
         tic
         handle_section = extractHandleSection(handles.labels, 0);
         toc

         handle_section = lineSimplification(handle_section, 0.5);
     else         
         handle_section = [];       
     end

     inside_profile_mm = inside_profile * ratio_mm_pixels;
     uncertain_profile_mm = [];
     for i=1:length(uncertain_profile)
         tmp = uncertain_profile{i};
         uncertain_profile_mm{i} = tmp * ratio_mm_pixels;
     end
     
     outside_profile_mm = outside_profile * ratio_mm_pixels;
     handle_ip_mm = handle_ip * ratio_mm_pixels;
     handle_op_mm = handle_op * ratio_mm_pixels;
     handle_section_mm = handle_section * ratio_mm_pixels;
     axis_profile_mm = axis_profile * ratio_mm_pixels;

     nameOut = RemoveExt(handles.file_name);

     handles.nameOut = nameOut;

     %export as SVG
     outputFolder = [handles.outputFolder, '/'];
     
     if(get(handles.checkBoxDontExportRAxis, 'Value'))
         axis_profile_mm = [];
     end         
         
     writeSVG([outputFolder, nameOut, '.svg'], ...
                inside_profile_mm, outside_profile_mm, ...
                handle_ip_mm, handle_op_mm, handle_section_mm, ...
                axis_profile_mm, ratio_mm_pixels, uncertain_profile_mm);
  
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
     handles.uncertain_profile = uncertain_profile;
     handles.handle_section = handle_section;
     handles.axis_profile = axis_profile;
     handles.scale_points = scale_points;     
 end
 
 %create 3D and export as PLY
 bE3D = get(handles.checkboxExport3D, 'Value');
 if(bE3D & handles.dataFor3D)     
     bCut = get(handles.checkCutBody, 'Value');
     tic
     create3DModels(handles, bCut);
     toc
 end

 saveData(nameOut, handles);

 drawThings(hObject, eventdata, handles);
end

 guidata(hObject, handles);

% --- Executes on button press in show_background.
function show_background_Callback(hObject, eventdata, handles)
% hObject    handle to show_background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_background
drawThings(hObject, eventdata, handles);

% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_menu_open_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName, ~] = uigetfile('*.*', 'Select a pottery file...');
handles = InitImage(PathName, FileName, handles);

drawThings(hObject, eventdata, handles);

handles.lst = dir([handles.PathName, '*.', handles.file_ext]);
handles.folder_flag = 0;
guidata(hObject, handles);
set(handles.show_background, 'Value', 1.0);


function drawThings(hObject, eventdata, handles)

value = get(handles.show_background, 'Value');

hold on;

axes(handles.axes2);
cla(handles.axes2);    
    
if(value)    
    imshow(handles.img);
else    
    imshow(zeros(size(handles.img)));
end

drawProfiles(handles.inside_profile, handles.outside_profile );
drawProfiles(handles.handle_ip, handles.handle_op );
drawAxis(handles.axis_profile);
drawAxis(handles.scale_points);
drawPolyLine(handles.handle_section, 'red');

for i=1:length(handles.uncertain_profile)
    drawPolyLine(handles.uncertain_profile{i}, 'magenta');
end

set(handles.show_background, 'Value', value);


% --- Executes on button press in checkboxExport3D.
function checkboxExport3D_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxExport3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxExport3D


% --- Executes on button press in checkExtractHandleSection.
function checkExtractHandleSection_Callback(hObject, eventdata, handles)
% hObject    handle to checkExtractHandleSection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkExtractHandleSection

% --- Executes on button press in checkExtractProfiles.
function checkExtractProfiles_Callback(hObject, eventdata, handles)
% hObject    handle to checkExtractProfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkExtractProfiles


% --- Executes on button press in checkManualProfileCut.
function checkManualProfileCut_Callback(hObject, eventdata, handles)
% hObject    handle to checkManualProfileCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkManualProfileCut


% --- Executes on button press in checkAutoFlip.
function checkAutoFlip_Callback(hObject, eventdata, handles)
% hObject    handle to checkAutoFlip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkAutoFlip


% --- Executes on button press in checkCutBody.
function checkCutBody_Callback(hObject, eventdata, handles)
% hObject    handle to checkCutBody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkCutBody


% --- Executes on button press in cbSetAxis.
function cbSetAxis_Callback(hObject, eventdata, handles)
% hObject    handle to cbSetAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSetAxis


% --- Executes on button press in cbExtractHandles.
function cbExtractHandles_Callback(hObject, eventdata, handles)
% hObject    handle to cbExtractHandles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbExtractHandles


% --- Executes on button press in labelFracture.
function labelFracture_Callback(hObject, eventdata, handles)
% hObject    handle to labelFracture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of labelFracture



function editMMperPixel_Callback(hObject, eventdata, handles)
% hObject    handle to editMMperPixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMMperPixel as text
%        str2double(get(hObject,'String')) returns contents of editMMperPixel as a double


% --- Executes during object creation, after setting all properties.
function editMMperPixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMMperPixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkResampleImage.
function checkResampleImage_Callback(hObject, eventdata, handles)
% hObject    handle to checkResampleImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkResampleImage


% --- Executes on button press in pbNextInFolder.
function pbNextInFolder_Callback(hObject, eventdata, handles)
% hObject    handle to pbNextInFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.folder_flag)
    n = length(handles.lst);
    handles.counter = handles.counter + 1;
    if(handles.counter <= n)
        handles = InitImage(handles.PathName, handles.lst(handles.counter).name, handles);        
        drawThings(hObject, eventdata, handles);
       
        guidata(hObject, handles);
        set(handles.show_background, 'Value', 1.0);    
    end
else
    j = -1;
    n = length(handles.lst);

    for i=1:n
        if(strcmp(handles.file_name, handles.lst(i).name) == 1)
            j = i + 1; 
            break;
        end
    end

    if(j > 0 & j < n)
        handles = InitImage(handles.PathName, handles.lst(j + 1).name, handles);
        guidata(hObject, handles);
        set(handles.show_background, 'Value', 1.0);    
    end
end


function handles = InitImage(PathName, FileName, handles)

nameOut = RemoveExt(FileName);

if(PathName(end) == '/')
    shift = 1;
else
    shift = 0;    
end

name_data = [PathName(1:(end - shift)), '_output/', nameOut, '_data.mat'];

if(exist(name_data, 'file'))
    tmp = load(name_data);
    handles.PathName = tmp.data.PathName;
    handles.file_name = tmp.data.file_name;
    handles.nameOut = tmp.data.nameOut;
    handles.outputFolder = tmp.data.outputFolder;
    handles.inside_profile = tmp.data.inside_profile;
    handles.outside_profile = tmp.data.outside_profile;
    handles.handle_ip = tmp.data.handle_ip;
    handles.handle_op = tmp.data.handle_op;
    handles.uncertain_profile = tmp.data.uncertain_profile;
    handles.handle_section = tmp.data.handle_section;
    handles.axis_profile = tmp.data.axis_profile;
    handles.scale_points = tmp.data.scale_points;
    handles.inside_profile_mm = tmp.data.inside_profile_mm;
    handles.outside_profile_mm = tmp.data.outside_profile_mm;
    handles.handle_ip_mm = tmp.data.handle_ip_mm;
    handles.handle_op_mm = tmp.data.handle_op_mm;
    handles.axis_profile_mm = tmp.data.axis_profile_mm;
    handles.dataFor3D = tmp.data.dataFor3D;
    handles.file_ext = tmp.data.file_ext;
    handles.bImageRescale = tmp.data.bImageRescale;
    %handles.bImageRescale = handles.bImageRescale;
else
    handles.bImageRescale = get(handles.checkResampleImage, 'Value');

    if(PathName(end) == '/')
        shift = 1;
    else
        shift = 0;
    end
    outputFolder = [PathName(1:(end - shift)), '_output/'];
    
    if(exist(outputFolder, 'dir') ~= 7)
        mkdir(outputFolder); 
    else
        exist(outputFolder, 'dir')
    end

    %paths
    handles.PathName = PathName;
    handles.file_name = FileName;
    handles.outputFolder = outputFolder;
    handles.file_ext = getExt(FileName);
    %pixels
    handles.inside_profile = [];
    handles.outside_profile = [];
    handles.handle_ip = [];
    handles.handle_op = [];
    handles.uncertain_profile = [];
    handles.handle_section = [];
    handles.axis_profile = [];
    handles.scale_points = [];
    handles.handle_section = [];
    %mm
    handles.inside_profile_mm = [];
    handles.outside_profile_mm = [];
    handles.handle_ip_mm = [];
    handles.handle_op_mm = [];
    handles.handle_section_mm = []; 
    handles.axis_profile_mm = [];
    handles.dataFor3D = 0;
end

if(PathName(end) ~= '/')
    full_path = [PathName, '/', FileName];
else
    full_path = [PathName, FileName];
end
img_tmp = double(imread(full_path)) / 255;

[img_tmp, bS, factor_scale]  = imRescaleBinary(img_tmp, handles.bImageRescale);

handles.factor_scale = factor_scale;
handles.img = img_tmp;
handles.bS = bS;
cla(handles.axes2, 'reset')
axes(handles.axes2);
imshow(handles.img);

% --------------------------------------------------------------------
function file_menu_open_folder_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu_open_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName,~] = uigetfile('*.*', 'Select a pottery file...');

file_ext = getExt(FileName);

handles.lst = dir([PathName, '*.', file_ext]);


handles = InitImage(PathName, handles.lst(1).name, handles);

handles.counter = 1;
handles.folder_flag = 1;
guidata(hObject, handles);
set(handles.show_background, 'Value', 1.0);

drawThings(hObject, eventdata, handles);

function editCleaningIterations_Callback(hObject, eventdata, handles)
% hObject    handle to editCleaningIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCleaningIterations as text
%        str2double(get(hObject,'String')) returns contents of editCleaningIterations as a double


% --- Executes during object creation, after setting all properties.
function editCleaningIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCleaningIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkBoxDontExportRAxis.
function checkBoxDontExportRAxis_Callback(hObject, eventdata, handles)
% hObject    handle to checkBoxDontExportRAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkBoxDontExportRAxis


% --- Executes on button press in checkboxLid.
function checkboxLid_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLid


% --- Executes on button press in setScale.
function setScale_Callback(hObject, eventdata, handles)
% hObject    handle to setScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setScale



function scaleValue_Callback(hObject, eventdata, handles)
% hObject    handle to scaleValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaleValue as text
%        str2double(get(hObject,'String')) returns contents of scaleValue as a double


% --- Executes during object creation, after setting all properties.
function scaleValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previousFolder.
function previousFolder_Callback(hObject, eventdata, handles)
% hObject    handle to previousFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.folder_flag)
    n = length(handles.lst);
    handles.counter = handles.counter - 1;
    if(handles.counter <= n)
        handles = InitImage(handles.PathName, handles.lst(handles.counter).name, handles);        
        drawThings(hObject, eventdata, handles);
       
        guidata(hObject, handles);
        set(handles.show_background, 'Value', 1.0);    
    end
else
    j = -1;
    n = length(handles.lst);

    for i=1:n
        if(strcmp(handles.file_name, handles.lst(i).name) == 1)
            j = i - 1; 
            break;
        end
    end

    if(j > 1 & j < n)
        handles = InitImage(handles.PathName, handles.lst(j - 1).name, handles);
        guidata(hObject, handles);
        set(handles.show_background, 'Value', 1.0);    
    end
end
