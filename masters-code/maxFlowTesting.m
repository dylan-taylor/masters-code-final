%% Import data, and preallocate variables.
vertexCount = 377;
participantData = readtable('.\final_analysis\participant_demographics.csv');

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);

maxFlowMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));
minCostMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));
minInfoCostMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));
avgCostMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));
avgInfoCostMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));

avgGraphCost = zeros(length(participantData.participant_id),1);
avgGraphFlow = zeros(length(participantData.participant_id),1);

for iParticipant = 1:length(participantData.participant_id)
    subjectFile = strcat('.\final_analysis\connectome_data\maxflow\', participantData.participant_id{iParticipant}, '\');
    subjectFileInfo = strcat('.\final_analysis\connectome_data\maxflowInfo\', participantData.participant_id{iParticipant}, '\');
    maxFlowMatrix(:, :, iParticipant) = readmatrix(strcat(subjectFile, participantData.participant_id{iParticipant}, '_maxflow.csv'));
    minCostMatrix(:, :, iParticipant) = readmatrix(strcat(subjectFile, participantData.participant_id{iParticipant}, '_mincost.csv'));
    minInfoCostMatrix(:, :, iParticipant) = readmatrix(strcat(subjectFileInfo, participantData.participant_id{iParticipant}, '_mincost.csv'));
    avgCostMatrix(:, :, iParticipant) = minCostMatrix(:, :, iParticipant)./maxFlowMatrix(:, :, iParticipant);
    avgInfoCostMatrix(:, :, iParticipant) = minInfoCostMatrix(:, :, iParticipant)./maxFlowMatrix(:, :, iParticipant);
    
    participantFlow = maxFlowMatrix(:, :, iParticipant);
    participantCost = minCostMatrix(:, :, iParticipant);
    
    avgGraphFlow(iParticipant) = mean(participantFlow(triu(ones(377), 1)>0));
    avgGraphCost(iParticipant) = sum(participantCost(triu(ones(377), 1)>0))/sum(participantFlow(triu(ones(377), 1)>0));
end

avgGraphInfoCost = getConnectomeWeightedAverages(avgInfoCostMatrix, maxFlowMatrix, false, false);

writematrix(avgGraphFlow, '.\final_analysis\graph_weighted_metrics\avgGraphFlow.csv')
writematrix(avgGraphCost,  '.\final_analysis\graph_weighted_metrics\avgGraphCost.csv')
writematrix(avgGraphInfoCost,  '.\final_analysis\graph_weighted_metrics\avgGraphInfoCost.csv')
pvalsFlow = ones(vertexCount, vertexCount);
pvalsCost = ones(vertexCount, vertexCount);
pvalsAvgCost = ones(vertexCount, vertexCount);
pvalsAvgInfoCost = ones(vertexCount, vertexCount);
%% Calculate pvals for all edges.
for sVertex = 1:vertexCount
   for tVertex = sVertex+1:vertexCount
       controlsFlow = squeeze(maxFlowMatrix(sVertex, tVertex, controls));
       aMcisFlow = squeeze(maxFlowMatrix(sVertex, tVertex, aMci));
       [~, pvalsFlow(sVertex, tVertex)] = ttest(controlsFlow, aMcisFlow);
       
       controlsCost = squeeze(minCostMatrix(sVertex, tVertex, controls));
       aMcisCost = squeeze(minCostMatrix(sVertex, tVertex, aMci));
       [~, pvalsCost(sVertex, tVertex)] = ttest(controlsCost, aMcisCost);
       
       controlsAvgCost = squeeze(avgCostMatrix(sVertex, tVertex, controls));
       aMcisAvgCost = squeeze(avgCostMatrix(sVertex, tVertex, aMci));
       [~, pvalsAvgCost(sVertex, tVertex)] = ttest2(controlsAvgCost, aMcisAvgCost);
       
       controlsAvgInfoCost = squeeze(avgInfoCostMatrix(sVertex, tVertex, controls));
       aMcisAvgInfoCost = squeeze(avgInfoCostMatrix(sVertex, tVertex, aMci));
       [~, pvalsAvgInfoCost(sVertex, tVertex)] = ttest2(controlsAvgInfoCost, aMcisAvgInfoCost);
   end
end

%% FDR correction
FDRoffset = (1/((vertexCount*(vertexCount-1))/2))*0.05;
criticalBHFDR = ((1:((vertexCount*(vertexCount-1))/2))*FDRoffset)';

flowPvalsSort = sort(pvalsFlow(triu(ones(377), 1)>0));
costPvalsSort = sort(pvalsCost(triu(ones(377), 1)>0));
avgCostPvalsSort = sort(pvalsAvgCost(triu(ones(377), 1)>0));
avgInfoCostPvalsSort = sort(pvalsAvgInfoCost(triu(ones(377), 1)>0));

avgInfoCostPvalsCriticalPval = criticalBHFDR(avgInfoCostPvalsSort<criticalBHFDR);
[A, B] = ind2sub([377, 377],find(pvalsAvgInfoCost<avgInfoCostPvalsCriticalPval));





%% Testing slack
% minDegreeMatrix = zeros(vertexCount, vertexCount, length(participantData.participant_id));
% for iParticipant = 1:length(participantData.participant_id)
%     vertStrength = vertexStrength(countConnectomes(:,:,iParticipant));
%     for sVertex = 1:vertexCount
%         for tVertex = 1:vertexCount
%             if sVertex ~= tVertex
%                 minDegreeMatrix(sVertex, tVertex, iParticipant) = min([vertStrength(sVertex) vertStrength(tVertex)]);
%             end
%         end
%     end
% end
% 
% slackMatrix = minDegreeMatrix-maxFlowMatrix;
% pvalsSlack = ones(vertexCount, vertexCount);

%% Calculate pvals for all edges.
% for sVertex = 1:vertexCount
%    for tVertex = sVertex+1:vertexCount
%        controlsSlack = squeeze(slackMatrix(sVertex, tVertex, controls));
%        aMcisSlack = squeeze(slackMatrix(sVertex, tVertex, aMci));
%        [~, pvalsSlack(sVertex, tVertex)] = ttest2(controlsSlack, aMcisSlack);
%    end
% end
% 
% slackPvalsSort = sort(pvalsSlack(triu(ones(377), 1)>0));
% slackCriticalPvalue = slackPvalsSort(find((slackPvalsSort<criticalBHFDR), 1, 'last'));
% significance = pvalsSlack<slackCriticalPvalue;

