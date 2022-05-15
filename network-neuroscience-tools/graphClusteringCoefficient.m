function [C, vertexCoeffs] = graphClusteringCoefficient(M)
    % Calculates the graph clustering coefficient as the mean of the vertex
    % clustering coefficient
    % Input:
    % M - An adjacency matrix representation of a graph
    clusteringCoeffs = zeros(size(M,1),1);
    for i = 1:size(M,1)
        clusteringCoeffs(i) = vertexClusteringCoefficient(i, M);
    end
    C = sum(clusteringCoeffs)/size(M,1);
    vertexCoeffs = clusteringCoeffs;
end