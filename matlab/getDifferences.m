function D = getDifferences(X)

% Replace -1 with NaN (will be ignored)
X(find(X==-1))= NaN;

% Compute differentials
for i=1:(size(X,1)-1)
    if (X(i,1)==X(i+1,1))
        X(i,3:end) = X(i+1,3:end)-X(i,3:end);
    else
        X(i,3:end) = nan(1,size(X,2)-2);
    end
end
X(end,3:end) = nan(1,size(X,2)-2);
D = X(:,3:end);

end