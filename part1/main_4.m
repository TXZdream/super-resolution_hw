imgPath = 'image/';
imgDir = dir([imgPath '*.bmp']);
% Get all of the image
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
    PSNR(img, large)
    SSIM(img, large)
    % ssim2(img, large) * 100
end