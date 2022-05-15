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
writematrix(densityPoints, '.\final_analysis\graph_threshold_overview\densityPoints.csv')
%% Preallocate output matrices
totalWeightsThreshold = zeros(size(participantData,1), densityCount);

for iParticipant = 1:size(participantData,1)
    disp(iParticipant)
    participantThreshGraphs = createThresholdGraphs(countConnectomes(:,:,iParticipant), densityPoints);
    parfor kDensity = 1:densityCount
        totalWeightThreshold(iParticipant, kDensity) = sum(participantThreshGraphs(:, :, kDensity), 'all')/2
    end
    writematrix(totalWeightThreshold, '.\final_analysis\graph_threshold_overview\totalWeightThreshold.csv')   
end