% Merge counts, keep note of them for averaging lengths
participant_data = readtable('demo_data.xlsx');

for i = 1:length(participant_data.participant_id)  
    % Read in connectome for participant i
    connectomeCounts = readmatrix(strcat('connectome_data/connectome_counts/', participant_data.participant_id{i}, '_hcpmmp1_connectome.csv'));
    
    connectomeCountsMerged = connectomeCounts;
    
    % Merge counts for H and Hippocampus Labels Left Side
    connectomeCountsMerged(:, 366) = connectomeCountsMerged(:, 366) + connectomeCounts(:, 120);
    connectomeCountsMerged(366, :) = connectomeCountsMerged(366, :) + connectomeCounts(120, :);
    % Correct for transpose double counting
    connectomeCountsMerged(366, 366) = connectomeCountsMerged(366, 366) - connectomeCounts(120, 120);
    
    % Set counts for L_H to 0, to prevent double counting
    connectomeCounts(:,120) = connectomeCounts(:,120).*0;
    connectomeCounts(120,:) = connectomeCounts(120,:).*0;
    
    % Merge counts for H and Hippocampus Labels Right Side
    connectomeCountsMerged(:, 375) = connectomeCountsMerged(:, 375) + connectomeCounts(:, 300);
    connectomeCountsMerged(375, :) = connectomeCountsMerged(375, :) + connectomeCounts(300, :);
    % Correct for transpose double counting.
    connectomeCountsMerged(375, 375) = connectomeCountsMerged(375, 375) - connectomeCounts(300, 300);
    
    % Average length as weighted average of old labels.
    connectomeLengths = readmatrix(strcat('connectome_data/connectome_lengths/', participant_data.participant_id{i}, '_hcpmmp1_connectome_length.csv'));
    
    % Calculate new average for tract lengths in connectom LH
    weightH = connectomeCounts(:,120)./(connectomeCounts(:,120)+connectomeCounts(:,366));
    weightH(isnan(weightH)) = 0;
    weightHippocampus = connectomeCounts(:,366)./(connectomeCounts(:,120)+connectomeCounts(:,366));
    weightHippocampus(isnan(weightHippocampus)) = 0;
    avgLengths = weightH.*connectomeLengths(:,120)+weightHippocampus.*connectomeLengths(:,366);
    
    connectomeLengthsMerged = connectomeLengths;
    connectomeLengthsMerged(:,366) = avgLengths;
    connectomeLengthsMerged(366,:) = avgLengths;
    
    % Calculate new average for tract lengths in connectom RH
    weightH = connectomeCounts(:,300)./(connectomeCounts(:,300)+connectomeCounts(:,375));
    weightH(isnan(weightH)) = 0;
    weightHippocampus = connectomeCounts(:,375)./(connectomeCounts(:,300)+connectomeCounts(:,375));
    weightHippocampus(isnan(weightHippocampus)) = 0;
    avgLengths = weightH.*connectomeLengths(:,300)+weightHippocampus.*connectomeLengths(:,375);
    
    connectomeLengthsMerged = connectomeLengths;
    connectomeLengthsMerged(:,375) = avgLengths;
    connectomeLengthsMerged(375,:) = avgLengths;
    
    % Cut L_H and R_H from counts.
    connectomeCountsMerged(:,300) = [];
    connectomeCountsMerged(:,120) = [];
    connectomeCountsMerged(300,:) = [];
    connectomeCountsMerged(120,:) = [];
    
    % Cut L_H and R_H from lengths.
    connectomeLengthsMerged(:,300) = [];
    connectomeLengthsMerged(:,120) = [];
    connectomeLengthsMerged(300,:) = [];
    connectomeLengthsMerged(120,:) = [];
    
    % Save to Files
    writematrix(connectomeCountsMerged, strcat('connectome_data/connectome_counts/', participant_data.participant_id{i}, '_hcpmmp1_connectome_MERGED.csv'))
    writematrix(connectomeLengthsMerged, strcat('connectome_data/connectome_lengths/', participant_data.participant_id{i}, '_hcpmmp1_connectome_length_MERGED.csv'))
end

