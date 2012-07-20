% Run scripts to import data and generate the json file with the network
% description

data = importdata('../data/query.txt');
Y = dataDistance(data.data);
writeJson(data.data,data.textdata(3:end),Y,'../data/queryGraph.json');