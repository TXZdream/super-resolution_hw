imgPath = 'image/';
imgDir = dir([imgPath '*.bmp']);
% Get all of the image
ssimArr = [];
psnrArr = [];
for m=1:length(imgDir)
    img = imread([imgPath imgDir(m).name]);
    imgDir(m).name
    [height width tmp] = size(img);

    % Minisize to 1/3
    small = bicubic(img, floor(height / 3), floor(width / 3));
    imwrite(small, strcat('target/small/', imgDir(m).name));

    % Scale to raw size
    large = bicubic(small, height, width);
    imwrite(large, strcat('target/large/', imgDir(m).name));

    % Get PSNR value
    psnrArr = [psnrArr psnr(img, large)];
    ssimArr = [ssimArr ssim2(img, large)];
end
psnrArr
ssimArr
mean(psnrArr)
mean(ssimArr)
