function temp = permutesquare( m, order )
%PERMUTESQUARE Permuta rows and columns of a square matrix
% accoding to the given order

%   Description

n = size(m,1);

temp = zeros(n,n);
for i=1:n
    for j=1:n
        temp(i,j) = m(order(i),order(j));
    end
end

end