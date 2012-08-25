function N = norma(D)

% Replace -1 with NaN (will be ignored)
D(find(D==-1))= NaN;
N = D(:,4:end);

% Normalize to maximum distance between two genes to 1
N = (N./max(max(abs(N))));

end