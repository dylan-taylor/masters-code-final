function [pathTrans, matchingIndex] = pathTransitivity(M, L)
    %% Calculate the matching indices
    G = graph(L);
    adjM = M>0;
    matchingIndex = zeros(size(M, 1));
    for iVertex = 1:(size(M,1))
        for jVertex = (iVertex):size(M,2)
            mijSum = 0;
            for kVertex = 1:size(M,1)
                if adjM(iVertex, kVertex) &&  adjM(jVertex, kVertex) && iVertex ~= kVertex && jVertex ~= kVertex
                    mijSum = mijSum + (M(iVertex, kVertex) + M(jVertex, kVertex));
                end
            end
            matchingIndex(iVertex, jVertex) = mijSum/(sum(M(iVertex, [1:(jVertex-1) (jVertex+1):size(M,2)]))+sum(M(jVertex, [1:(iVertex-1) (iVertex+1):size(M,2)])));
        end
    end
    pathTrans = zeros(size(M, 1));
    for sVertex = 1:(size(M,1)-1)
        for tVertex = (sVertex+1):size(M,2)
            pathSum = 0;
            if sVertex ~= tVertex
                pathVerts = shortestpath(G, sVertex, tVertex);
                for iVertex = 1:length(pathVerts)
                    for jVertex = 1:length(pathVerts)
                        pathSum = pathSum + matchingIndex(pathVerts(iVertex), pathVerts(jVertex));
                    end
                end
                pathTrans(sVertex, tVertex) = (2*pathSum)/(length(pathVerts)*(length(pathVerts)-1));
            end
        end
    end
    pathTrans = pathTrans + pathTrans';
end