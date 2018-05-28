% the Lukas Kanade Tracker:
% the initial points in the first frams are tracked. In the video
% 'tracked.avi' this is shown, where yellow dots are the ground truth and
% pink dots are the tracked points

function [pointsx, pointsy] = LKtracker(p,im,sigma)

%pre-alocate point locations and image derivatives
pointsx = zeros(size(im,3),size(p,2));
pointsy = zeros(size(im,3),size(p,2));
pointsx(1,:) = p(1,:);
pointsy(1,:) = p(2,:);
%fill in starting points
It=zeros(size(im) - [0 0 1]);
Ix=zeros(size(im) - [0 0 1]);
Iy=zeros(size(im) - [0 0 1]);

%find x,y and t derivative
for i=1:size(im,3)-1
    Ix(:,:,i)= ImageDerivatives(im(:,:,i), sigma, 'x');
    Iy(:,:,i)= ImageDerivatives(im(:,:,i), sigma, 'y');
    It(:,:,i)= im(:,:,i+1) - im(:,:,i);
end

writerObj = VideoWriter('test.avi');
open(writerObj);

for num = 1:size(im,3)-1 % iterating through images
    for i = 1:size(p,2) % iterating throught points
        x = pointsx(num,i);
        y = pointsy(num,i);
        startx=floor(x-7); endx=floor(x+7); starty=floor(y-7); endy=floor(y+7);
        if startx<1; startx=1; end
        if endx>size(im,2); endx=size(im,2); end
        if starty<1; starty=1; end
        if endy>size(im,1); endy=size(im,1); end
        A1 = Ix(starty:endy,startx:endx,num);
        A2 = Iy(starty:endy,startx:endx,num);
        A = [A1(:) A2(:)];
        b = It(starty:endy,startx:endx,num); b=b(:);
        v = inv(A'*A)*A'*b;
        pointsx(num+1,i) = pointsx(num,i)+v(1);
        pointsy(num+1,i) = pointsy(num,i)+v(2);
    end
     figure(1)
     imshow(im(:,:,num),[])
     hold on
     plot(pointsx(num,:),pointsy(num,:),'.y') %tracked points
     plot(p(num*2-1,:),p(num*2,:),'.m')  %ground truth
     frame = getframe;
     writeVideo(writerObj,frame);
end
close(writerObj);


end
