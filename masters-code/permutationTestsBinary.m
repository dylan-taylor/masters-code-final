% Script requires montecluster package (-DETAILS OF HOW TO FIND HERE-)

%% Import/Setup general details
participantData = readtable('participant_demographics.csv');
densityPoints = readmatrix('.\final_analysis\graph_threshold_overview\densityPoints.csv');

results.metric = cell(7,1);
results.p = ones(7,3);
results.s = zeros(7,3);

iterations = 10^5;

%% Import binary statisitics
cplThresh = readmatrix('.\final_analysis\graph_binary_metrics\cplThresh.csv');
infoCplThresh = readmatrix('.\final_analysis\graph_binary_metrics\infoCplThresh.csv');
eglobThresh = readmatrix('.\final_analysis\graph_binary_metrics\eglobThresh.csv');
infoEglobThresh = readmatrix('.\final_analysis\graph_binary_metrics\infoEglobThresh.csv');
clusterThresh = readmatrix('.\final_analysis\graph_binary_metrics\clusterThresh.csv');
assortativityThresh = readmatrix('.\final_analysis\graph_binary_metrics\assortativityThresh.csv');
entropyRateThresh = readmatrix('.\final_analysis\graph_binary_metrics\entropyRateThresh.csv');

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);

results.metric(1) = {'cplThresh'};
[results.p(1,:), results.s(1,:)] = monteclustergroups(cplThresh(controls, :)', cplThresh(aMci, :)', iterations, 0.1, 1, densityPoints);

results.metric(2) = {'infoCplThresh'};
[results.p(2,:), results.s(2,:)] = monteclustergroups(infoCplThresh(controls, 26:end)', infoCplThresh(aMci, 26:end)', iterations, 0.05, 1, densityPoints(26:end));

results.metric(3) = {'eglobThresh'};
[results.p(3,:), results.s(3,:)] = monteclustergroups(eglobThresh(controls, :)', eglobThresh(aMci, :)', iterations, 0.1, 1, densityPoints);

results.metric(4) = {'infoEglobThresh'};
[results.p(4,:), results.s(4,:)] = monteclustergroups(infoEglobThresh(controls, :)', infoEglobThresh(aMci, :)', iterations, 0.05, 1, densityPoints);

results.metric(5) = {'clusterThresh'};
[results.p(5,:), results.s(5,:)] = monteclustergroups(clusterThresh(controls, 2:end)', clusterThresh(aMci, 2:end)', iterations, 0.025, 1, densityPoints(2:end));

results.metric(6) = {'assortativityThresh'};
[results.p(6,:), results.s(6,:)] = monteclustergroups(assortativityThresh(controls, 2:end)', assortativityThresh(aMci, 2:end)', iterations, 0.05, 1, densityPoints(2:end));

results.metric(7) = {'entropyRateThresh'};
[results.p(7,:), results.s(7,:)] = monteclustergroups(entropyRateThresh(controls, :)', entropyRateThresh(aMci, :)', iterations, 0.1, 1, densityPoints);
