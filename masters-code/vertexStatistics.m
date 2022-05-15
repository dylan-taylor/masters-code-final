%% Import Data
vertexCount = 377;
participantData = readtable('participant_demographics.csv');
vertLabels = readcell('node_labels_MERGED.csv');
edgeDensities = readmatrix('edgeDensities.csv');

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);


%% Input Preallocate
countConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
lengthConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
infoConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
probabilityConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
for iParticipant = 1:size(participantData,1)
    countConnectomes(:,:,iParticipant) = readmatrix(strcat("\final_analysis\connectome_data\connectome_counts\",participantData.participant_id{iParticipant},"_hcpmmp1_connectome_MERGED.csv"));
    lengthConnectomes(:, :, iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_lengths\', participantData.participant_id{iParticipant}, '_hcpmmp1_connectome_length_MERGED.csv'));
    infoConnectomes(:, :, iParticipant) = readmatrix(strcat('.\final_analysis\participant_data\', participantData.participant_id{iParticipant}, '\', participantData.participant_id{iParticipant},'_infoConnectome.csv'));
    probabilityConnectomes(:, :, iParticipant) = readmatrix(strcat('.\final_analysis\participant_data\', participantData.participant_id{iParticipant}, '\', participantData.participant_id{iParticipant},'_probabilityConnectome.csv'));
end

%% Create centrality vectors
vertexStrengths = zeros(size(participantData,1), vertexCount);

invCountCloseness = zeros(size(participantData,1), vertexCount);
lengthCloseness = zeros(size(participantData,1), vertexCount);
infoInCloseness = zeros(size(participantData,1), vertexCount);
infoOutCloseness = zeros(size(participantData,1), vertexCount);

invCountBetweenness = zeros(size(participantData,1), vertexCount);
lengthBetweenness = zeros(size(participantData,1), vertexCount);
infoBetweenness = zeros(size(participantData,1), vertexCount);

countEigenvector = zeros(size(participantData,1), vertexCount);
vertexEntropy = zeros(size(participantData,1), vertexCount);
for iParticipant = 1:size(participantData,1)
    vertexStrengths(iParticipant,:) = vertexStrength(countConnectomes(:,:,iParticipant), true);
    
    invConnectome = 1./countConnectomes(:,:,iParticipant);
    invConnectome(isinf(invConnectome)) = 0;
    countG = graph(countConnectomes(:,:,iParticipant));
    invCountG = graph(invConnectome);
    lengthG = graph(lengthConnectomes(:, :, iParticipant));
    infoG = digraph(infoConnectomes(:, :, iParticipant));
    
    invCountCloseness(iParticipant, :) = centrality(invCountG, 'closeness', 'Cost', invCountG.Edges.Weight);
    lengthCloseness(iParticipant, :) = centrality(lengthG, 'closeness', 'Cost', lengthG.Edges.Weight);
    infoInCloseness(iParticipant, :) = centrality(infoG, 'incloseness', 'Cost', infoG.Edges.Weight);
    infoOutCloseness(iParticipant, :) = centrality(infoG, 'outcloseness', 'Cost', infoG.Edges.Weight);
    
    invCountBetweenness(iParticipant, :) = centrality(invCountG, 'betweenness', 'Cost', invCountG.Edges.Weight);
    lengthBetweenness(iParticipant, :) = centrality(lengthG, 'betweenness', 'Cost', lengthG.Edges.Weight);
    infoBetweenness(iParticipant, :) = centrality(infoG, 'betweenness', 'Cost', infoG.Edges.Weight);
    
    countEigenvector(iParticipant, :) = centrality(countG, 'eigenvector', 'Importance', countG.Edges.Weight);
    
    [~, vertexEntropy(iParticipant, :), ~] = informationConnectivity(countConnectomes(:,:,iParticipant));
end

%% Statistical testing of each vertex.
% Log transform
invCountBetweennessLog = log(invCountBetweenness+1);
lengthBetweennessLog = log(lengthBetweenness+1);
infoBetweennessLog = log(infoBetweenness+1);

countEigenvectorLog = log(countEigenvector);

vertexStrengthsTest = ones(1, vertexCount);

vertexReflexiveTest = ones(1, vertexCount);

invCountClosenessTest = ones(1, vertexCount);
lengthClosenessTest = ones(1, vertexCount);
infoInClosenessTest = ones(1, vertexCount);
infoOutClosenessTest = ones(1, vertexCount);

invCountBetweennessTest = ones(1, vertexCount);
lengthBetweennessTest = ones(1, vertexCount);
infoBetweennessTest = ones(1, vertexCount);

countEigenvectorTest = ones(1, vertexCount);
vertexEntropyTest = ones(1, vertexCount);

for iVertex = 1:vertexCount
    [~ , vertexStrengthsTest(iVertex)] = ttest2(vertexStrengths(controls, iVertex), vertexStrengths(aMci, iVertex));
    [~, vertexReflexiveTest(iVertex)] = ttest2(countConnectomes(iVertex, iVertex, controls), countConnectomes(iVertex, iVertex, aMci));
    [~ , invCountClosenessTest(iVertex)] = ttest2(invCountCloseness(controls, iVertex), invCountCloseness(aMci, iVertex));
    [~ , lengthClosenessTest(iVertex)] = ttest2(lengthCloseness(controls, iVertex), lengthCloseness(aMci, iVertex));
    [~ , infoInClosenessTest(iVertex)] = ttest2(infoInCloseness(controls, iVertex), infoInCloseness(aMci, iVertex));
    [~ , infoOutClosenessTest(iVertex)] = ttest2(infoOutCloseness(controls, iVertex), infoOutCloseness(aMci, iVertex));
    
    [~ , invCountBetweennessTest(iVertex)] = ttest2(invCountBetweennessLog(controls, iVertex), invCountBetweennessLog(aMci, iVertex));
    [~ , lengthBetweennessTest(iVertex)] = ttest2(lengthBetweennessLog(controls, iVertex), lengthBetweennessLog(aMci, iVertex));
    [~ , infoBetweennessTest(iVertex)] = ttest2(infoBetweennessLog(controls, iVertex), infoBetweennessLog(aMci, iVertex));
    
    [~ , countEigenvectorTest(iVertex)] = ttest2(countEigenvectorLog(controls, iVertex), countEigenvectorLog(aMci, iVertex));
    
    [~, vertexEntropyTest(iVertex)] = ttest2(vertexEntropy(controls, iVertex), vertexEntropy(aMci, iVertex));
end

%% BH-FDR Correction
criticalValue = 0.05;
P_k = ((1:vertexCount)./vertexCount)*criticalValue;

vertexStrengthsCritical = P_k(find(sort(vertexStrengthsTest)<P_k, 1, 'last'));

invCountClosenessCritical = P_k(find(sort(invCountClosenessTest)<P_k, 1, 'last'));
lengthClosenessCritical = P_k(find(sort(lengthClosenessTest)<P_k, 1, 'last'));
infoInClosenessCritical = P_k(find(sort(infoInClosenessTest)<P_k, 1, 'last'));
infoOutClosenessCritical = P_k(find(sort(infoOutClosenessTest)<P_k, 1, 'last'));
    
invCountBetweennessCritical = P_k(find(sort(invCountBetweennessTest)<P_k, 1, 'last'));
lengthBetweennessCritical = P_k(find(sort(lengthBetweennessTest)<P_k, 1, 'last'));
infoBetweennessCritical = P_k(find(sort(infoBetweennessTest)<P_k, 1, 'last'));

countEigenvectorCritical = P_k(find(sort(countEigenvectorTest)<P_k, 1, 'last'));

vertexEntropyCritical = P_k(find(sort(vertexEntropyTest)<P_k, 1, 'last'));

if isempty(vertexStrengthsCritical)
    vertexStrengthsCritical = 0;
end
if isempty(invCountClosenessCritical)
    invCountClosenessCritical = 0;
end
if isempty(lengthClosenessCritical)
    lengthClosenessCritical = 0;
end
if isempty(infoInClosenessCritical)
    infoInClosenessCritical = 0;
end
if isempty(infoOutClosenessCritical)
    infoOutClosenessCritical = 0;
end
if isempty(invCountBetweennessCritical)
    invCountBetweennessCritical = 0;
end
if isempty(lengthBetweennessCritical)
    lengthBetweennessCritical = 0;
end
if isempty(infoBetweennessCritical)
    infoBetweennessCritical = 0;
end
if isempty(countEigenvectorCritical)
    countEigenvectorCritical = 0;
end
if isempty(vertexEntropyCritical)
    vertexEntropyCritical = 0;
end

vertexStrengthsSig = vertexStrengthsTest < vertexStrengthsCritical;

invCountClosenessSig = invCountClosenessTest < invCountClosenessCritical;
lengthClosenessSig = lengthClosenessTest < lengthClosenessCritical;
infoInClosenessSig = infoInClosenessTest < infoInClosenessCritical;
infoOutClosenessSig = infoOutClosenessTest < infoOutClosenessCritical;

invCountBetweennessSig = invCountBetweennessTest < invCountBetweennessCritical;
lengthBetweennessSig = lengthBetweennessTest < lengthBetweennessCritical;
infoBetweennessSig = infoBetweennessTest < infoBetweennessCritical;

countEigenvectorSig = countEigenvectorTest < countEigenvectorCritical;

vertexEntropySig = vertexEntropyTest < vertexEntropyCritical;
mean(vertexEntropy(controls, vertexEntropySig));
mean(vertexEntropy(aMci, vertexEntropySig));
std(vertexEntropy(controls, vertexEntropySig));
std(vertexEntropy(aMci, vertexEntropySig));
[~,~,~,Stat] = ttest2(vertexEntropy(controls, vertexEntropySig),vertexEntropy(aMci, vertexEntropySig));

%% Testing the "Total Betweenness" as done in (Dick et al., 2018)
meanInvCountCloseness = mean(invCountCloseness,2);
meanLengthCloseness = mean(lengthCloseness,2);
meanInfoInCloseness = mean(infoInCloseness,2);
meanInfoOutCloseness = mean(infoOutCloseness,2);

meanInvCountBetweeness = mean(invCountBetweenness,2);
meanLengthBetweeness = mean(lengthBetweenness,2);
meanInfoBetweeness = mean(infoBetweenness,2);

meanVertexEntropy = mean(vertexEntropy,2);

writematrix(meanInvCountCloseness, '.\final_analysis\graph_vertex_metrics\meanInvCountCloseness.csv');
writematrix(meanLengthCloseness, '.\final_analysis\graph_vertex_metrics\meanLengthCloseness.csv');
writematrix(meanInfoInCloseness, '.\final_analysis\graph_vertex_metrics\meanInfoInCloseness.csv');
writematrix(meanInfoOutCloseness, '.\final_analysis\graph_vertex_metrics\meanInfoOutCloseness.csv');

writematrix(meanInvCountBetweeness, '.\final_analysis\graph_vertex_metrics\meanInvCountBetweeness.csv');
writematrix(meanLengthBetweeness, '.\final_analysis\graph_vertex_metrics\meanLengthBetweeness.csv');
writematrix(meanInfoBetweeness, '.\final_analysis\graph_vertex_metrics\meanInfoBetweeness.csv');

writematrix(meanVertexEntropy, '.\final_analysis\graph_vertex_metrics\meanVertexEntropy.csv');

writematrix( [squeeze(countConnectomes(10, 10, :)) squeeze(countConnectomes(106, 106, :)) squeeze(countConnectomes(213, 213, :))], '.\final_analysis\graph_vertex_metrics\reflexiveSignificant.csv')
