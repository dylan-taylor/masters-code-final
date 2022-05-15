% This script is to capture all the tests performed in the process of
% developing the discussion of what the main results mean.

%% Import needed resources
vertexCount = 377;
participantData = readtable('participant_demographics.csv');
edgeDensity = readmatrix('edgeDensities.csv');
countConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
infoConnectomes = zeros(vertexCount,vertexCount,size(participantData,1));
for iParticipant = 1:size(participantData,1)
    subjectFile = participantData.participant_id{iParticipant};
    countConnectomes(:,:,iParticipant) = readmatrix(strcat("\final_analysis\connectome_data\connectome_counts\",participantData.participant_id{iParticipant},"_hcpmmp1_connectome_MERGED.csv"));
    infoConnectomes(:,:,iParticipant) = readmatrix(strcat('.\final_analysis\participant_data\', participantData.participant_id{iParticipant}, '/', participantData.participant_id{iParticipant},  '_infoConnectome.csv'));
end

% %% Clustering coefficient and density
% % Density could be the reason clustering coefficient is different.
% % Perform a calculation of the clustering coefficient of the maximum
% % possible common density.
% weightedClusterCoefficientMaxDensity = zeros(size(participantData,1), 1);
% unweightedClusterCoefficientMaxDensity = zeros(size(participantData,1), 1);
% for iParticipant = 1:size(participantData,1)
%     participantThreshGraph = createThresholdGraphs(countConnectomes(:,:,iParticipant), min(edgeDensity)); 
%     weightedClusterCoefficientMaxDensity(iParticipant) = graphClusteringCoefficient(participantThreshGraph);
%     unweightedClusterCoefficientMaxDensity(iParticipant) = graphClusteringCoefficient(participantThreshGraph>0);
% end
% writematrix(weightedClusterCoefficientMaxDensity, '.\final_analysis\discussion_post_hoc\weightedClusterCoefficientMaxDensity.csv')
% writematrix(unweightedClusterCoefficientMaxDensity, '.\final_analysis\discussion_post_hoc\unweightedClusterCoefficientMaxDensity.csv')

% %% Clustering coefficient vertex across vertex strength
% % Is node strength a cause of the difference in clustering at different
% % densities between the two groups.
% controls = countConnectomes(:,:,cellfun(@(x)isequal(x,'Control'), participantData.classification));
% aMci = countConnectomes(:,:,cellfun(@(x)isequal(x,'aMCI'), participantData.classification));
% hcStrengthCluster = zeros(vertexCount*size(controls,3),2);
% aMciStrengthCluster = zeros(vertexCount*size(controls,3),2);
% 
% for iParticipant = 1:size(controls,3)
%     disp(iParticipant)
%     hcStrengthCluster(((iParticipant-1)*vertexCount)+1:(iParticipant*vertexCount), 1) = vertexStrength(controls(:,:,iParticipant));
%     aMciStrengthCluster(((iParticipant-1)*vertexCount)+1:(iParticipant*vertexCount), 1) = vertexStrength(controls(:,:,iParticipant));
%     for jVert = 1:vertexCount
%         hcStrengthCluster(((iParticipant-1)*vertexCount)+jVert, 2) = vertexClusteringCoefficient(jVert, controls(:,:,iParticipant));
%         aMciStrengthCluster(((iParticipant-1)*vertexCount)+jVert, 2) = vertexClusteringCoefficient(jVert, aMci(:,:,iParticipant));
%     end
% end
% strengthClusterArray = [repelem([0], vertexCount*size(controls,3))' hcStrengthCluster;repelem([1], vertexCount*size(aMci,3))' aMciStrengthCluster];
% writematrix(strengthClusterArray, '.\final_analysis\discussion_post_hoc\strengthClusterArray.csv')

%% Test for counts of edges existing between two vertices, between the HC and aMCI groups.
controls = countConnectomes(:,:,cellfun(@(x)isequal(x,'Control'), participantData.classification));
aMci = countConnectomes(:,:,cellfun(@(x)isequal(x,'aMCI'), participantData.classification));
controlsBinary = controls>0;
aMciBinary = aMci>0;

chiP = ones(377,377);
chiS = zeros(377,377);
for iVert = 1:377
    for jVert = iVert:377
        [~, chiS(iVert, jVert), chiP(iVert, jVert)] = crosstab(squeeze(controlsBinary(iVert, jVert, :))', squeeze(aMciBinary(iVert, jVert, :))');
    end
end
chiP(isnan(chiP))=1;
% Statistics of interest
sigEdges = chiP<0.05;
mean(mean(countConnectomes,3).*(sigEdges+sigEdges'), 'all');
numSig = sum(sigEdges+sigEdges','all')/2;
(numSig/((377*376)/2));

%% Left Frontal Eye Field Test
writematrix(squeeze(sum(infoConnectomes(10,:,:))), '.\final_analysis\discussion_post_hoc\L_FEF_infoStrength.csv')
writematrix(squeeze(sum(countConnectomes(10,:,:)>0)), '.\final_analysis\discussion_post_hoc\L_FEF_degree.csv')
