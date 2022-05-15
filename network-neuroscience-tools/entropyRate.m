function H_rate = entropyRate(M)
    % Input probability matrix that represents a markov chain.
    %% Determine asymptotic distribution, rough and ready.
    % Should refine this, but the general case method looks time intesive
    start = ones(length(M),1)./length(M);

    asymDist = M^10000*start;

    H_rate = 0;
    for s = 1:length(M)
        for t = 1:length(M)
            if M(s,t) > 0
                H_rate = H_rate + -(asymDist(s)*M(s,t)*log2(M(s,t)));
            end
        end
    end
end