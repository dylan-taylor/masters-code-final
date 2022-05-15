%% Import Data
vertexCount = 377;
participantData = readtable('participant_demographics.csv');
vertLabels = readcell('node_labels_MERGED.csv');
edgeDensity = readmatrix('edgeDensities.csv');

%% Input Preallocate
countConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
lengthConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
infoConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
probabilityConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));


for iParticipant = 1:size(participantData,1)
    subjectFile = participantData.participant_id{iParticipant};
    countConnectomes(:,:,iParticipant) = readmatrix(strcat("\final_analysis\connectome_data\connectome_counts\",participantData.participant_id{iParticipant},"_hcpmmp1_connectome_MERGED.csv"));
    lengthConnectomes(:, :, iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_lengths\', participantData.participant_id{iParticipant}, '_hcpmmp1_connectome_length_MERGED.csv'));
end

%% Create threshold graphs for each participant.
minDensity = (vertexCount-1)/(vertexCount*(vertexCount-1)/2);
maxDensity = min(edgeDensity);
densityStep = 0.001;

densityPoints = minDensity:densityStep:maxDensity;
densityCount = length(densityPoints);

%% Results Preallocate
cplThresh = zeros(size(participantData,1), densityCount);
infoCplThresh = zeros(size(participantData,1), densityCount);
eglobThresh = zeros(size(participantData,1), densityCount);
infoEglobThresh = zeros(size(participantData,1), densityCount);
clusterThresh = zeros(size(participantData,1), densityCount);
assortativityThresh = zeros(size(participantData,1), densityCount);
entropyRateThresh = zeros(size(participantData,1), densityCount);

for iParticipant = 1:30
    disp(strcat("Starting Participant - ", participantData.participant_id{iParticipant}));
    disp("Thresholding");
    participantThreshGraphs = createThresholdGraphs(countConnectomes(:,:,iParticipant), densityPoints);
    participantThreshGraphs = participantThreshGraphs>0;
    parfor kDensity = 1:densityCount
        %% CPL and Eglob
        % Measure: Inverse of Count
        disp(num2str(kDensity/densityCount));
        % Measure: Steps
        [cplThresh(iParticipant, kDensity), eglobThresh(iParticipant, kDensity)] = characteristicPathLength(participantThreshGraphs(:,:,kDensity));

        % Measure: Information
        infoThreshold = informationConnectivity(participantThreshGraphs(:,:,kDensity));
        [infoCplThresh(iParticipant, kDensity), infoEglobThresh(iParticipant, kDensity)] = characteristicPathLength(infoThreshold);      

        %% Clustering Coefficient
        clusterThresh(iParticipant, kDensity) = graphClusteringCoefficient(participantThreshGraphs(:, :, kDensity));

        %% Assortativity Coefficient
        assortativityThresh(iParticipant, kDensity) = graphAssortativityCoefficient(participantThreshGraphs(:, :, kDensity));

        %% Entropy Rate
        [~, ~,probThreshold] = informationConnectivity(participantThreshGraphs(:, :, kDensity));
        entropyRateThresh(iParticipant, kDensity) = entropyRate(probThreshold);
    end
    writematrix(cplThresh, '.\final_analysis\graph_binary_metrics\cplThresh.csv')
    writematrix(infoCplThresh, '.\final_analysis\graph_binary_metrics\infoCplThresh.csv')
    writematrix(eglobThresh, '.\final_analysis\graph_binary_metrics\eglobThresh.csv')
    writematrix(infoEglobThresh, '.\final_analysis\graph_binary_metrics\infoEglobThresh.csv')
    writematrix(clusterThresh, '.\final_analysis\graph_binary_metrics\clusterThresh.csv')
    writematrix(assortativityThresh, '.\final_analysis\graph_binary_metrics\assortativityThresh.csv')
    writematrix(entropyRateThresh, '.\final_analysis\graph_binary_metrics\entropyRateThresh.csv')   
end

