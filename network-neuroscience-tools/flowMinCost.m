function [flow, minimumCost, flowGraph] = flowMinCost(capacityMatrix, costMatrix, source, sink, flowAmount)
    % Convert matrices representing edge cost and capacity, into graph
    % objects.
    capacityGraph = digraph(capacityMatrix-diag(diag(capacityMatrix)));
    costGraph = digraph(costMatrix-diag(diag(costMatrix)));
    
    % Create a graph to store flows in.
    flowMatrix = zeros(size(capacityMatrix));    
    
    flow = 0;
    pathDistance = 0;
    
    while pathDistance ~= Inf && flow < flowAmount
        % Find the shortest path between the source and sink.
        [pathNodes, pathDistance] = shortestpath(costGraph, source, sink);
        
        % Initialise variables
        clearEnds = [];
        
        % Move through the shortest path nodes, derive index and capacities 
        % for edges between nodes.
        edgeEnds = [pathNodes(1:end-1)' pathNodes(2:end)'];
        edgeIndexes = findedge(capacityGraph, edgeEnds(:,1), edgeEnds(:,2));
        edgeCapacities = capacityGraph.Edges.Weight(edgeIndexes);
        
        % Find the augmenting value, the minimum capacity edge on the path.
        [minEdgeCapacity, ~] = min(edgeCapacities);
        
        if (flow + minEdgeCapacity) <= flowAmount
            augmentingValue = minEdgeCapacity;
        elseif (flow + minEdgeCapacity) > flowAmount
            augmentingValue = flowAmount - flow;
        end
        
        % Reduce the capacity of edges in the path and and to the flow
        % graph.
        capacityGraph.Edges.Weight(edgeIndexes) = capacityGraph.Edges.Weight(edgeIndexes) - augmentingValue;
        flowMatrix(sub2ind(size(flowMatrix), edgeEnds(:,1), edgeEnds(:,2))) = flowMatrix(sub2ind(size(flowMatrix), edgeEnds(:,1), edgeEnds(:,2))) + minEdgeCapacity;
        
        % Flow in one direction, takes capacity from flow the other
        % direction.
        edgeIdx = findedge(capacityGraph, edgeEnds(:,2), edgeEnds(:,1));
        capacityGraph.Edges.Weight(edgeIdx) = capacityGraph.Edges.Weight(edgeIdx) - augmentingValue;
        
        clearEnds = edgeEnds(capacityGraph.Edges.Weight(edgeIndexes)==0,:);
        
        % Edges that are at capacity cannot be used, set weight to Inf.
        costGraph.Edges.Weight(findedge(costGraph, [clearEnds(:,1) clearEnds(:,2)], [clearEnds(:,2) clearEnds(:,1)])) = Inf;
    end
    
    % Determine the maximum flow from the flow graph.
    flow = sum(flowMatrix(:,sink));
    flowGraph = digraph(flowMatrix);
    
    % Determine the minimum cost from pointwise multiplication of cost and
    % flow
    minimumCost = sum(sum(flowMatrix.*costMatrix));
    
end