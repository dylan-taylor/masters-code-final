function [SI, pathProbs] = searchInformation(edgeLength, edgeProbs)
    % Calculate the search information between every vertex of a matrix representation. 
    intermInformation = zeros(size(edgeLength));
    G = graph(edgeLength);
    for s = 1:size(edgeLength,1)
        pathDigraph = shortestPathGraph(G, s);
        for t = 1:size(edgeLength,2)
            if s~=t
                shortestPaths = allpaths(pathDigraph, s, t);
                for p = 1:length(shortestPaths)
                    pathVerts = shortestPaths{p};
                    intermInformation(s,t) = intermInformation(s,t) + prod(edgeProbs(sub2ind(size(edgeProbs), pathVerts(1:(end-1)), pathVerts(2:end))));
                end
            end
        end
    end

    SI=-log2(intermInformation);
    pathProbs = intermInformation;
end