function output = W(x)
%W - Description
%
% Syntax: output = W(x)
%

    x = abs(x);
    if x >= 0 & x <= 1
        output = 1.5 * (x ^ 3) - 2.5 * (x ^ 2) + 1;
    else if x > 1 & x <= 2
        output = -0.5 * (x ^ 3) + 2.5 * (x ^ 2) - 4 * x + 2;
    else
        output = 0;
    end

end