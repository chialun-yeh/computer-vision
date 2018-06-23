clear
clc
path = '/Users/xuecho/Documents/GitHub/computer-vision/final/textDescriptor/haraff/';
path2= '/Users/xuecho/Documents/GitHub/computer-vision/final/textDescriptor/hesaff/';

haraff = dir(fullfile('textDescriptor','haraff','*.txt'));
hesaff = dir(fullfile('textDescriptor','hesaff','*.txt'));

haraff_descriptor = cell(length(haraff),1);
haraff_frame = cell(length(haraff),1);

hesaff_descriptor = cell(length(hesaff),1);
hesaff_frame = cell(length(hesaff),1);

%haraff
for i=1:length(haraff)
    a =  dlmread(fullfile(path,[haraff(i).name]),'', 2,0);
    haraff_descriptor{i,1} = a(:,6:133)';
    haraff_frame{i,1} = a(:,1:2)';
    fprintf('%i\n',i);
end

%hesaff
for i=1:length(hesaff)
    a =  dlmread(fullfile(path2,[hesaff(i).name]),'', 2,0);
    hesaff_descriptor{i,1} = a(:,6:133)';
    hesaff_frame{i,1} = a(:,1:2)';
    fprintf('%i\n',i);
end

