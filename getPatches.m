clear
% Predefined values
patchsize = 7;
% TODO: Judge if there exists saved file
% Read files
imgPath = 'train/';
imgDir = dir([imgPath '*.jpg']);
window = gaussian(11, 1.7);

for m=1:length(imgDir)
    fprintf('The %dth image\n', m);
    img = imread([imgPath imgDir(m).name]);
    img = rgb2ycbcr(img);
    img = double(img(:, :, 1));

    % Get low resolution image
    blurImg = myfilter(img, window);
    [row col] = size(blurImg);
    row = row - mod(row, 3);
    col = col - mod(col, 3);
    blurImg = blurImg(1:row, 1:col);

    row = row / 3;
    col = col / 3;
    lrImg = bicubic(blurImg, row, col);

    % Get image feature
    num = (row - patchsize + 1) * (col - patchsize + 1);
    features = zeros(patchsize .^ 2 - 4, num);
    centers = zeros(2, num);
    index = 1;
    for a=ceil(patchsize/2):row-floor(patchsize/2)
        for b=ceil(patchsize/2):col-floor(patchsize/2)
            patch = lrImg(a-floor(patchsize/2):a+floor(patchsize/2), b-floor(patchsize/2):b+floor(patchsize/2));
            patch = patch([2:6 8:42 44:48]);
            pMean = sum(sum(patch)) / (patchsize .^ 2 - 4);
            features(:, index) = patch - pMean;
            centers(:, index) = [a; b];
            index = index + 1;
        end
    end
    % Save features
    folder_position = fullfile(sprintf('%s/data/position/', pwd));
    folder_feature = fullfile(sprintf('%s/data/feature/', pwd));
    [filepath, name, ext] = fileparts(imgDir(m).name);
    fn_position_full = fullfile(folder_position, sprintf('%s.mat', name));
    fn_feature_full = fullfile(folder_feature, sprintf('%s.mat', name));

    fid = fopen(fn_position_full, 'w');
    fclose(fid);
    fid = fopen(fn_feature_full, 'w');
    fclose(fid);

    save(fn_position_full, 'centers');
    save(fn_feature_full, 'features');
end
