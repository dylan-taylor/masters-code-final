function [attackedConnectomes, infectionStatus] = propagationAttack(connectome, time, steps, alpha, betaAD, betaHC, initialConditions)
%PROPOGATINGFAILURE Summary of this function goes here
%   connectome - adjacency matrix of brain network
%   time - how many time points
%   steps - steps between each time point
%   alpha - infection rate
%   betaAD - influence of aggregated disease factor
%   betaHC - normal aging degredation of edge, derived from separate
%   function
infectionStatus = zeros(length(initialConditions), time);
infectionStatus(:, 1) = initialConditions;

attackedConnectomes = zeros(length(connectome), length(connectome), time*steps);
attackedConnectomes(:, :, 1) = connectome;
% Simulate using eulars method (change to RK4 if time permits)
stepConnectomes = zeros(length(connectome), length(connectome), 2);
stepConnectomes(:, :, 1) = connectome;

stepInfection = zeros(length(connectome), 2);
stepInfection(:, 1) = infectionStatus(:, 1);

for iTime = 2:time*steps
    % Calculate edge weights first
    % Change in edge weights
    deltaEdgeWeight = edgeWeightChange(stepInfection(:, 1), stepConnectomes(:, :, 1), betaAD, betaHC);
    stepConnectomes(:,:,2) = stepConnectomes(:,:,1) + (1/steps)*deltaEdgeWeight;
    
    % Calculate change in infection status
    deltaInfection = infectionProbabilityChange(stepInfection(:,1), stepConnectomes(:,:,1), alpha);
    stepInfection(:, 2) = stepInfection(:,1) + (1/steps)*deltaInfection;
    
    % Move to next step
    stepConnectomes(:,:,1) = stepConnectomes(:,:,2);
    stepInfection(:,1) = stepInfection(:,2);

    attackedConnectomes(:,:,iTime) = stepConnectomes(:,:,1);
    infectionStatus(:,iTime) = stepInfection(:,1);
end

