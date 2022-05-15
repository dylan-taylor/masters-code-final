function pathGraph = shortestPathGraph(M, s)
    % A function that will return all the shortest paths between two
    % vertices.
    %
    % Input:
    % M - Adjacency matrrix or graph object, of graph of interest.
    % s - Source Vertex Id.
    %
    % Output:
    % pathGraph - A digraph where every path to a target, is shortest.
    %
    
    %% Check input and convert to (di)graph where required.
    if isa(M, 'digraph') || isa(M, 'graph')
        G = M;
    else
        if ~issymmetric(M)
            G = digraph(M);
        else
            G = graph(M);
        end
    end
    
    %% Initialise graph with a shortest path tree
    [shortestTR, shortestDists] = shortestpathtree(G, s);
    shortestPathDigraph = shortestTR;
    
    %% Add edges for additional shortest paths
    for t = 1:size(M, 2)
        if s~= t
            % Find the neighbours of t in G, and the weight of the edges
            % from the neighbours to t.
            tNeighbors = neighbors(G, t);
            tPotEdgeEnds = [tNeighbors repelem(t, length(tNeighbors))'];
            tCurrentEdges = predecessors(shortestPathDigraph, t);
            tNeighborEdges = findedge(G, t, tNeighbors);

            tEdgeAdjacency = tNeighborEdges;
            tAdjacentWeights = G.Edges.Weight(tEdgeAdjacency);

            %% Find alternative paths, that are shortest.
            alternativeDistances = tAdjacentWeights + shortestDists(tNeighbors(tNeighborEdges>0))';
            alternativePathEdges = alternativeDistances==shortestDists(t); % Remove non-shortest paths
            alternativePathEdges(tPotEdgeEnds(:,1)==tCurrentEdges)=0;% Remove paths that already exist

            % Add the required edges
            if ~isempty(tEdgeAdjacency(alternativePathEdges))
                shortestPathDigraph = addedge(shortestPathDigraph, tPotEdgeEnds(alternativePathEdges,1),tPotEdgeEnds(alternativePathEdges,2), tAdjacentWeights(alternativePathEdges));
            end
        end
    end
    pathGraph = shortestPathDigraph;
end