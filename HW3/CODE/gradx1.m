%
% Returns: 2x1 vector corresponding to the gradent of x1.

function [val] = gradx1(a, d, x1, x2)

val = -4*(dot(a(:, 1) - x1, a(:, 1) - x1) - d(1)^2) * (a(:, 1) - x1) ....
    -4*(dot(a(:, 2) - x1, a(:, 2) - x1) - d(2)^2) * (a(:, 2) - x1) ...
    +4*(dot(x1 - x2, x1 - x2) - d(5)^2)*(x1-x2);
end
