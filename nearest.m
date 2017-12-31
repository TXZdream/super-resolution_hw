% Predefined values
clusterNum = 1024;
% Load center data
center = load(fullfile('data', 'center.mat'), 'C');
center = center.C;
% Load all feature data
imgPath = 'data/feature/';
imgDir = dir([imgPath '*.mat']);
for m=1:length(imgDir)
    minCluster = [];
    fprintf('Processing the %dth data...\n', m);
    data = load(fullfile(imgPath, imgDir(m).name), 'features');
    data = data.features;
    [row col] = size(data);
    for n=1:col
        V = repmat(data(:, n)', [clusterNum, 1]) - center;
        ret = sum(V .^ 2, 2);
        [~, index] = min(ret);
        minCluster(n) = index;
    end
    fid = fopen(fullfile('data/nearest', sprintf('%s', imgDir(m).name)), 'w+');
    fclose(fid);
    save(fullfile('data/nearest', sprintf('%s', imgDir(m).name)), 'minCluster');
end