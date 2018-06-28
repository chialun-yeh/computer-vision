function [frame, descriptors] = harrisDecSiftDes(img)
%Harris feature detector with SIFT and SIFT descriptor
[h, w, channel] = size(img);
if channel == 3
    img = rgb2gray(img);
end
sigma = 1:12;
filtered_img = zeros(h,w,length(sigma));
scaleInvariantPoints = [];
%calculate Laplacian of Gaussian for each scale
for s = sigma  
    filtered_img(:,:,s) = s^2.*imfilter(img, fspecial('log', ceil(s*6+1), s), 'replicate', 'same');
end

%find scale-invariant interest points
for s = 2:length(sigma)-1
    [r, c] = harris(filtered_img(:,:,s), s);
    for keypoint = 1:length(r)
        isMax = true;
        max = filtered_img(r(keypoint),c(keypoint),s);
        for scale = s-1:2:s+1
             if filtered_img(r(keypoint),c(keypoint),scale) > max
                 isMax = false;
             end
        end
        if isMax == true
            scaleInvariantPoints = [scaleInvariantPoints ;[r(keypoint),c(keypoint),s]];
        end
    end
end

%creat descriptors of the detected keypoints using SIFT
paras=[scaleInvariantPoints(:,2)';scaleInvariantPoints(:,1)';2.*scaleInvariantPoints(:,3)'+1;zeros(size(scaleInvariantPoints(:,3)))'];
[frame, descriptors] = vl_sift(single(img), 'frames', paras,'orientations');

%show interest points on image
imshow(img); hold on
perm = randperm(size(frame,2));
sel = perm(:);
h1 = vl_plotframe(frame(:,sel));
set(h1,'color','k')

end

