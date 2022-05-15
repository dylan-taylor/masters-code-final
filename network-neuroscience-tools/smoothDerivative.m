function dervativeM = smoothDerivative(M)
    smoothM = smoothdata(M, 2);
    dervativeM = ((smoothM(:,3:length(smoothM))-smoothM(:,1:(length(smoothM)-2)))/2);
end

