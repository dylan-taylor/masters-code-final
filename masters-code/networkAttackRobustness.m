vertexCount = 377;

participant_data = readtable('participant_demographics.csv');
% Pre-assign matrices where possible
countConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
% Import and derive the metrics from the connectomes
for iParticipant = 1:length(participant_data.participant_id)  
    % Read in connectome for participant i
    countConnectomes(:,:,iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_counts\', participant_data.participant_id{iParticipant}, '_hcpmmp1_connectome_MERGED.csv'));
end
%% Standard attack models
steps = 365;

% Strength
eglobStrength = zeros(length(participant_data.participant_id), steps);
infoEglobStrength = zeros(length(participant_data.participant_id), steps);
avgStrengthStrength = zeros(length(participant_data.participant_id), steps);
parfor iParticipant = 1:30
    disp(iParticipant)
    degradedNetworks = graphAttack(countConnectomes(:,:,iParticipant), steps, 'strength');
    for iNetwork = 1:steps
        workingNetwork = degradedNetworks{iNetwork};
        [~, eglobStrength(iParticipant, iNetwork)] = characteristicPathLength(1./workingNetwork);
        [infoMatrix, ~, ~] = informationConnectivity(workingNetwork);
        [~, infoEglobStrength(iParticipant, iNetwork)] = characteristicPathLength(infoMatrix(:,:));
        avgStrengthStrength(iParticipant, iNetwork) = mean(vertexStrength(workingNetwork, true));
    end
end
writematrix(eglobStrength, '.\final_analysis\network_robustness\eglobStrength.csv')
writematrix(infoEglobStrength, '.\final_analysis\network_robustness\infoEglobStrength.csv')
writematrix(avgStrengthStrength, '.\final_analysis\network_robustness\avgStrengthStrength.csv')

% Degree
eglobDegree = zeros(length(participant_data.participant_id), steps);
infoEglobDegree = zeros(length(participant_data.participant_id), steps);
avgStrengthDegree = zeros(length(participant_data.participant_id), steps);
parfor iParticipant = 1:30
    disp(iParticipant)
    degradedNetworks = graphAttack(countConnectomes(:,:,iParticipant), steps, 'degree');
    for iNetwork = 1:steps
        workingNetwork = degradedNetworks{iNetwork};
        [~, eglobDegree(iParticipant, iNetwork)] = characteristicPathLength(1./workingNetwork);
        [infoMatrix, ~, ~] = informationConnectivity(workingNetwork);
        [~, infoEglobDegree(iParticipant, iNetwork)] = characteristicPathLength(infoMatrix(:,:));
        avgStrengthDegree(iParticipant, iNetwork) = mean(vertexStrength(workingNetwork, true));
    end
end
writematrix(eglobDegree, '.\final_analysis\network_robustness\eglobDegree.csv')
writematrix(infoEglobDegree, '.\final_analysis\network_robustness\infoEglobDegree.csv')
writematrix(avgStrengthDegree, '.\final_analysis\network_robustness\avgStrengthDegree.csv')

% Betweenness
eglobBetweenness = zeros(length(participant_data.participant_id), steps);
infoEglobBetweenness = zeros(length(participant_data.participant_id), steps);
avgStrengthBetweenness = zeros(length(participant_data.participant_id), steps);
parfor iParticipant = 1:30
    disp(iParticipant)
    degradedNetworks = graphAttack(countConnectomes(:,:,iParticipant), steps, 'betweenness');
    for iNetwork = 1:steps
        workingNetwork = degradedNetworks{iNetwork};
        [~, eglobBetweenness(iParticipant, iNetwork)] = characteristicPathLength(1./workingNetwork);
        [infoMatrix, ~, ~] = informationConnectivity(workingNetwork);
        [~, infoEglobBetweenness(iParticipant, iNetwork)] = characteristicPathLength(infoMatrix(:,:));
        avgStrengthBetweenness(iParticipant, iNetwork) = mean(vertexStrength(workingNetwork, true));
    end
end
writematrix(eglobBetweenness, '.\final_analysis\network_robustness\eglobBetweenness.csv')
writematrix(infoEglobBetweenness, '.\final_analysis\network_robustness\infoEglobBetweenness.csv')
writematrix(avgStrengthBetweenness, '.\final_analysis\network_robustness\avgStrengthBetweenness.csv')


%% Simulated degradation
% alpha = 0.4;
% betaAD = 0.025;
% time = 50;
% steps = 100;
% networkCount = time*steps;
% % Does not include the normal aging part of the model.
% betaHC = zeros(length(countConnectomes));
% 
% % Two seeding options, diffuse cortical, and dense in hippocampues, for AD
% % and NFTs respectivly
% avgInfectionNFT = zeros(length(participant_data.participant_id), time*steps);
% eglobNFT = zeros(length(participant_data.participant_id), time*steps);
% infoEglobNFT = zeros(length(participant_data.participant_id), time*steps);
% 
% % NFT simulation using hippocampal only initial values.
% initialValuesNFT = zeros(vertexCount,1);
% initialValuesNFT([364 373]) = 0.1;
% 
% for iParticipant = 1:30
%     disp(iParticipant)
%     [degradedNetworks, degradedStrengths] = propagationAttack(countConnectomes(:,:,iParticipant), time, steps, alpha, betaAD, betaHC, initialValuesNFT);
%     for iNetwork = 1:networkCount
%         [~, eglobNFT(iParticipant, iNetwork)] = characteristicPathLength(1./round(degradedNetworks(:,:,iNetwork)));
%         [infoMatrix, ~, ~] = informationConnectivity(round(degradedNetworks(:,:,iNetwork)));
%         [~, infoEglobNFT(iParticipant, iNetwork)] = characteristicPathLength(infoMatrix(:,:));
%         avgInfectionNFT(iParticipant, iNetwork) = mean(degradedStrengths(:, iNetwork));
%     end
% end
% 
% writematrix(eglobNFT, '.\final_analysis\network_robustness\eglobNFT.csv')
% writematrix(infoEglobNFT, '.\final_analysis\network_robustness\infoEglobNFT.csv')
% writematrix(avgInfectionNFT, '.\final_analysis\network_robustness\avgInfectionNFT.csv')
% 
% % AD Simulation using diffuse cortical initial values
% avgInfectionAB = zeros(length(participant_data.participant_id), time*steps);
% eglobAB = zeros(length(participant_data.participant_id), time*steps);
% infoEglobAB = zeros(length(participant_data.participant_id), time*steps);
% 
% initialValuesAB = zeros(vertexCount,1);
% initialValuesAB(1:358) = 0.01;
% for iParticipant = 1:30
%     disp(iParticipant)
%     [degradedNetworks, degradedStrengths] = propagationAttack(countConnectomes(:,:,iParticipant), time, steps, alpha, betaAD, betaHC, initialValuesAB);
%     for iNetwork = 1:networkCount
%         [~, eglobAB(iParticipant, iNetwork)] = characteristicPathLength(1./round(degradedNetworks(:,:,iNetwork)));
%         [infoMatrix, ~, ~] = informationConnectivity(round(degradedNetworks(:,:,iNetwork)));
%         [~, infoEglobAB(iParticipant, iNetwork)] = characteristicPathLength(infoMatrix(:,:));
%         avgInfectionAB(iParticipant, iNetwork) = mean(degradedStrengths(:, iNetwork));
%     end
% end
% writematrix(eglobAB, '.\final_analysis\network_robustness\eglobAB.csv')
% writematrix(infoEglobAB, '.\final_analysis\network_robustness\infoEglobAB.csv')
% writematrix(avgInfectionAB, '.\final_analysis\network_robustness\avgInfectionAB.csv')