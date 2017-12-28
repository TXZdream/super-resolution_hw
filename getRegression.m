% Predefined values
clusterNum = 512;
imgPath = 'data/position/';
imgDir = dir([imgPath '*.mat']);
% Get every patch in each cluster
for m=1:clusterNum
    for a=1:length(imgDir)
        % Get all center in this file
        center = load(fullfile('data/position', imgPath(a).name), 'centers');
        center = center.centers;
        % Get all cluster
        pointCluster = load(fullfile('data/nearest', imgPath(a).name), 'minCluster');
        pointCluster = pointCluster.minCluster;
        % Get all features
        feature = load(fullfile('data/feature', imgPath(a).name), 'features');
        feature = feature.features;
        % TODO: Get raw image
        HRImage;
        % Get patches which belong to current cluster
        match = (pointCluster == m);
        if nnz(match) <= 0
            continue;
        end
        match = find(match);
        % Get wanted LR and HR features
        wantedLRFeature = feature(:, match);
        wantedLRPosition = center(:, match);
        for b=1:length(match)
            LRPoint = wantedLRPosition(:, b);
            % Get four points in HR image with scale 3
            LU = [3*(LRPoint(1)-2)+1 3*(LRPoint(2)-2)+1];
            RU = [3*(LRPoint(1)+1)+1 3*(LRPoint(2)-2)+1];
            LD = [3*(LRPoint(1)-2)+1 3*(LRPoint(2)+1)+1];
            RU = [3*(LRPoint(1)+1)+1 3*(LRPoint(2)+1)+1];
            % Get HR patch
            HRPatch = HRImage(LU:LD, RU:RD);
            % TODO: Calculate HR feature
        end
    end
end