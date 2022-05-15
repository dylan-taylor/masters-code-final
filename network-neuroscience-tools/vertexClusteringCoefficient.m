function c_i = vertexClusteringCoefficient(i, M)
    % Inputs:
    % i - Vertex idx.
    % M - Graph Matrix.
    % Outputs:
    % c_i - The ith vertex's clustering coefficient
    
    s_i = sum(M(i,:))-M(i,i);
    
    adjM = M>0;

    k_i = sum(adjM(i,:))-adjM(i,i);
    if k_i == 0 || k_i == 1
        c_i = 0;
    else
        weightedAdjacencySum = 0;
        for j = 1:size(M,1)
            if j ~= i && adjM(i,j) == 1 
                for m = 1:size(M,2)
                    if m ~= i && adjM(j,m) == 1 && adjM(m,i) == 1
                        weightedAdjacencySum = weightedAdjacencySum + (M(i,j)+M(i,m))/2;
                    end
                end
            end
        end
        c_i = (1/(s_i*(k_i-1)))*weightedAdjacencySum;
    end
end