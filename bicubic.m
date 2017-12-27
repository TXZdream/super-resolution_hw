function output = bicubic(input, height, width)
%bicubic - Description
%
% Syntax: output = bicubic(input, height, width)
%

    [row, col, tmp] = size(input);
    input = double(input);

    % Calculate all the point
    for m=1:height
        m1 = (m - 1) / height * row + 1;
        for n=1:width
            n1 = (n - 1) / width * col + 1;

            for index=1:tmp
                total(index) = 0;
            end

            % Adjacent 16 points
            for a = -1:2
                m2 = floor(m1) + a;
                if m2 <= 0 || m2 > row
                    continue;
                end

                for b = -1:2
                    n2 = floor(n1) + b;
                    if n2 <= 0 || n2 > col
                        continue;
                    end

                    % Count acording to the reference pdf
                    for index=1:tmp
                        total(index) = total(index) + W(m1 - m2) * W(n1 - n2) * input(m2, n2, index);
                    end

                end

            end

            % Write back
            for index=1:tmp
                output(m, n, index) = uint8(total(index));
            end

        end
    end

end
