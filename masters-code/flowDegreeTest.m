vertexCount = 377;
participantData = readtable('participant_demographics.csv');
% Pre-assign matrices where possible
countConnectomes = zeros(vertexCount, vertexCount, length(participantData.participant_id));
lengthConnectomes = zeros(vertexCount, vertexCount, length(participantData.participant_id));
minDegreeMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));
maxFlowMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);

% Import and derive the metrics from the connectomes
for iParticipant = 1:length(participantData.participant_id)
    subjectFile = strcat('.\final_analysis\connectome_data\maxflow\', participantData.participant_id{iParticipant}, '\');
    maxFlowMatrix(:, :, iParticipant) = readmatrix(strcat(subjectFile, participantData.participant_id{iParticipant}, '_maxflow.csv'));
end

for iParticipant = 1:length(participantData.participant_id)  
    countConnectomes(:,:,iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_counts\', participantData.participant_id{iParticipant}, '_hcpmmp1_connectome_MERGED.csv'));
end

for iParticipant = 1:length(participantData.participant_id)
    vertStrength = vertexStrength(countConnectomes(:,:,iParticipant), false);
    for sVertex = 1:vertexCount
        for tVertex = 1:vertexCount
            minDegreeMatrix(sVertex, tVertex, iParticipant) = min([vertStrength(sVertex) vertStrength(tVertex)]);
        end
    end
end

%% Test correlation between the two methods of calculation.
corMatrix = zeros(vertexCount, vertexCount);
corPvalMatrix = zeros(vertexCount, vertexCount);

for sVertex = 1:vertexCount
    for tVertex = 1:vertexCount
        if sVertex ~= tVertex
            [corMatrix(sVertex, tVertex), corPvalMatrix(sVertex, tVertex)]= corr(squeeze(minDegreeMatrix(sVertex, tVertex, :)), squeeze(maxFlowMatrix(sVertex, tVertex, :)));
        end
    end
end

%% Percent significant.
sigM = corPvalMatrix<(0.05/(vertexCount*(vertexCount-1)/2));
sum(sigM(triu(ones(vertexCount),1)>0))/(vertexCount*(vertexCount-1)/2);

%% Create average min strength metric for testing.
avgMinStrength = zeros(length(participantData.participant_id), 1);
for iParticipant = 1:length(participantData.participant_id)
    participantMinDegree = minDegreeMatrix(:,:,iParticipant);
    avgMinStrength(iParticipant) = mean(participantMinDegree(triu(ones(377), 1)>0));
end
writematrix(avgMinStrength, '.\final_analysis\graph_weighted_metrics\avgMinStrength.csv')

%% Tests for differences in all edges with the min strength metric.
pvalsMinDeg = ones(vertexCount, vertexCount);

for sVertex = 1:vertexCount
   for tVertex = sVertex+1:vertexCount
       if sVertex ~= tVertex
           controlsFlow = squeeze(minDegreeMatrix(sVertex, tVertex, controls));
           aMcisFlow = squeeze(minDegreeMatrix(sVertex, tVertex, aMci));
           [~, pvalsMinDeg(sVertex, tVertex)] = ttest(controlsFlow, aMcisFlow);
       end
   end
end

sigMinDeg = pvalsMinDeg<(0.05/(vertexCount*(vertexCount-1)/2));

%% Tests for the difference between theoretical maxflow and maxflow.

participantSlacks = zeros(vertexCount, vertexCount, length(participantData.participant_id));

avgSlack = zeros(length(participantData.participant_id), 1);
for iParticipant = 1:length(participantData.participant_id)
    participantSlacks(:, :, iParticipant) = minDegreeMatrix(:,:,iParticipant)-maxFlowMatrix(:, :, iParticipant);
    partSlack = participantSlacks(:, :, iParticipant);
    avgSlack(iParticipant) = mean(partSlack(triu(ones(377), 1)>0));
end
writematrix(avgSlack, '.\final_analysis\graph_weighted_metrics\avgSlack.csv')

participantSlacks = minDegreeMatrix - maxFlowMatrix;
meanSlackDifference = zeros(vertexCount, vertexCount);
pvalsSlack = ones(vertexCount, vertexCount);
for sVertex = 1:vertexCount
   for tVertex = sVertex+1:vertexCount
       controlsSlack = squeeze(participantSlacks(sVertex, tVertex, controls));
       aMcisSlack = squeeze(participantSlacks(sVertex, tVertex, aMci));
       meanSlackDifference(sVertex, tVertex) = mean(controlsSlack) - mean(aMcisSlack);
       [~, pvalsSlack(sVertex, tVertex)] = ttest2(controlsSlack, aMcisSlack);
   end
end

FDRoffset = (1/((vertexCount*(vertexCount-1))/2))*0.05;
criticalBHFDR = ((1:((vertexCount*(vertexCount-1))/2))*FDRoffset)';
slackPvalsSort = sort(pvalsSlack(triu(ones(377), 1)>0));
slackCriticalPvalue = slackPvalsSort(find((slackPvalsSort<criticalBHFDR), 1, 'last'));
significance = pvalsSlack<slackCriticalPvalue;
