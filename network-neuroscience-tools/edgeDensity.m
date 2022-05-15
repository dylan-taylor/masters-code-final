function rho = edgeDensity(M)
    % INPUT FOR INCLUDING REFLEXIVE EDGES
    % Input: 
    % M - A matrix representation of an undirected graph
    % Output:
    % rho - The proportion of edges to a complete graph of the same order.
    if ~issymmetric(M)
        error("Matrix is not symmetric, cannot calculate density.")
    end
    
    binarized = M>0;
    
    % Calculate number of edges and double to remove extra division in rho
    % calculation.
    edgeCount = sum(triu(binarized, 1), 'all')*2; 
    rho = edgeCount/((size(M,1))*(size(M,1)-1));
end