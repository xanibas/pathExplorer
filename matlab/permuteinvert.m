function temp = permuteinvert( matrix )
%PERMUTEINVERT Permuta rows and columns of a matrix
% by inverted order

%   Description

m = size(matrix,1);
n = size(matrix,2);

temp = zeros(m,n);
for i=1:m
    for j=1:n
        temp(i,j) = matrix(m-i+1,n-j+1);
    end
end

end