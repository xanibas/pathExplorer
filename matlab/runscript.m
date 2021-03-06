% Run scripts to import data and generate the json file with the network

% import data
data = importdata('../data/query.txt');

% compute normalized differences
D = getDifferences(data.data);

% compute correlations
%Y = corrcoef(D','rows','pairwise');
C = dataDistance(norma(data.data));
Y = dataDistance(getDifferences(data.data));

% write to files
writeJson(data.data,data.textdata(4:end),D,Y,C,'../data/queryGraph.json');
%writeXgmml(data.data,data.textdata(4:end),D,Y,'../../../Eclipse3/queryGraph.xgmml');