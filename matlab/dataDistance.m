function Y = dataDistance(X)

% Compute distances by ignoring NaN
Y = zeros(size(X,1),size(X,1));
for i=1:size(X,1)
    for j=1:size(X,1)
        temp = X([i j],:);
        [r,c]=find(isnan(temp)==1);
        temp(:,c) = [];
        if i==j
            Y(i,j)=0;
        elseif size(temp,2)==0
            Y(i,j)=NaN;
        else
            Y(i,j)=pdist(temp)/size(temp,2);
        end
    end
end

% Normalize to 1
Y = Y./max(max(abs(Y)));

%Y(find(isnan(Y)==1))= 0;
% Z = linkage(squareform(Y), 'weighted');
% figure; subplot(1,2,1,'align');
% [H,T,perm] = dendrogram(Z,0,'colorthreshold',0,'orientation','left');
% Y = permutesquare(Y,permuteinvert(perm));
% subplot(1,2,2,'align');
% imagesc(Y);
% colormap('jet');

end