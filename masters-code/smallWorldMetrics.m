%% Import Data
vertexCount = 377;
participantData = readtable('participant_demographics.csv');

%% Input Preallocate
countConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));

for iParticipant = 1:size(participantData,1)
    countConnectomes(:,:,iParticipant) = readmatrix(strcat("\final_analysis\connectome_data\connectome_counts\",participantData.participant_id{iParticipant},"_hcpmmp1_connectome_MERGED.csv"));
end

smallworldCoeffs = zeros(length(participantData.participant_id), 1);
parfor iParticipant = 1:length(participantData.participant_id)
    disp(iParticipant)
    smallworldCoeffs(iParticipant) = graphSmallWorld(countConnectomes(:,:,iParticipant), 100);
end
writematrix(smallworldCoeffs, '.\final_analysis\graph_weighted_metrics\smallworldCoeffs.csv')