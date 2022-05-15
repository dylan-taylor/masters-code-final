function [sig, pvals] = testConnectomes(C1, C2)
    pvalsRaw = zeros(size(C1,1));
    for sVertex = 1:size(C1, 1)
        for tVertex = sVertex:size(C1, 2)
            [~, pvalsRaw(sVertex, tVertex)] = ttest2(squeeze(C1(sVertex, tVertex, :)), squeeze(C2(sVertex, tVertex, :)));
        end
    end
    pvalsSort = pvalsRaw(triu(true(377)));
    comparisonCount = ((size(C1,1)*(size(C1,1)-1))/2)+size(C1,1);
    BHFDRcriticalvalues = (1:comparisonCount)'*(1/comparisonCount)*0.05;
    criticalValueIndex = find(pvalsSort<BHFDRcriticalvalues, 1, 'last');
    criticalValue = pvalsSort(criticalValueIndex);
    if ~isempty(criticalValue)
        sig = triu(pvalsRaw<criticalValue);
        pvals = pvalsRaw;
    else
        sig = zeros(size(C1, 1));
        pvals = pvalsRaw;
    end
end