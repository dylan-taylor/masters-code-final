function flowMatrix = maxFlowMatrix(M)
    % A function that returns the maximum flow for every vertex pair in the
    % graph.
    % Inputs:
    % M - An adjacency matrix or graph.
      
    flowMatrixCalc = zeros(size(M));
    asym = false;
    
    %% Input cleaning
    if isa(M, 'digraph') || isa(M, 'graph')
        G = M;
        if isa(M, 'digraph')
            asym = true;
        end
    else
        if diff(size(M)) ~= 0
            error('Matrix is not square')
        end
        if ~issymmetric(M)
            G = digraph(M);
            asym = true;
        else
            G = graph(M);
        end
    end
    
    %% maxflow calculation loop
    for sVertex = 1:size(M, 1)
        if asym
            tStart = size(M, 1);
        else
            tStart = sVertex + 1;
        end
        for tVertex = tStart:size(M,2)
            flowMatrixCalc(sVertex, tVertex) = maxflow(G, sVertex, tVertex);
        end
    end
    if asym
        flowMatrix = flowMatrixCalc;
    else
        flowMatrix = flowMatrixCalc + flowMatrixCalc';
    end
end