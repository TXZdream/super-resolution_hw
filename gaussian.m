function output = gaussian(size, sDev)
%gaussian - Description
%
% Syntax: output = gaussian(size, sDev)
%

    output = double(zeros(size));
    for m=-floor(size/2):floor(size/2)
        for n=-floor(size/2):floor(size/2)
            output(m + ceil(size/2), n + ceil(size/2)) = (exp(-(m ^ 2 + n ^ 2) / (2 * sDev ^ 2))) / (2 * (sDev ^ 2) * pi);
        end
    end

end