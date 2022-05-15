function minDensity = minConnectedDensity(M)
    % Determines the minimum density at which the graph becomes connected,
    % when the thresholding is through adding the largest edge not in the
    % graph at each step.
    % Input:
    % M - Adjacency matrix representation of graph.
    if sum(diag(M)) == 0
        maxSize =((size(M, 1)*(size(M, 1) - 1))/2);
    else
        maxSize =(((size(M, 1)*(size(M, 1) - 1))/2)+size(M, 1));
    end
    G = graph(M);
    threshG = graph(zeros(size(M)));
    edgeSorted = sortrows(G.Edges,2, 'descend');
    edgeInd = 1;
    while length(unique(conncomp(threshG))) > 1
        threshG = addedge(threshG, edgeSorted.EndNodes(edgeInd, 1), edgeSorted.EndNodes(edgeInd, 2), edgeSorted.Weight(edgeInd));
        edgeInd = edgeInd+1;
    end
    minDensity = size(threshG.Edges,1)/maxSize;
end