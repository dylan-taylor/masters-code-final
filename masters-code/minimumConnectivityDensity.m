%% Import data, and preallocate variables.
participantData = readtable('.\final_analysis\participant_demographics.csv');
vertexCount = 377;

countConnectomes = zeros(vertexCount, vertexCount, length(participantData.participant_id));
minConnDensity = zeros(length(participantData.participant_id),1);
%% Calculate gross metrics on graph structure.
for iParticipant = 1:length(participantData.participant_id)
    %% Import countConnectomes, derive min densities
    countConnectomes(:, :, iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_counts\', participantData.participant_id{iParticipant}, '_hcpmmp1_connectome_MERGED.csv'));
    minConnDensity(iParticipant) = minConnectedDensity(countConnectomes(:, :, iParticipant));
end
writematrix(minConnDensity, '.\final_analysis\graph_overview_metrics\minConnDensity.csv');