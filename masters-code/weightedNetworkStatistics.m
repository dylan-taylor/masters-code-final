%% Import data, and preallocate variables.
participant_data = readtable('.\final_analysis\participant_demographics.csv');
vertexCount = 377;

countConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
lengthConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
noreflexCountConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));

infoConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
infoConnectomesNoReflex = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
probabilityConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));

countCpl = zeros(length(participant_data.participant_id), 1);
lengthCpl = zeros(length(participant_data.participant_id), 1);
infoCpl = zeros(length(participant_data.participant_id), 1);
infoNoReflexCpl = zeros(length(participant_data.participant_id), 1);

countEglob = zeros(length(participant_data.participant_id), 1);
lengthEglob = zeros(length(participant_data.participant_id), 1);
infoEglob = zeros(length(participant_data.participant_id), 1);
infoNoReflexEglob = zeros(length(participant_data.participant_id), 1);

avgSearchInformation = zeros(length(participant_data.participant_id), 1);
avgLengthSearchInformation = zeros(length(participant_data.participant_id), 1);

avgPathTrans = zeros(length(participant_data.participant_id), 1);

participantEntropyRate = zeros(length(participant_data.participant_id), 1);

countWeightedCluster = zeros(length(participant_data.participant_id), 1);
vertWeightedCluster = zeros(length(participant_data.participant_id), vertexCount);

countCluster = zeros(length(participant_data.participant_id), 1);
vertCluster = zeros(length(participant_data.participant_id), vertexCount);

countWeightedAssortativity = zeros(length(participant_data.participant_id), 1);
countAssortativity = zeros(length(participant_data.participant_id), 1);

parfor participantIdx = 1:length(participant_data.participant_id)
    %% Import connectomes and derive secondary connectomes
    disp(participantIdx)
    countConnectomes(:, :, participantIdx) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_counts\', participant_data.participant_id{participantIdx}, '_hcpmmp1_connectome_MERGED.csv'));
    lengthConnectomes(:, :, participantIdx) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_lengths\', participant_data.participant_id{participantIdx}, '_hcpmmp1_connectome_length_MERGED.csv'));
    infoConnectomes(:, :, participantIdx) = readmatrix(strcat('.\final_analysis\participant_data\', participant_data.participant_id{participantIdx}, '\', participant_data.participant_id{participantIdx},  '_infoConnectome.csv'));
    probabilityConnectomes(:, :, participantIdx) = readmatrix(strcat('.\final_analysis\participant_data\', participant_data.participant_id{participantIdx}, '\', participant_data.participant_id{participantIdx},  '_probabilityConnectome.csv'));
    infoConnectomesNoReflex(:, :, participantIdx) = readmatrix(strcat('.\final_analysis\participant_data\', participant_data.participant_id{participantIdx}, '\', participant_data.participant_id{participantIdx}, '_infoConnectomeNoReflex.csv'));
    
    invCountConnectome = 1./countConnectomes(:, :, participantIdx);
    invCountConnectome(isinf(invCountConnectome)) = 0;
    
    %% Calculate the characteristic path length under different length measures
    [countCpl(participantIdx), countEglob(participantIdx)] = characteristicPathLength(invCountConnectome);
    [lengthCpl(participantIdx), lengthEglob(participantIdx)] = characteristicPathLength(lengthConnectomes(:, :, participantIdx));
    [infoCpl(participantIdx), infoEglob(participantIdx)] = characteristicPathLength(infoConnectomes(:, :, participantIdx));
    [infoNoReflexCpl(participantIdx), infoNoReflexEglob(participantIdx)] = characteristicPathLength(infoConnectomesNoReflex(:, :, participantIdx));
    
    %% Clustering Coefficients
    [countWeightedCluster(participantIdx), vertWeightedCluster(participantIdx,:)] = graphClusteringCoefficient(countConnectomes(:, :, participantIdx));
    [countCluster(participantIdx), vertCluster(participantIdx,:)] = graphClusteringCoefficient(countConnectomes(:, :, participantIdx)>0);

    %% Search information
    searchInfo = searchInformation(invCountConnectome, probabilityConnectomes(:, :, participantIdx));
    avgSearchInformation(participantIdx) = mean(searchInfo(~(eye(vertexCount))));
    
    searchInfoLengths = searchInformation(lengthConnectomes(:, :, participantIdx), probabilityConnectomes(:, :, participantIdx));
    avgLengthSearchInformation(participantIdx) = mean(searchInfoLengths(~(eye(vertexCount))));

    %% Path transitivity
    pathTrans = pathTransitivity(countConnectomes(:, :, participantIdx), invCountConnectome);
    avgPathTrans(participantIdx) = mean(searchInfo(~(eye(vertexCount))));
    
    %% Entropy rate
    participantEntropyRate(participantIdx) = entropyRate(probabilityConnectomes(:,:,participantIdx));
    
    %% Assortativity Coefficients
    countWeightedAssortativity(participantIdx) = graphAssortativityCoefficientWeighted(countConnectomes(:, :, participantIdx));
    countAssortativity(participantIdx) = graphAssortativityCoefficient(countConnectomes(:, :, participantIdx));
    
end

writematrix(countCpl, '.\final_analysis\graph_weighted_metrics\countCpl.csv');
writematrix(lengthCpl, '.\final_analysis\graph_weighted_metrics\lengthCpl.csv');
writematrix(infoCpl, '.\final_analysis\graph_weighted_metrics\infoCpl.csv');
writematrix(infoNoReflexCpl, '.\final_analysis\graph_weighted_metrics\infoNoReflexCpl.csv');

writematrix(countEglob, '.\final_analysis\graph_weighted_metrics\countEglob.csv');
writematrix(lengthEglob, '.\final_analysis\graph_weighted_metrics\lengthEglob.csv');
writematrix(infoEglob, '.\final_analysis\graph_weighted_metrics\infoEglob.csv');
writematrix(infoNoReflexEglob, '.\final_analysis\graph_weighted_metrics\infoNoReflexEglob.csv');

writematrix(countWeightedCluster, '.\final_analysis\graph_weighted_metrics\countWeightedCluster.csv');
writematrix(countCluster, '.\final_analysis\graph_weighted_metrics\countCluster.csv');

writematrix(vertWeightedCluster, '.\final_analysis\graph_weighted_metrics\vertWeightedCluster.csv');
writematrix(vertCluster, '.\final_analysis\graph_weighted_metrics\vertCluster.csv');

writematrix(avgSearchInformation, '.\final_analysis\graph_weighted_metrics\avgSearchInformation.csv');
writematrix(avgLengthSearchInformation, '.\final_analysis\graph_weighted_metrics\avgLengthSearchInformation.csv');

writematrix(avgPathTrans, '.\final_analysis\graph_weighted_metrics\avgPathTransitivity.csv');

writematrix(participantEntropyRate, '.\final_analysis\graph_weighted_metrics\entropyRate.csv');

writematrix(countWeightedAssortativity, '.\final_analysis\graph_weighted_metrics\countWeightedAssortativity.csv');
writematrix(countAssortativity, '.\final_analysis\graph_weighted_metrics\countAssortativity.csv');