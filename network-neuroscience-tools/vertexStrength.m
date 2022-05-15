function vertStr = vertexStrength(M, includeReflexive)
    % vertStr = vertexStrength(M, includeReflexive)
    % Input: 
    % M - A matrix representation of a graph
    % includeReflexive - Bool, whether to return the strength with
    % self-self edges
    % Output:
    % vertStr - An array of the vertex strengths
    % SET UP FOR GRAPH INPUT AND SINGLE NODES
    if includeReflexive
        vertStr = sum(M);
    else
        vertStr = sum(M-diag(diag(M)));
    end
end