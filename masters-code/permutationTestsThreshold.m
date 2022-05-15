% Script requires montecluster package (-DETAILS OF HOW TO FIND HERE-)

%% Import/Setup general details
participantData = readtable('participant_demographics.csv');
densityPoints = readmatrix('.\final_analysis\graph_threshold_overview\densityPoints.csv');

results.metric = cell(9,1);
results.p = ones(9,3);
results.s = zeros(9,3);

iterations = 10^0

%% Import threshold statisitics
invCountCplThresh = readmatrix('.\final_analysis\graph_threshold_metrics\invCountCplThresh.csv');
lengthCplThresh = readmatrix('.\final_analysis\graph_threshold_metrics\lengthCplThresh.csv');
infoCplThresh = readmatrix('.\final_analysis\graph_threshold_metrics\infoCplThresh.csv');
invCountEglobThresh = readmatrix('.\final_analysis\graph_threshold_metrics\invCountEglobThresh.csv');
lengthEglobThresh = readmatrix('.\final_analysis\graph_threshold_metrics\lengthEglobThresh.csv');
infoEglobThresh = readmatrix('.\final_analysis\graph_threshold_metrics\infoEglobThresh.csv');
countClusterThresh = readmatrix('.\final_analysis\graph_threshold_metrics\countClusterThresh.csv');
countAssortativityThresh = readmatrix('.\final_analysis\graph_threshold_metrics\countAssortativityThresh.csv');
entropyRateThresh = readmatrix('.\final_analysis\graph_threshold_metrics\entropyRateThresh.csv');

totalWeightThreshold = readmatrix('.\final_analysis\graph_threshold_overview\totalWeightThreshold.csv');

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);

% NO CLUSTER FOUND
results.metric(1) = {'invCountCplThresh'};
[results.p(1,:), results.s(1,:)] = monteclustergroups(invCountCplThresh(controls, :)', invCountCplThresh(aMci, :)', 1, 0.1, 1, densityPoints);

results.metric(2) = {'lengthCplThresh'};
[results.p(2,:), results.s(2,:)] = monteclustergroups(lengthCplThresh(controls, :)', lengthCplThresh(aMci, :)', iterations, 0.05, 1, densityPoints);

results.metric(3) = {'infoCplThresh'};
[results.p(3,:), results.s(3,:)] = monteclustergroups(infoCplThresh(controls, 26:end)', infoCplThresh(aMci, 26:end)', iterations, 0.05, 1, densityPoints(26:end));

% NO CLUSTER FOUND
results.metric(4) = {'invCountEglobThresh'};
[results.p(4,:), results.s(4,:)] = monteclustergroups(invCountEglobThresh(controls, :)', invCountEglobThresh(aMci, :)', 1, 0.1, 1, densityPoints);

% NO CLUSTER FOUND
results.metric(5) = {'lengthEglobThresh'};
[results.p(5,:), results.s(5,:)] = monteclustergroups(lengthEglobThresh(controls, :)', lengthEglobThresh(aMci, :)', 1, 0.1, 1, densityPoints);

results.metric(6) = {'infoEglobThresh'};
[results.p(6,:), results.s(6,:)] = monteclustergroups(infoEglobThresh(controls, :)', infoEglobThresh(aMci, :)', iterations, 0.025, 1, densityPoints);

results.metric(7) = {'countClusterThresh'};
[results.p(7,:), results.s(7,:)] = monteclustergroups(countClusterThresh(controls, 2:end)', countClusterThresh(aMci, 2:end)', iterations, 0.025, 1, densityPoints(2:end));

results.metric(8) = {'countAssortativityThresh'};
[results.p(8,:), results.s(8,:)] = monteclustergroups(countAssortativityThresh(controls, 2:end)', countAssortativityThresh(aMci, 2:end)', iterations, 0.05, 1, densityPoints(2:end));

results.metric(9) = {'entropyRateThresh'};
[results.p(9,:), results.s(9,:)] = monteclustergroups(entropyRateThresh(controls, :)', entropyRateThresh(aMci, :)', iterations, 0.025, 1, densityPoints);

results.metric(10) = {'totalWeightThreshold'};
[results.p(10,:), results.s(10,:)] = monteclustergroups(totalWeightThreshold(controls, :)', totalWeightThreshold(aMci, :)', iterations, 0.05, 1, densityPoints);
