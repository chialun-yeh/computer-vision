for imgNum = 1:20
     imageLoc = ['TeddyBear\obj02_' num2str(imgNum, '%03d') '.jpg'];
     img = imread(imageLoc);
end