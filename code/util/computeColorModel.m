function colors = computeColorModel(fmt)
%
%
%   colors = computeColorModel(fmt)
%
%

colors = [];

lst = dir(['*.', fmt]);

patchSize = 8;

for i=1:length(lst)
   img = ldrimread(lst(i).name);
   img = imresize(img, 0.25, 'bilinear');
   
   img = imWhiteBalance(img.^2.2, []).^(1.0/2.2);
   
   
   
   hf = figure(4001);
   imshow(img);
   [x,y,button] = ginput(1);
   color_i = mean(mean(img( (y - patchSize):(y + patchSize), (x - patchSize):(x + patchSize), :)));
   close(hf);
   
   colors = [colors; reshape(color_i, 1, 3)];
end

end

