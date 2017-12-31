% Predefined values
clusterNum = 1024;
imgPath = 'data/position/';
imgDir = dir([imgPath '*.mat']);
testNum = 2000;
HRSize = 9;
coff = [];

% Read all data to memory
nameList = [];
features = cell(length(imgDir), 1);
centers = cell(length(imgDir), 1);
pClusters = cell(length(imgDir), 1);
images = cell(length(imgDir), 1);
for a=1:length(imgDir)
    [~, name, ~] = fileparts(imgDir(a).name);
    nameList = [nameList name];
    % Get all center in this file
    center = load(fullfile('data/position', imgDir(a).name), 'centers');
    center = center.centers;
    centers{a} = center;
    % Get all features
    feature = load(fullfile('data/feature', imgDir(a).name), 'features');
    feature = feature.features;
    features{a} = feature;
    % Get all cluster
    pointCluster = load(fullfile('data/nearest', imgDir(a).name), 'minCluster');
    pointCluster = pointCluster.minCluster;
    pClusters{a} = pointCluster;
    % Get raw image
    HRImage = double(rgb2ycbcr(imread(fullfile('train', sprintf('%s.jpg', name)))));
    HRImage = HRImage(:, :, 1);
    images{a} = HRImage;
end
fprintf('Finish reading all data.\n');

% Get every patch in each cluster
for m=1:clusterNum
    wantedLRFeature = [];
    wantedHRFeature = [];
    fprintf('Calculate the %dth cluster...\n', m);
    for a=1:length(imgDir)
        if (size(wantedLRFeature, 2) >= testNum)
            break;
        end
        % Get patches which belong to current cluster
        match = (pClusters{a} == m);
        if nnz(match) <= 0
            continue;
        end
        match = find(match);
        % Get wanted LR and HR features
        wantedLRFeature = [wantedLRFeature features{a}(:, match)];
        wantedLRPosition = centers{a}(:, match);
        for b=1:length(match)
            LRPoint = wantedLRPosition(:, b);
            % Get HR patch
            HRPatch = images{a}(3*(LRPoint(1)-1)-2:3*(LRPoint(1)+1), 3*(LRPoint(2)-1)-2:3*(LRPoint(2)+1));
            % Calculate HR feature
            HRFeature = reshape(HRPatch, [HRSize .^ 2, 1]) - (sum(sum(wantedLRFeature(:, b))) / 45);
            wantedHRFeature = [wantedHRFeature HRFeature];
        end
    end
    % Calculate value of regression coefficient
    wantedLRFeature = [wantedLRFeature; ones(1, size(wantedLRFeature, 2))];
    for b=1:HRSize .^ 2
        tmp = wantedHRFeature(b, :);
        tmp = wantedLRFeature' \ tmp';
        coff(b, :, m) = tmp';
    end
end
fid = fopen(fullfile('data', 'regression.mat'), 'w+');
fclose(fid);
save(fullfile('data', 'regression.mat'), 'coff');
