function graphAssCoeff = graphAssortativityCoefficient(M)
    % Naive implementation of (Newman, 2002)
    
    G = graph(M);
    
    edgeNum = size(G.Edges,1);
    
    % For each edge in G, calculate intermediary values
    multiplicativeSum = 0;
    additiveSum = 0;
    sumSquareSum = 0;

    degs = degree(G, G.Edges.EndNodes);

    for i = 1:length(degs)
        multiplicativeSum = multiplicativeSum + degs(i,1)*degs(i,2);
        additiveSum = additiveSum + (1/2)*(degs(i,1)+degs(i,2));
        sumSquareSum = sumSquareSum + (1/2)*(degs(i,1)^2 + degs(i,2)^2);
    end

    squareSumNorm = ((edgeNum^-1)*additiveSum)^2;
    
    graphAssCoeff = ((edgeNum^-1)*multiplicativeSum-squareSumNorm)/((edgeNum^-1)*sumSquareSum-squareSumNorm);
end