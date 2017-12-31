clear
% Predefined values
clusterNum = 1024;
times = 500;
featureNum = 200000;
% Read if data exists
if ~exist(fullfile('data', 'feature.mat'), 'file')
    % Read all data from files to a matrix
    imgPath = 'data/feature/';
    imgDir = dir([imgPath '*.mat']);
    train = [];
    for m=1:length(imgDir)
        fprintf('Reading the %dth data...\n', m);
        data = load(fullfile(imgPath, imgDir(m).name), 'features');
        data = data.features;
        train = [train; data'];
    end
    fprintf('Finish kmeans clustering.\n');
    train = train(1:featureNum, :);
    % Save all data to disk
    fid = fopen(fullfile('data/', 'feature.mat'), 'w+');
    fclose(fid);
    save(fullfile('data/', 'feature.mat'), 'train');
    fprintf('Finish writing data to disk.\n');
else
    train = load(fullfile('data', 'feature.mat'), 'train');
    train = train.train;
end

% Kmeans
tic
[IDX, C] = kmeans(train, clusterNum, 'MaxIter', times, 'Display', 'iter');
toc
% Sort and save center data
% [IDX, index] = sort(hist(IDX, clusterNum), 'descend');
% C = C(index, :);
fid = fopen(fullfile('data/', 'center.mat'), 'w+');
fclose(fid);
save(fullfile('data/', 'center.mat'), 'C');
fprintf('Finish saving center data.\n');
