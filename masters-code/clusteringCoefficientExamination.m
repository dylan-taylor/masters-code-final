participantData = readtable('participant_demographics.csv');

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);

densityPoints = readmatrix('.\final_analysis\graph_threshold_overview\densityPoints.csv');
countCPL = readmatrix('.\final_analysis\graph_binary_metrics\cplThresh.csv')';
clusterThresh = readmatrix('.\final_analysis\graph_threshold_metrics\countClusterThresh.csv')';
clusterBinary = readmatrix('.\final_analysis\graph_binary_metrics\clusterThresh.csv')';

controlThresh = clusterThresh(:,controls);
aMciThresh = clusterThresh(:,aMci);

controlBinary = clusterBinary(:,controls);
aMciBinary = clusterBinary(:,aMci);


figure(1)
plot(densityPoints, zeros(length(densityPoints),1))
title("Thresholded Clustering")
hold on
plot(densityPoints, mean(controlThresh, 2)-mean(aMciThresh,2))
hold off

figure(2)

plot(densityPoints, zeros(length(densityPoints),1))
title("Thresholded Binary Clustering")
hold on
plot(densityPoints, mean(controlBinary, 2)-mean(aMciBinary,2))
hold off

