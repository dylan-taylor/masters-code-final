% Script requires montecluster package (-DETAILS OF HOW TO FIND HERE-)

%% Import/Setup general details
participantData = readtable('participant_demographics.csv');
densityPoints = readmatrix('.\final_analysis\graph_threshold_overview\densityPoints.csv');

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

invCountCplThreshIntegral = zeros(size(participantData,1),1);
lengthCplThreshIntegral = zeros(size(participantData,1),1);
infoCplThreshIntegral = zeros(size(participantData,1),1);
invCountEglobThreshIntegral = zeros(size(participantData,1),1);
lengthEglobThreshIntegral = zeros(size(participantData,1),1);
infoEglobThreshIntegral = zeros(size(participantData,1),1);
countClusterThreshIntegral = zeros(size(participantData,1),1);
countAssortativityThreshIntegral = zeros(size(participantData,1),1);
entropyRateThreshIntegral = zeros(size(participantData,1),1);

for iParticipant = 1:size(participantData,1)
    invCountCplThreshIntegral(iParticipant) = trapz(densityPoints, invCountCplThresh(iParticipant, :));
    lengthCplThreshIntegral(iParticipant) = trapz(densityPoints, lengthCplThresh(iParticipant, :));
    infoCplThreshIntegral(iParticipant) = trapz(densityPoints(26:end), infoCplThresh(iParticipant, 26:end));
    invCountEglobThreshIntegral(iParticipant) = trapz(densityPoints, invCountEglobThresh(iParticipant, :));
    lengthEglobThreshIntegral(iParticipant) = trapz(densityPoints, lengthEglobThresh(iParticipant, :));
    infoEglobThreshIntegral(iParticipant) = trapz(densityPoints(26:end), infoEglobThresh(iParticipant, 26:end));
    countClusterThreshIntegral(iParticipant) = trapz(densityPoints, countClusterThresh(iParticipant, :));
    countAssortativityThreshIntegral(iParticipant) = trapz(densityPoints, countAssortativityThresh(iParticipant, :));
    entropyRateThreshIntegral(iParticipant) = trapz(densityPoints, entropyRateThresh(iParticipant, :));
end
writematrix(invCountCplThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\invCountCplThreshIntegral.csv');
writematrix(lengthCplThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\lengthCplThreshIntegral.csv');
writematrix(infoCplThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\infoCplThreshIntegral.csv');
writematrix(invCountEglobThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\invCountEglobThreshIntegral.csv');
writematrix(lengthEglobThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\lengthEglobThreshIntegral.csv');
writematrix(infoEglobThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\infoEglobThreshIntegral.csv');
writematrix(countClusterThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\countClusterThreshIntegral.csv');
writematrix(countAssortativityThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\countAssortativityThreshIntegral.csv');
writematrix(entropyRateThreshIntegral, '.\final_analysis\graph_threshold_metrics\integral\entropyRateThreshIntegral.csv');

%% Import binarized statisitics
cplBin = readmatrix('.\final_analysis\graph_binary_metrics\cplThresh.csv');
infoCplBin = readmatrix('.\final_analysis\graph_binary_metrics\infoCplThresh.csv');
eglobBin = readmatrix('.\final_analysis\graph_binary_metrics\eglobThresh.csv');
infoEglobBin = readmatrix('.\final_analysis\graph_binary_metrics\infoEglobThresh.csv');
countClusterBin = readmatrix('.\final_analysis\graph_binary_metrics\clusterThresh.csv');
countAssortativityBin = readmatrix('.\final_analysis\graph_binary_metrics\assortativityThresh.csv');
entropyRateBin = readmatrix('.\final_analysis\graph_binary_metrics\entropyRateThresh.csv');

cplBinIntegral = zeros(size(participantData,1),1);
infoCplBinIntegral = zeros(size(participantData,1),1);
eglobBinIntegral = zeros(size(participantData,1),1);
infoEglobBinIntegral = zeros(size(participantData,1),1);
clusterBinIntegral = zeros(size(participantData,1),1);
assortativityBinIntegral = zeros(size(participantData,1),1);
entropyRateBinIntegral = zeros(size(participantData,1),1);

for iParticipant = 1:size(participantData,1)
    cplBinIntegral(iParticipant) = trapz(densityPoints, cplBin(iParticipant, :));
    infoCplBinIntegral(iParticipant) = trapz(densityPoints(26:end), infoCplBin(iParticipant, 26:end));
    eglobBinIntegral(iParticipant) = trapz(densityPoints, eglobBin(iParticipant, :));
    infoEglobBinIntegral(iParticipant) = trapz(densityPoints(26:end), infoEglobBin(iParticipant, 26:end));
    clusterBinIntegral(iParticipant) = trapz(densityPoints, countClusterBin(iParticipant, :));
    assortativityBinIntegral(iParticipant) = trapz(densityPoints, countAssortativityBin(iParticipant, :));
    entropyRateBinIntegral(iParticipant) = trapz(densityPoints, entropyRateBin(iParticipant, :));
end
writematrix(cplBinIntegral, '.\final_analysis\graph_binary_metrics\integral\cplBinIntegral.csv');
writematrix(infoCplBinIntegral, '.\final_analysis\graph_binary_metrics\integral\infoCplBinIntegral.csv');
writematrix(eglobBinIntegral, '.\final_analysis\graph_binary_metrics\integral\eglobBinIntegral.csv');
writematrix(infoEglobBinIntegral, '.\final_analysis\graph_binary_metrics\integral\infoEglobBinIntegral.csv');
writematrix(clusterBinIntegral, '.\final_analysis\graph_binary_metrics\integral\clusterBinIntegral.csv');
writematrix(assortativityBinIntegral, '.\final_analysis\graph_binary_metrics\integral\assortativityBinIntegral.csv');
writematrix(entropyRateBinIntegral, '.\final_analysis\graph_binary_metrics\integral\entropyRateBinIntegral.csv');
