clear all;
close all;
clc;

%read files
v = VideoReader('v1.mp4');
get(v);

% Create a directory to store frames
working = 'Frames';
mkdir(working);
mkdir(fullfile(working,'images'));

ii = 1;

while hasFrame(v)
    img = readFrame(v);

    filename = [sprintf('%04d', ii),'.png'];
    fullname = fullfile(working, 'images', filename);
    imwrite(img,fullname);
    ii = ii+1;
end

imageNames = dir(fullfile(working, 'images','*.png'));
imageNames = {imageNames.name};
writeObj = VideoWriter(fullfile(working, 'output.avi'));

open(writeObj);
for t = 1:length(imageNames)
    Frame = imread(fullfile(working, 'images', imageNames{t}));
    n = imresize(Frame,[512,512]);
    
    Z(:,:,1) = dct2(n(:,:,1));
    Z(:,:,2) = dct2(n(:,:,2));
    Z(:,:,3) = dct2(n(:,:,3));

    for i = 1:512
        for j = 1:512
            if( (i+j) > 60 )
                Z(1,j,1) = 0;
                Z(1,j,2) = 0;
                Z(1,j,3) = 0;
            end
        end
    end

    K(:,:,1) = idct2(Z(:,:,1));
    K(:,:,2) = idct2(Z(:,:,2));
    K(:,:,3) = idct2(Z(:,:,3));

    Frame = imresize(uint8(K),0.3);
    writeVideo(writeObj, Frame);

end
close(writeObj);