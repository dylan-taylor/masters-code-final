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

% Slice points into multiple files (computer memory crash, might work on larger RAM?)
densityPoints = minDensity:densityStep:maxDensity;
densityCount = length(densityPoints);

%% Results Preallocate
invCountCplThresh = zeros(size(participantData,1), densityCount);
lengthCplThresh = zeros(size(participantData,1), densityCount);
infoCplThresh = zeros(size(participantData,1), densityCount);
invCountEglobThresh = zeros(size(participantData,1), densityCount);
lengthEglobThresh = zeros(size(participantData,1), densityCount);
infoEglobThresh = zeros(size(participantData,1), densityCount);
countClusterThresh = zeros(size(participantData,1), densityCount);
countAssortativityThresh = zeros(size(participantData,1), densityCount);
entropyRateThresh = zeros(size(participantData,1), densityCount);

for iParticipant = 1:size(participantData,1)
    disp(strcat("Starting Participant - ", participantData.participant_id{iParticipant}));
    disp("Thresholding");
    participantThreshGraphs = createThresholdGraphs(countConnectomes(:,:,iParticipant), densityPoints);
    parfor kDensity = 1:densityCount
        %% CPL and Eglob
        % Measure: Inverse of Count
        disp(num2str(kDensity/densityCount));
        invCountConnectome = 1./participantThreshGraphs(:, :, kDensity);
        invCountConnectome(isinf(invCountConnectome)) = 0;
        [invCountCplThresh(iParticipant, kDensity), invCountEglobThresh(iParticipant, kDensity)] = characteristicPathLength(invCountConnectome);

        % Measure: Length
        lengthThreshold = lengthConnectomes(:, :, iParticipant).*(participantThreshGraphs(:,:,kDensity)>0);
        [lengthCplThresh(iParticipant, kDensity), lengthEglobThresh(iParticipant, kDensity)] = characteristicPathLength(lengthThreshold);

        % Measure: Information
        infoThreshold = informationConnectivity(participantThreshGraphs(:,:,kDensity));
        [infoCplThresh(iParticipant, kDensity), infoEglobThresh(iParticipant, kDensity)] = characteristicPathLength(infoThreshold);      

        %% Clustering Coefficient
        countClusterThresh(iParticipant, kDensity) = graphClusteringCoefficient(participantThreshGraphs(:, :, kDensity));

        %% Assortativity Coefficient
        countAssortativityThresh(iParticipant, kDensity) = graphAssortativityCoefficientWeighted(participantThreshGraphs(:, :, kDensity));

        %% Entropy Rate
        [~, ~,probThreshold] = informationConnectivity(participantThreshGraphs(:, :, kDensity));
        entropyRateThresh(iParticipant, kDensity) = entropyRate(probThreshold);
    end
    writematrix(invCountCplThresh, '.\final_analysis\graph_threshold_metrics\invCountCplThresh.csv')
    writematrix(lengthCplThresh, '.\final_analysis\graph_threshold_metrics\lengthCplThresh.csv')
    writematrix(infoCplThresh, '.\final_analysis\graph_threshold_metrics\infoCplThresh.csv')
    writematrix(invCountEglobThresh, '.\final_analysis\graph_threshold_metrics\invCountEglobThresh.csv')
    writematrix(lengthEglobThresh, '.\final_analysis\graph_threshold_metrics\lengthEglobThresh.csv')
    writematrix(infoEglobThresh, '.\final_analysis\graph_threshold_metrics\infoEglobThresh.csv')
    writematrix(countClusterThresh, '.\final_analysis\graph_threshold_metrics\countClusterThresh.csv')
    writematrix(countAssortativityThresh, '.\final_analysis\graph_threshold_metrics\countAssortativityThresh.csv')
    writematrix(entropyRateThresh, '.\final_analysis\graph_threshold_metrics\entropyRateThresh.csv')   
end

