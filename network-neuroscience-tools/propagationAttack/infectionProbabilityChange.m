function dInfectionStatus = infectionProbabilityChange(infectionStatus, connectome, alpha)
    vertStrengths = vertexStrength(connectome, false);
    dInfectionStatus = zeros(length(vertStrengths), 1);
    t2 = zeros(377, 377);
    for iVert = 1:length(vertStrengths)
        infectionPressure = 0;
        for jVert = 1:length(vertStrengths)
            if iVert ~= jVert
                infectionPressure = infectionPressure + (connectome(iVert, jVert)/vertStrengths(iVert))*infectionStatus(jVert);
            end
        end
        dInfectionStatus(iVert) = alpha*(1-infectionStatus(iVert))*infectionPressure;
    end
end