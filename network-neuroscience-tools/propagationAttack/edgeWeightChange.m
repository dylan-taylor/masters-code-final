function dEdgeWeight = edgeWeightChange(infectionStatus, connectome, betaAD, betaHC)
    dEdgeWeight = -betaAD*connectome.*(infectionStatus+infectionStatus')+betaHC;
end

