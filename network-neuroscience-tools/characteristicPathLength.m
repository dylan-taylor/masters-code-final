function [CPL, E_glob] = characteristicPathLength(M)
    % Used to determine characeristic path length of a graph.
    % Input:
    % M - An adjacency matrix representation of a graph/digraph, or a graph/digraph
    % Output:
    % CPL - Characteristic Path Length of the network.
    % E_glob - Global efficiency of the network.
    
    if isa(M, 'digraph') || isa(M, 'graph')
        G = M;
    else
        if ~issymmetric(M)
            G = digraph(M);
        else
            G = graph(M);
        end
    end
    
    distanceMatrix = distances(G);
    CPL = mean(distanceMatrix(eye(size(distanceMatrix,1))~=1));
    E_glob = mean(1./distanceMatrix(eye(size(distanceMatrix,1))~=1));
end