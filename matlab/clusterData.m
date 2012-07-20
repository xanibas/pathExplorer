function Y = clusterData(Y)

% Replace NaN by zero
Y(find(isnan(Y)==1))= 0;
Z = linkage(squareform(Y), 'weighted');

% Display dendrogram and sorted correlation matrix
figure; subplot(1,2,1,'align');
[H,T,perm] = dendrogram(Z,0,'colorthreshold',0.2,'orientation','left');
Y = permutesquare(Y,permuteinvert(perm));
subplot(1,2,2,'align');
imagesc(Y);
colormap('jet');

end