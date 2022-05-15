function [smallWorldCoeff, normalisedCPL, normalisedClustering] = graphSmallWorld(M, iterations)
   % Currently only uses inverse count definition of length.
   upperT = true(length(M));
   upperValues = M(upperT);
   randomisedCpl = zeros(iterations, 1);
   randomisedClustering = zeros(iterations, 1);
   for iIter = 1:iterations
       A = zeros(length(M));
       A(upperT) = upperValues(randperm(length(upperValues)));
       randomGraph = A+triu(A,1)';
       inverseRandomGraph = 1./randomGraph;
       inverseRandomGraph(isinf(inverseRandomGraph)) = 0;
       randomisedCpl(iIter) = characteristicPathLength(inverseRandomGraph);
       randomisedClustering(iIter) = graphClusteringCoefficient(randomGraph);
   end
   inverseM = 1./M;
   inverseM(isinf(inverseM)) = 0;
   normalisedCPL = characteristicPathLength(inverseM)/mean(randomisedCpl);
   normalisedClustering = graphClusteringCoefficient(M)/mean(randomisedClustering);
   smallWorldCoeff = normalisedClustering/normalisedCPL;
end

