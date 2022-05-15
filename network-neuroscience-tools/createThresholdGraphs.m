function [threshGraphs, threshDensities] =  createThresholdGraphs(M, densityPoints)
    % Creates threshold graph adjacency matrices for graphs at each specified density.
    % Inputs:
    % M - Adjacency matrix/Graph object of the weighted graph with V veticies.
    % densityPoints - A Vector of N densities to threshold the graph to.
    % Output:
    % threshMash - A V by V by N array of thresholded adjacency matrices for graph M.
    
    %% Check input and convert to graph where required.
    if isa(M, 'graph')
        M = full(adjacency(M));
    end
    
    if ~issymmetric(M)
        error('Matrix not symmetric - function not defined for digraphs')
    end
    if size(M, 1) ~= size(M,2)
        error('Matrix not square, thus cannot be a adjacency matrix')
    end
    
    vertexNumber = size(M,1);
    threshGraphsArray = zeros(vertexNumber, vertexNumber, length(densityPoints));
    
    intermCounts = M;
    
    %% Find maximum spanning tree
    G_inv = graph(-M);
    maxSpanTreeMatrix = -full(adjacency(minspantree(G_inv), 'weighted'));
    G = maxSpanTreeMatrix;
    intermCounts = intermCounts-maxSpanTreeMatrix;
    
    % Densities need to be in order, for this function to work
    threshDensities = sort(densityPoints);
    
    %% Work through the set densities
    for iDensity = 1:length(threshDensities)
        densityThreshold = threshDensities(iDensity);
        
        while nnz(G)/(vertexNumber*(vertexNumber-1))<densityThreshold
            [w, idx] = max(intermCounts, [], 'all', 'linear');
            [s, t] = ind2sub([vertexNumber vertexNumber] ,idx);
            intermCounts(s,t) = 0;
            intermCounts(t,s) = 0;
            G(s,t) = w;
            G(t,s) = w;
        end
        
        threshGraphsArray(:,:,iDensity) = G;
    end
    threshGraphs = threshGraphsArray;
end