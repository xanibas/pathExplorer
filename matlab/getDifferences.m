function D = getDifferences(X)

% Replace -1 with NaN (will be ignored)
X(find(X==-1))= NaN;

% Compute differentials
for i=1:(size(X,1)-1)
    if (X(i,1)==X(i+1,1))
        X(i,4:end) = X(i+1,4:end)-X(i,4:end);
    else
        X(i,4:end) = nan(1,size(X,2)-3);
    end
end
X(end,4:end) = nan(1,size(X,2)-3);
D = X(:,4:end);

% Normalize to maximum distance between two genes to 1
D = (D./max(max(abs(D))))/2;

%for i=1:size(D,1)
%    D(i,:) = (D(i,:)./max(max(abs(D(i,:)))))/2;
%end

end