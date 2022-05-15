function [infoMatrix, vertexEntropy, probMatrix] = informationConnectivity(M)
    % Input:
    % M - A matrix representation of an undirected graph
    % Output:
    % infoMatrix - A matrix representation of a directed graph with edge 
    % weights being the self-information of the event of edge travesal from
    % a vertex.
    % vertexEntropy - A vector of the entropy of each node
    % probMatrix - The probability matrix all of this is derived from.
    
    probMatrix = M./sum(M,2);
    probMatrix(isnan(probMatrix)) = 0;
    infoMatrix = -log2(probMatrix);
    infoMatrix(isinf(infoMatrix)) = 0;

    vertexEntropy = sum(probMatrix.*infoMatrix);
end