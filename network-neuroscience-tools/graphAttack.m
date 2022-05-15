function [failureGraphs] = graphAttack(connectome, steps, attack)
%[failureGraphs] = strengthFailure(connectome, steps)
% Inputs:
% connectome - Adjaceny matrix of graph.
% steps - Number of vertices to remove.
% attack - method of attack: strength, betweenness
% Output:
% failureGraphs - A cell array of adjacency matrices.

    if steps > size(connectome,1)
        error("Number of vertices to remove is greater than number of vertices")
    end
    
    failureGraphs = cell(steps, 1);
    
    G = graph(connectome);
    
    for iStep = 1:steps
        connectome = full(adjacency(G));
        if strcmp(attack, 'strength')
           vertStrengths =  vertexStrength(connectome, true);
           [~, orderedVerts] = sort(vertStrengths, 'descend');
        elseif strcmp(attack, 'betweenness')
           vertBetweenness = centrality(G, 'betweenness');
           [~, orderedVerts] = sort(vertBetweenness, 'descend');
        elseif strcmp(attack, 'degree')
           vertDegrees =  vertexStrength((connectome>0), false);
           [~, orderedVerts] = sort(vertDegrees, 'descend');
        end
        G = rmnode(G, orderedVerts(1));
        failureGraphs{iStep} = full(adjacency(G));
    end
    
end

