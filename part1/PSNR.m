function [ output ] = PSNR( inputImg1, inputImg2 )
%PSNR Summary of this function goes here
%   Detailed explanation goes here

    % Get image size
    [row col tmp] = size(inputImg1);

    % Convert rgb to YCbCr
    if tmp == 3
        inputImg1 = rgb2ycbcr(inputImg1);
        inputImg1 = inputImg1(:, :, 1);
        inputImg2 = rgb2ycbcr(inputImg2);
        inputImg2 = inputImg2(:, :, 1);
    end
    inputImg1 = double(inputImg1);
    inputImg2 = double(inputImg2);

    % Get MSE
    MSE = sum(sum((inputImg1 - inputImg2) .^ 2)) ./ (row * col);

    % Return answer
    output =  20 * log10(255 / sqrt(MSE));

end
