% getPatches
% cluster
% nearset
% getRegression
patchSize = 7;
imgPath = 'image/';
imgDir = dir([imgPath '*.bmp']);
% Load regression coff
coff = load(fullfile('data', 'regression.mat'), 'coff');
coff = coff.coff;
% Load cluster
Cluster = load(fullfile('data', 'center.mat'), 'C');
Cluster = Cluster.C;
% Handle all image
for m=1:length(imgDir)
    img = imread([imgPath imgDir(m).name]);
    imgDir(m).name
    [height width tmp] = size(img);

    % Minisize to 1/3
    small = bicubic(img, floor(height / 3), floor(width / 3));
    % RGB to YCbCr
    small = rgb2ycbcr(small);
    small = small(:, :, 1);
    large = zeros(height, width);
    % Get patch
    for a=1:floor(height / 3)
        for b=1:floor(width / 3)
            patch = zeros(patchSize, patchSize);
            for c=-3:3
                for d=-3:3
                    if a + c > 0 && a + c <= floor(height / 3) && b + d > 0 && b + d <= floor(width / 3)
                        patch(c + 4, d + 4) = small(a + c, b + d);
                    end
                end
            end
            patch = patch([2:6 8:42 44:48]);
            patch = reshape(patch, [patchSize .^ 2 - 4, 1]) - sum(sum(patch)) / (patchSize .^ 2 - 4);
            % Judge which cluster
            judge = repmat(patch', [512 1]) - Cluster;
            judge = sum(abs(judge), 2);
            [~, index] = min(judge);
            C = coff(:, :, index);
            % Get HR patch
            HRPatch = C * [patch; 1];
            HRPatch = reshape(HRPatch, [9 9]);
            for c=0:8
                for d=0:8
                    if c+3*(a-1)-2 > 0 && c+3*(a-1)-2 <= height && d+3*(b-1)-2 > 0 && d+3*(b-1)-2 <= width
                        large(c+3*(a-1)-2, d+3*(b-1)-2) = HRPatch(c + 1, d + 1);
                    end
                end
            end
        end
    end
    max(max(large ./ 6))
end