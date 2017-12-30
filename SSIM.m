function output = SSIM(inputImg1, inputImg2)
%SSIM - Description
%
% Syntax: output = SSIM(inputImg1, inputImg2)
%

    % Predefined value
    C1 = (0.01 * 255) .^ 2;
    C2 = (0.03 * 255) .^ 2;
    % Get size of image
    inputImg1 = double(inputImg1(:, :, 1));
    inputImg2 = double(inputImg2(:, :, 1));
    [row col tmp] = size(inputImg1);
    window = gaussian(11, 1.5);
    window = window / sum(sum(window));
    % Filter with gaussian to get required value
    miux = myfilter(inputImg1, window);
    miuy = myfilter(inputImg2, window);
    sigmax = myfilter(inputImg1 .^ 2, window) - miux .^ 2;
    sigmay = myfilter(inputImg2 .^ 2, window) - miuy .^ 2;
    sigmaxy = myfilter(inputImg2 .* inputImg1, window) - miux .* miuy;
    % Get ssim
    for a=1:tmp
        ssim(:, :, a) = ((2 * (miux(:, :, a) .* miuy(:, :, a)) + C1) .* (2 * sigmaxy(:, :, a) + C2))...
            ./ ((miux(:, :, a) .^ 2 + miuy(:, :, a) .^ 2 + C1) .* (sigmax(:, :, a) + sigmay(:, :, a) + C2));
    end
    output = sum(sum(ssim)) / (row * col);
end