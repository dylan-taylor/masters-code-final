n = 1;
N = 30;
vertexCount = 377;
participantData = readtable('participant_demographics.csv');

% Pre-assign matrices where possible
countConnectomes = zeros(vertexCount, vertexCount, length(participantData.participant_id));
binarisedFlow = zeros(vertexCount, vertexCount, length(participantData.participant_id));
avgBinarisedFlow = zeros(length(participantData.participant_id), 1);
% Import and derive the metrics from the connectomes
for iParticipant = 1:length(participantData.participant_id)  
    % Read in connectome for participant i
    countConnectomes(:,:,iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_counts\', participantData.participant_id{iParticipant}, '_hcpmmp1_connectome_MERGED.csv'));
end

parfor iParticipant = n:N
    subjectFile = strcat("./final_analysis/connectome_data/max_flow_binary/", participantData.participant_id{iParticipant}, '_maxflowBinary.csv');
    binarisedFlow(:, :, iParticipant) = maxFlowMatrix(countConnectomes(:,:,iParticipant)>207);
    participantBinarisedFlow = binarisedFlow(:, :, iParticipant);
    avgBinarisedFlow(iParticipant) = mean(participantBinarisedFlow(triu(ones(vertexCount))>0));
    writematrix(participantBinarisedFlow, subjectFile)
end

writematrix(avgBinarisedFlow, "./final_analysis/graph_threshold_overview/avgBinarisedFlow.csv")