% Predefined values
clusterNum = 512;
imgPath = 'data/position/';
imgDir = dir([imgPath '*.mat']);
testNum = 20000;
HRSize = 9;
coff = [];

% Read all data to memory
nameList = [];
features = cell(length(imgDir), 1);
pClusters = cell(length(imgDir), 1);
HRFeatures = cell(length(imgDir), 1);
for a=1:length(imgDir)
    [~, name, ~] = fileparts(imgDir(a).name);
    nameList = [nameList name];
    % Get all features
    feature = load(fullfile('data/feature', imgDir(a).name), 'features');
    feature = feature.features;
    features{a} = feature;
    % Get all cluster
    pointCluster = load(fullfile('data/nearest', imgDir(a).name), 'minCluster');
    pointCluster = pointCluster.minCluster;
    pClusters{a} = pointCluster;
    % Get all hr features
    HRFeature = load(fullfile('data/hrfeatures', imgDir(a).name), 'HRFeatures');
    HRFeature = HRFeature.HRFeatures;
    HRFeatures{a} = HRFeature;
end
fprintf('Finish reading all data.\n');

% Get every patch in each cluster
for m=1:clusterNum
    wantedLRFeature = [];
    wantedHRFeature = [];
    fprintf('Calculate the %dth cluster...\n', m);
    for a=1:length(features)
        % Get patches which belong to current cluster
        match = (pClusters{a} == m);
        if nnz(match) <= 0
            continue;
        end
        match = find(match);
        % Get wanted LR and HR features
        wantedLRFeature = [wantedLRFeature features{a}(:, match)];
        wantedHRFeature = [wantedHRFeature HRFeatures{a}(:, match)];
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
