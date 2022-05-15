% Script requires montecluster package (-DETAILS OF HOW TO FIND HERE-)
resultFiles = '';
%% Import/Setup general details
participantData = readtable('participant_demographics.csv');

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);

% Information about the propagation attack x axis
time = 50;
steps = 100; % CHANGE THIS WHEN FULL SCRIPT IS RUN
propagationTime = 1:1/steps:50;


results.metric = cell(15,1);
results.p = ones(15,3);
results.s = zeros(15,3);

iterations = 10^1;

%% Import threshold statisitics
eglobStrength = readmatrix(strcat(resultFiles, '\eglobStrength.csv'));
infoEglobStrength =  readmatrix(strcat(resultFiles, '\infoEglobStrength.csv'));
avgStrengthStrength = readmatrix(strcat(resultFiles, '\avgStrengthStrength.csv'));

eglobDegree = readmatrix(strcat(resultFiles, '\eglobDegree.csv'));
infoEglobDegree = readmatrix(strcat(resultFiles, '\infoEglobDegree.csv'));
avgStrengthDegree = readmatrix(strcat(resultFiles, '\avgStrengthDegree.csv'));

eglobBetweenness = readmatrix(strcat(resultFiles, '\eglobBetweenness.csv'));
infoEglobBetweenness = readmatrix(strcat(resultFiles, '\infoEglobBetweenness.csv'));
avgStrengthBetweenness = readmatrix(strcat(resultFiles, '\avgStrengthBetweenness.csv'));

eglobNFT = readmatrix(strcat(resultFiles, '\eglobNFT.csv'));
infoEglobNFT = readmatrix(strcat(resultFiles, '\infoEglobNFT.csv'));
avgStrengthNFT = readmatrix(strcat(resultFiles, '\avgStrengthNFT.csv'));

eglobAB = readmatrix(strcat(resultFiles, '\eglobAB.csv'));
infoEglobAB = readmatrix(strcat(resultFiles, '\infoEglobAB.csv'));
avgStrengthAB = readmatrix(strcat(resultFiles, '\avgStrengthAB.csv'));

%% Perform statistical testing
disp('eglobStrength')
[results.p(1,:), results.s(1,:)] = monteclustergroups(smoothDerivative(eglobStrength(controls, :))', smoothDerivative(eglobStrength(aMci, :))', iterations, 0.05, 1, 1:length(eglobStrength));
disp('infoEglobStrength')
[results.p(2,:), results.s(2,:)] = monteclustergroups(smoothDerivative(infoEglobStrength(controls, :))', smoothDerivative(infoEglobStrength(aMci, :))', iterations, 0.025, 1, 1:length(eglobStrength));
disp('avgStrengthStrength')
[results.p(3,:), results.s(3,:)] = monteclustergroups(smoothDerivative(avgStrengthStrength(controls, :))', smoothDerivative(avgStrengthStrength(aMci, :))', iterations, 0.025, 1, 1:length(eglobStrength));
%save('networkAttackResults.mat', 'results')

disp('eglobDegree')
[results.p(4,:), results.s(4,:)] = monteclustergroups(smoothDerivative(eglobDegree(controls, :))', smoothDerivative(eglobDegree(aMci, :))', iterations, 0.05, 1, 1:length(eglobStrength));
disp('infoEglobDegree')
[results.p(5,:), results.s(5,:)] = monteclustergroups(smoothDerivative(infoEglobDegree(controls, :))', smoothDerivative(infoEglobDegree(aMci, :))', iterations, 0.025, 1, 1:length(eglobStrength));
disp('avgStrengthDegree')
[results.p(6,:), results.s(6,:)] = monteclustergroups(smoothDerivative(avgStrengthDegree(controls, :))', smoothDerivative(avgStrengthDegree(aMci, :))', iterations, 0.025, 1, 1:length(eglobStrength));
%save('networkAttackResults.mat', 'results')

disp('eglobBetweenness')
[results.p(7,:), results.s(7,:)] = monteclustergroups(smoothDerivative(eglobBetweenness(controls, :))', smoothDerivative(eglobBetweenness(aMci, :))', iterations, 0.025, 1, 1:length(eglobStrength));
disp('infoEglobBetweenness')
[results.p(8,:), results.s(8,:)] = monteclustergroups(smoothDerivative(infoEglobBetweenness(controls, :))', smoothDerivative(infoEglobBetweenness(aMci, :))', iterations, 0.025, 1, 1:length(eglobStrength));
disp('avgStrengthBetweenness')
[results.p(9,:), results.s(9,:)] = monteclustergroups(smoothDerivative(avgStrengthBetweenness(controls, :))', smoothDerivative(avgStrengthBetweenness(aMci, :))', iterations, 0.025, 1, 1:length(eglobStrength));
save('networkAttackResults.mat', 'results')

eglobNFTDerivative = smoothDerivative(eglobNFT);
infoEglobNFTDerivative = smoothDerivative(infoEglobNFT);
avgStrengthNFTDerivative = smoothDerivative(avgStrengthNFT);

eglobABDerivative = smoothDerivative(eglobAB);
infoEglobABDerivative = smoothDerivative(infoEglobAB);
avgStrengthABDerivative = smoothDerivative(avgStrengthAB);

disp('eglobNFT')
[results.p(10,:), results.s(10,:)] = monteclustergroups(eglobNFTDerivative(controls, :)', eglobNFTDerivative(aMci, :)', 1, 0.1, 1, propagationTime); % No valid cluster
disp('infoEglobNFT')
[results.p(11,:), results.s(11,:)] = monteclustergroups(infoEglobNFTDerivative(controls, 1:10:length(propagationTime))', infoEglobNFTDerivative(aMci, 1:10:length(propagationTime))', iterations, 0.05, 1, propagationTime(1:10:length(propagationTime)));
disp('avgStrengthNFT')
[results.p(12,:), results.s(12,:)] = monteclustergroups(avgStrengthNFTDerivative(controls, 1:10:length(propagationTime))', avgStrengthNFTDerivative(aMci, 1:10:length(propagationTime))', iterations, 0.025, 1, propagationTime(1:10:length(propagationTime)));
save('networkAttackResults.mat', 'results')

disp('eglobAB')
[results.p(13,:), results.s(13,:)] = monteclustergroups(eglobABDerivative(controls, 1:10:length(propagationTime))', eglobABDerivative(aMci, 1:10:length(propagationTime))', 1, 0.1, 1, propagationTime(1:10:length(propagationTime))); % No valid cluster
disp('infoEglobAB')
[results.p(14,:), results.s(14,:)] = monteclustergroups(infoEglobABDerivative(controls, 1:10:length(propagationTime))', infoEglobABDerivative(aMci, 1:10:length(propagationTime))', iterations, 0.1, 1, propagationTime(1:10:length(propagationTime)));
disp('avgStrengthAB')
[results.p(15,:), results.s(15,:)] = monteclustergroups(avgStrengthABDerivative(controls, 1:10:length(propagationTime))', avgStrengthABDerivative(aMci, 1:10:length(propagationTime))', iterations, 0.1, 1, propagationTime(1:10:length(propagationTime)));
save('networkAttackResults.mat', 'results')