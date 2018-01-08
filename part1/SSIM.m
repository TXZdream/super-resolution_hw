function output = SSIM(inputImg1, inputImg2)
%SSIM - Description
%
% Syntax: output = SSIM(inputImg1, inputImg2)
%

    % Predefined value
    C1 = (0.01 * 255) .^ 2;
    C2 = (0.03 * 255) .^ 2;

    % Get size of image
    [row col tmp] = size(inputImg1);
    if tmp == 3
        inputImg1 = rgb2gray(inputImg1);
        inputImg2 = rgb2gray(inputImg2);
    end
    inputImg1 = double(inputImg1);
    inputImg2 = double(inputImg2);
    window = gaussian(11, 1.5);
    window = window / sum(sum(window));
    % Filter with gaussian to get required value
    miux = myfilter(inputImg1, window);
    miuy = myfilter(inputImg2, window);
    sigmax = myfilter(inputImg1 .^ 2, window) - miux .^ 2;
    sigmay = myfilter(inputImg2 .^ 2, window) - miuy .^ 2;
    sigmaxy = myfilter(inputImg2 .* inputImg1, window) - miux .* miuy;
    % miux = filter2(window, inputImg1, 'valid');
    % miuy = filter2(window, inputImg2, 'valid');
    % sigmax = filter2(window, inputImg1 .^ 2, 'valid') - miux .^ 2;
    % sigmay = filter2(window, inputImg2 .^ 2, 'valid') - miuy .^ 2;
    % sigmaxy = filter2(window, inputImg1 .* inputImg2, 'valid') - miux .* miuy;
    % Get ssim
    ssim = ((2 * (miux .* miuy) + C1) .* (2 * sigmaxy + C2))...
        ./ ((miux .^ 2 + miuy .^ 2 + C1) .* (sigmax + sigmay + C2));
    ssim = ((2*miux .* miuy + C1).*(2*sigmaxy + C2))./((miux .^ 2 + miuy .^ 2 + C1).*(sigmax + sigmay + C2));
    % output = sum(sum(ssim)) / (row * col);
    output = mean2(ssim);
end