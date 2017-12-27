function output = myfilter(input, mask)
%filter - Description
%
% Syntax: output = filter(input, mask)
%

    [mSize tmp] = size(mask);
    [row col tmp] = size(input);
    input = double(input);
    mask = double(mask);
    padding = zeros(row + mSize, col + mSize, tmp);
    padding(ceil(mSize/2):floor(mSize/2)+row, ceil(mSize/2):floor(mSize/2)+col, :) = input;

    for m=ceil(mSize/2):floor(mSize/2)+row
        for n=ceil(mSize/2):floor(mSize/2)+col
            total = zeros(1, tmp);
            for a=1:tmp
                total(a) = sum(sum(mask .* padding(m-floor(mSize/2):m+floor(mSize/2), n-floor(mSize/2):n+floor(mSize/2), a)));
            end
            for a=1:tmp
                output(m-floor(mSize/2), n-floor(mSize/2), a) = total(a);
            end
        end
    end

end