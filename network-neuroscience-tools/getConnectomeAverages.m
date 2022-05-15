function avgVector = getConnectomeAverages(connectomes, countDiagonal, undirected)
    % Will work through an NxNxM array, N vertices, M participants.
    % Generates a vector of the average values for each of the connectomes
    % Inputs:
    % connectomes - NxNxM array of M participants connectomes
    % countDiagonal (bool) - Include the diagonal in the average
    % undirected (bool) - Only count the upper triangle
    avgVector = zeros(size(connectomes, 3), 1);
    for iParticipant = 1:size(connectomes, 3)
        if undirected
            if countDiagonal
                mask =triu(ones(size(connectome, 1)))>0;
            else
                mask =triu(ones(size(connectome, 1), 1))>0;
            end
        else
            if countDiagonal
                mask = ones(size(connectome, 1))>0;
            else
                mask = (ones(size(connectome, 1))-diag(ones(size(connectome,1),1)))>0;
            end
        end
        participantConnectome = connectomes(:,:,iParticipant);
        avgVector(iParticipant) = mean(participantConnectome(mask));
    end
end