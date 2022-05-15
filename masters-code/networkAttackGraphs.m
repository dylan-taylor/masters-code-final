% Script requires montecluster package (-DETAILS OF HOW TO FIND HERE-)
resultFiles = '';
%% Import/Setup general details
participantData = readtable('participant_demographics.csv');

controls = cellfun(@(x)isequal(x,'Control'), participantData.classification);
aMci = cellfun(@(x)isequal(x,'aMCI'), participantData.classification);

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

eglobDerStr = smoothDerivative(eglobStrength);
infoDerStr = smoothDerivative(infoEglobStrength);
strDerStr = smoothDerivative(avgStrengthStrength);

eglobDerDeg = smoothDerivative(eglobDegree);
infoDerDeg = smoothDerivative(infoEglobDegree);
strDerDeg = smoothDerivative(avgStrengthDegree);

eglobDerBet = smoothDerivative(eglobBetweenness);
infoDerBet = smoothDerivative(infoEglobBetweenness);
strDerBet = smoothDerivative(avgStrengthBetweenness);

eglobDerNFT = smoothDerivative(eglobNFT);
infoDerNFT = smoothDerivative(infoEglobNFT);
strDerNFT = smoothDerivative(avgStrengthNFT);

eglobDerAB = smoothDerivative(eglobAB);
infoDerAB = smoothDerivative(infoEglobAB);
strDerAB = smoothDerivative(avgStrengthAB);

plotshadedline(eglobStrength(controls,:),eglobStrength(aMci,:), 1:length(eglobStrength))
plotshadedline(infoEglobStrength(controls,:),infoEglobStrength(aMci,:), 1:length(infoEglobStrength))
plotshadedline(avgStrengthStrength(controls,:),avgStrengthStrength(aMci,:), 1:length(avgStrengthStrength))

plotshadedline(eglobDerStr(controls,:),eglobDerStr(aMci,:), 1:length(eglobDerStr))
plotshadedline(infoDerStr(controls,:),infoDerStr(aMci,:), 1:length(infoDerStr))
plotshadedline(strDerStr(controls,:),strDerStr(aMci,:), 1:length(strDerStr))

plotshadedline(eglobBetweenness(controls,:),eglobBetweenness(aMci,:), 1:length(eglobBetweenness))
plotshadedline(infoEglobBetweenness(controls,:),infoEglobBetweenness(aMci,:), 1:length(infoEglobBetweenness))
plotshadedline(avgStrengthBetweenness(controls,:),avgStrengthBetweenness(aMci,:), 1:length(avgStrengthBetweenness))

plotshadedline(eglobDerBet(controls,:),eglobDerBet(aMci,:), 1:length(eglobDerBet))
plotshadedline(infoDerBet(controls,:),infoDerBet(aMci,:), 1:length(infoDerBet))
plotshadedline(strDerBet(controls,:),strDerBet(aMci,:), 1:length(strDerBet))

plotshadedline(eglobNFT(controls,:),eglobNFT(aMci,:), 1:length(eglobNFT))
plotshadedline(infoEglobNFT(controls,:),infoEglobNFT(aMci,:), 1:length(infoEglobNFT))
plotshadedline(avgStrengthNFT(controls,:),avgStrengthNFT(aMci,:), 1:length(avgStrengthNFT))

plotshadedline(eglobAB(controls,:),eglobAB(aMci,:), 1:length(eglobAB))
plotshadedline(infoEglobAB(controls,:),infoEglobAB(aMci,:), 1:length(infoEglobAB))
plotshadedline(avgStrengthAB(controls,:),avgStrengthAB(aMci,:), 1:length(avgStrengthAB))

plotshadedline(eglobDerAB(controls,:),eglobDerAB(aMci,:), 1:length(eglobDerAB))
plotshadedline(infoDerAB(controls,:),infoDerAB(aMci,:), 1:length(infoDerAB))
plotshadedline(strDerAB(controls,:),strDerAB(aMci,:), 1:length(strDerAB))