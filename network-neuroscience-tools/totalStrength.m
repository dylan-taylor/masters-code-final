function totStr = totalStrength(M, includeReflexive)
    % Input: 
    % M - A matrix representation of a graph
    % includeReflexive - Bool, whether to return the strength with
    % self-self edges
    % Output:
    % totStr - Sum of all edge weights
    if includeReflexive
        totStr = sum(triu(M), 'all');
    else
        totStr = sum(triu(M, 1), 'all');
    end
end