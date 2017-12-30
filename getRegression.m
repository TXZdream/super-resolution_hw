% Predefined values
clusterNum = 512;
imgPath = 'data/position/';
imgDir = dir([imgPath '*.mat']);
testNum = 2000;
HRSize = 9;
coff = [];
% Get every patch in each cluster
for m=1:clusterNum
% for m=229:229
    wantedLRFeature = [];
    wantedHRFeature = [];
    fprintf('Calculate the %dth cluster...\n', m);
    for a=1:length(imgDir)
    % for a = 302:302
        if (size(wantedLRFeature, 2) >= testNum)
            break;
        end
        fprintf('    Reading the %dth file...\n', a);
        % Get all center in this file
        center = load(fullfile('data/position', imgDir(a).name), 'centers');
        center = center.centers;
        % Get all cluster
        pointCluster = load(fullfile('data/nearest', imgDir(a).name), 'minCluster');
        pointCluster = pointCluster.minCluster;
        % Get all features
        feature = load(fullfile('data/feature', imgDir(a).name), 'features');
        feature = feature.features;
        % Get raw image
        [~, name, ~] = fileparts(imgDir(a).name);
        HRImage = double(rgb2ycbcr(imread(fullfile('train', sprintf('%s.jpg', name)))))(:, :, 1);
        % Get patches which belong to current cluster
        match = (pointCluster == m);
        if nnz(match) <= 0
            continue;
        end
        match = find(match);
        % Get wanted LR and HR features
        wantedLRFeature = [wantedLRFeature feature(:, match)];
        wantedLRPosition = center(:, match);
        for b=1:length(match)
            LRPoint = wantedLRPosition(:, b);
            % Get HR patch
            HRPatch = HRImage(3*(LRPoint(1)-1)-2:3*(LRPoint(1)+1), 3*(LRPoint(2)-1)-2:3*(LRPoint(2)+1));
            % Calculate HR feature
            HRFeature = reshape(HRPatch, [HRSize .^ 2, 1]) - (sum(sum(wantedLRFeature(:, b))) / 45);
            wantedHRFeature = [wantedHRFeature HRFeature];
        end
    end
    % Calculate value of regression coefficient
    wantedLRFeature = [wantedLRFeature; ones(1, size(wantedLRFeature, 2))];
    regre = cell(1, HRSize .^ 2);
    for b=1:HRSize .^ 2
        tmp = wantedHRFeature(b, :);
        tmp = wantedLRFeature' \ tmp';
        regre{b} = tmp;
        coff(b, :, m) = tmp';
    end
    % Save regression file
    fid = fopen(fullfile('data/regression', sprintf('%d.mat', m)), 'w+');
    fclose(fid);
    save(fullfile('data/regression', sprintf('%d.mat', m)), 'regre');
end
size(coff)
fid = fopen(fullfile('data', 'regression.mat'), 'w+');
fclose(fid);
save(fullfile('data', 'regression.mat'), 'coff');
