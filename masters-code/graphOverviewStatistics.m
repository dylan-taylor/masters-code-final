%% Import data, and preallocate variables.
workingFolder = "G:\_Study\Auckland University\Masters\final_analysis";
participant_data = readtable(strcat(workingFolder, '\participant_demographics.csv'));
vertexCount = 377;

countConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
radialSearchCountConnectomes = zeros(379, 379, length(participant_data.participant_id));
lengthConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
noreflexCountConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));

infoConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
probabilityConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
infoConnectomesNoReflex = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
vertexEntropy = zeros(length(participant_data.participant_id), vertexCount);

countGraphs = cell(length(participant_data.participant_id), 1);

edgeDensities = zeros(length(participant_data.participant_id),1);
totalWeights = zeros(length(participant_data.participant_id),1);

radialSearchEdgeDensities = zeros(length(participant_data.participant_id),1);
radialSearchTotalWeights = zeros(length(participant_data.participant_id),1);
reflexivity = zeros(length(participant_data.participant_id),1);

avgTractLength = zeros(length(participant_data.participant_id),1);

connectedComponents = zeros(length(participant_data.participant_id), 1);

%% Calculate gross metrics on graph structure.
for participantIdx = 1:length(participant_data.participant_id)
    %% Set up variables, import data
    countConnectomes(:, :, participantIdx) = readmatrix(strcat(workingFolder, '\connectome_data\connectome_counts\', participant_data.participant_id{participantIdx}, '_hcpmmp1_connectome_MERGED.csv'));
    lengthConnectomes(:, :, participantIdx) = readmatrix(strcat(workingFolder, '\connectome_data\connectome_lengths\', participant_data.participant_id{participantIdx}, '_hcpmmp1_connectome_length_MERGED.csv'));
    
    radialSearchCountConnectomes(:, :, participantIdx) = readmatrix(strcat(workingFolder, '\connectome_data\connectome_radialsearch\', participant_data.participant_id{participantIdx}, '_hcpmmp1_connectome_radialsearch.csv'));

    %% Derive secondary variables
    noreflexCountConnectomes(:, :, participantIdx) = countConnectomes(:, :, participantIdx) - diag(diag(countConnectomes(:, :, participantIdx)));
    infoConnectomesNoReflex(:, :, participantIdx) = informationConnectivity(noreflexCountConnectomes(:, :, participantIdx));
    [infoConnectomes(:, :, participantIdx), vertexEntropy(participantIdx, :), probabilityConnectomes(:, :, participantIdx)] = informationConnectivity(countConnectomes(:, :, participantIdx));
    countGraphs{participantIdx} = graph(noreflexCountConnectomes(:, :, participantIdx));
    
    %% Calculate overview graph metrics.
    radialSearchEdgeDensities(participantIdx) = edgeDensity(radialSearchCountConnectomes(:, :, participantIdx));
    radialSearchTotalWeights(participantIdx) = totalStrength(radialSearchCountConnectomes(:, :, participantIdx), true);

    edgeDensities(participantIdx) = edgeDensity(countConnectomes(:, :, participantIdx));
    totalWeights(participantIdx) = totalStrength(countConnectomes(:, :, participantIdx), true);

    edgeDensities(participantIdx) = edgeDensity(countConnectomes(:, :, participantIdx));
    totalWeights(participantIdx) = totalStrength(countConnectomes(:, :, participantIdx), true);

    reflexivity(participantIdx) = sum(diag(countConnectomes(:, :, participantIdx)))/radialSearchTotalWeights(participantIdx);
    avgTractLength(participantIdx) = sum(triu(lengthConnectomes(:, :, participantIdx).*countConnectomes(:, :, participantIdx)), 'all')/sum(triu(countConnectomes(:, :, participantIdx)),'all');
    connectedComponents(participantIdx) = unique(conncomp(countGraphs{participantIdx}));
end

%% Write derived secondary variables and graph metrics.

for participantIdx = 1:length(participant_data.participant_id)
    participantFilePath = strcat(workingFolder, '\participant_data\', participant_data.participant_id{participantIdx},'\');
    if not(isfolder(participantFilePath))
        mkdir(participantFilePath)
    end
    writematrix(infoConnectomesNoReflex(:, :, participantIdx), strcat(participantFilePath, participant_data.participant_id{participantIdx},'_infoConnectomeNoReflex.csv') )
    writematrix(infoConnectomes(:, :, participantIdx), strcat(participantFilePath, participant_data.participant_id{participantIdx},'_infoConnectome.csv'))
    writematrix(probabilityConnectomes(:, :, participantIdx), strcat(participantFilePath, participant_data.participant_id{participantIdx},'_probabilityConnectome.csv'))
end

writematrix(edgeDensities, strcat(workingFolder, '\graph_overview_metrics\edgeDensities.csv'));
writematrix(totalWeights, strcat(workingFolder, '\graph_overview_metrics\totalWeights.csv'));

writematrix(radialSearchEdgeDensities, strcat(workingFolder, '\graph_overview_metrics\radialSearchEdgeDensities.csv'));
writematrix(radialSearchTotalWeights, strcat(workingFolder, '\graph_overview_metrics\radialSearchTotalWeights.csv'));

writematrix(reflexivity, strcat(workingFolder, '\graph_overview_metrics\reflexivity.csv'));
writematrix(connectedComponents, strcat(workingFolder, '\graph_overview_metrics\connectedComponents.csv'));
writematrix(avgTractLength, strcat(workingFolder, '\graph_overview_metrics\avgTractLength.csv'));

writematrix(vertexEntropy, strcat(workingFolder, '\vertex_metrics\vertexEntropy.csv'));

%% Derive average strengths
avgStrengths = zeros(length(participant_data.participant_id), 1);
for participantIdx = 1:length(participant_data.participant_id)
    avgStrengths(participantIdx) = mean(vertexStrength(countConnectomes(:, :, participantIdx), true));
end
writematrix(avgStrengths, strcat(workingFolder, '\graph_overview_metrics\avgStrengths.csv'));


