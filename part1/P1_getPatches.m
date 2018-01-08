clear
% Predefined values
patchsize = 7;
% TODO: Judge if there exists saved file
% Read files
imgPath = 'train/';
imgDir = dir([imgPath '*.jpg']);
window = gaussian(11, 1.7);
window = window / sum(sum(window));

for m=1:length(imgDir)
    fprintf('The %dth image\n', m);
    img = imread([imgPath imgDir(m).name]);
    img = double(rgb2ycbcr(img));
    img = img(:, :, 1);

    % Get low resolution image
    blurImg = double(myfilter(img, window));
    [row col] = size(blurImg);
    row = row - mod(row, 3);
    col = col - mod(col, 3);
    blurImg = blurImg(1:row, 1:col);

    row = row / 3;
    col = col / 3;
    lrImg = double(bicubic(blurImg, row, col));

    % Get image feature
    num = (row - patchsize + 1) * (col - patchsize + 1);
    features = zeros(patchsize .^ 2 - 4, num);
    HRFeatures = zeros(9 ^ 2, num);
    index = 1;
    for a=ceil(patchsize/2):row-floor(patchsize/2)
        for b=ceil(patchsize/2):col-floor(patchsize/2)
            patch = lrImg(a-floor(patchsize/2):a+floor(patchsize/2), b-floor(patchsize/2):b+floor(patchsize/2));
            patch = patch([2:6 8:42 44:48]);
            pMean = sum(sum(patch)) / (patchsize .^ 2 - 4);
            features(:, index) = patch - pMean;
            HRFeatures(:, index) = reshape(img(3*(a-1)-2:3*(a+1), 3*(b-1)-2:3*(b+1)), [9 ^ 2, 1]) - pMean;
            index = index + 1;
        end
    end
    % Save features
    folder_hrfeatures = fullfile(sprintf('%s/data/hrfeatures/', pwd));
    folder_feature = fullfile(sprintf('%s/data/feature/', pwd));
    [filepath, name, ext] = fileparts(imgDir(m).name);
    hr_features = fullfile(folder_hrfeatures, sprintf('%s.mat', name));
    fn_feature_full = fullfile(folder_feature, sprintf('%s.mat', name));

    fid = fopen(hr_features, 'w');
    fclose(fid);
    fid = fopen(fn_feature_full, 'w');
    fclose(fid);

    save(hr_features, 'HRFeatures');
    save(fn_feature_full, 'features');
end
