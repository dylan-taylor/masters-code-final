function avgVector = getConnectomeWeightedAverages(connectomes, weights, countDiagonal, undirected)
    % Will work through an NxNxM array, N vertices, M participants.
    % Generates a vector of the average values for each of the connectomes
    % Inputs:
    % connectomes - NxNxM array of M participants connectomes
    % weights - NxNxM array of M participants weighting for each value.
    % countDiagonal (bool) - Include the diagonal in the average
    % undirected (bool) - Only count the upper triangle
    avgVector = zeros(size(connectomes, 3), 1);
    for iParticipant = 1:size(connectomes, 3)
        if undirected
            if countDiagonal
                mask =triu(ones(size(connectomes, 1)))>0;
            else
                mask =triu(ones(size(connectomes, 1), 1))>0;
            end
        else
            if countDiagonal
                mask = ones(size(connectomes, 1))>0;
            else
                mask = (ones(size(connectomes, 1))-diag(ones(size(connectomes,1),1)))>0;
            end
        end
        participantConnectome = connectomes(:, :, iParticipant).*weights(:, :, iParticipant);
        participantWeights = weights(:,:,iParticipant);
        avgVector(iParticipant) = sum(participantConnectome(mask))/sum(participantWeights(mask));
    end
end