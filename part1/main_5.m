% P1_getPatches
% P2_cluster
% P3_nearest
% P4_getRegression
patchSize = 7;
imgPath = 'image/';
imgDir = dir([imgPath '*.bmp']);
window = gaussian(11, 1.7);
window = window / sum(sum(window));
% clusterNum = 512;
clusterNum = 1024;
% Load regression coff
coff = load(fullfile('data', 'regression.mat'), 'coff');
coff = coff.coff;
% Load cluster center
Cluster = load(fullfile('data', 'center.mat'), 'C');
Cluster = Cluster.C;
% Handle all image
ssimArr = [];
psnrArr = [];
for m=1:length(imgDir)
% for m=1:1
    img = imread([imgPath imgDir(m).name]);
    raw = img;
    imgDir(m).name
    [height width tmp] = size(img);

    % Minisize to 1/3
    img = double(myfilter(img, window));
    small = bicubic(img, floor(height / 3), floor(width / 3));
    % RGB to YCbCr
    if size(small, 3) == 3
        small = rgb2ycbcr(small);
    end
    smally = small(:, :, 1);
    large = zeros(height, width);
    times = zeros(height, width);
    ret = zeros(height, width, 3);
    % Extend small image
    paddingSmally = wextend('2d', 'sym', smally, 3);
    % Get HR patch
    for a=1:floor(height / 3)
        for b=1:floor(width / 3)
            patch = zeros(patchSize, patchSize);
            for c=-3:3
                for d=-3:3
                    % if a + c > 0 && a + c <= floor(height / 3) && b + d > 0 && b + d <= floor(width / 3)
                        patch(c + 4, d + 4) = paddingSmally(a + c + 3, b + d + 3);
                    % end
                end
            end
            patch = patch([2:6 8:42 44:48]);
            pMean = sum(sum(patch)) / (patchSize .^ 2 - 4);
            patch = reshape(patch, [patchSize .^ 2 - 4, 1]) - pMean;
            % Judge which cluster
            judge = repmat(patch', [clusterNum 1]) - Cluster;
            judge = sum(judge .^ 2, 2);
            [~, index] = min(judge);
            C = coff(:, :, index);
            % Get HR patch
            HRPatch = C * [patch; 1];
            HRPatch = reshape(HRPatch, [9 9]) + pMean;
            for c=0:8
                for d=0:8
                    if c+3*(a-1)-2 > 0 && c+3*(a-1)-2 <= height && d+3*(b-1)-2 > 0 && d+3*(b-1)-2 <= width
                        large(c+3*(a-1)-2, d+3*(b-1)-2) = large(c+3*(a-1)-2, d+3*(b-1)-2) + HRPatch(c + 1, d + 1);
                        times(c+3*(a-1)-2, d+3*(b-1)-2) = times(c+3*(a-1)-2, d+3*(b-1)-2) + 1;
                    end
                end
            end
        end
    end
    large = large ./ times;
    for a=1:height
        for b=1:width
            if large(a, b) < 0
                large(a, b) = 0;
            end
            if large(a, b) > 255
                large(a, b) = 255;
            end
        end
    end
    if size(small, 3) == 3
        ret = bicubic(small, height, width);
        ret(:, :, 1) = large;
        ret = ycbcr2rgb(ret);
    else
        ret = uint8(large);
    end
    imwrite(ret, strcat('target/large2/', imgDir(m).name));
    % Display PSNR and SSIM
    [row col dim] = size(ret);
    raw = raw(1:row, 1:col, 1:dim);
    % PSNR(raw, ret)
    psnrArr = [psnrArr psnr(raw, ret)];
    % SSIM(raw, ret)
    ssimArr = [ssimArr ssim2(raw, ret)];
end
psnrArr
ssimArr
mean(psnrArr)
mean(ssimArr)