function graphAssCoeff = graphAssortativityCoefficientWeighted(M)

    % Implemetnation of Leung & Chau's (2007) weighted assortativity
    % coefficient.
    G = graph(M);

    % Determine parts.
    H = sum(triu(M), 'all');
    
    productSum = 0;
    sumOfSumOfSquares = 0;
    sumOfStrengths = 0;
    
    vertexDegrees = degree(G);
    edgeWeights = G.Edges.Weight;
    
    for iEdge = 1:size(G.Edges,1)
        startDeg = vertexDegrees(G.Edges.EndNodes(iEdge,1));
        endDeg = vertexDegrees(G.Edges.EndNodes(iEdge,2));
        edgeWeight = edgeWeights(iEdge);
        productSum = productSum + edgeWeight*startDeg*endDeg;
        sumOfSumOfSquares = sumOfSumOfSquares + edgeWeight*(startDeg^2 + endDeg^2);
        sumOfStrengths = sumOfStrengths + edgeWeight*(startDeg + endDeg);
    end
    
    commonSubtract = (((H^-1)/2)*sumOfStrengths)^2;
    
    r_numerator = (H^-1)*productSum-commonSubtract;
    r_denominator = ((H^-1)/2)*sumOfSumOfSquares-commonSubtract;
    
    graphAssCoeff = r_numerator/r_denominator;
end