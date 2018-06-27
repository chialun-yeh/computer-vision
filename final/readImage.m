function image_cell = readImage(dir_path,suffix)

filePattern = fullfile(dir_path,suffix);
jpegFiles = dir(filePattern);
image_cell = cell(1,length(jpegFiles));

for k = 1:2%length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(dir_path, baseFileName);
    fprintf(1, 'Reading %s\n', fullFileName);
    image_cell{k} = imread(fullFileName);
end

end