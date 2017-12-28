% Predefined values
clusterNum = 512;
% Load center data
center = load(fullfile('data', 'center.mat'), 'C');
center = center.C;
% Load all feature data
imgPath = 'data/feature/';
imgDir = dir([imgPath '*.mat']);
for m=1:length(imgDir)
    fprintf('Processing the %dth data...\n', m);
    data = load(fullfile(imgPath, imgDir(m).name), 'features');
    data = data.features;
    [row col] = size(data);
    for n=1:col
        V = repmat(data(:, n)', 512, 1) - center;
        ret = sum(abs(V), 2);
        [~, index] = min(ret);
        minCluster(n) = index;
    end
    fid = fopen(fullfile('data/nearest', sprintf('%s', imgDir(m).name)), 'w+');
    fclose(fid);
    save(fullfile('data/nearest', sprintf('%s', imgDir(m).name)), 'minCluster');
end