n = 1;
N = 3;
vertexCount = 377;
% Set-up Log file
fid = fopen('maxflowRun_log.txt', 'a');
if fid == -1
  error('Cannot open log file.');
end

fprintf(fid, '%s: %s\n', datestr(now, 0), "Starting Process...");

participant_data = readtable('participant_demographics.csv');
% Pre-assign matrices where possible
countConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
lengthConnectomes = zeros(vertexCount, vertexCount, length(participant_data.participant_id));
minCostMatrix = zeros(vertexCount, vertexCount);
maxFlowMatrix = zeros(vertexCount, vertexCount);
flowArray = cell(vertexCount,vertexCount);
% Import and derive the metrics from the connectomes
for iParticipant = 1:length(participant_data.participant_id)  
    % Read in connectome for participant i
    countConnectomes(:,:,iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_counts\', participant_data.participant_id{iParticipant}, '_hcpmmp1_connectome_MERGED.csv'));
    zero_diag = countConnectomes(:,:,iParticipant).*(ones(vertexCount,vertexCount)-diag(ones(vertexCount,1)));
    
    % Read in mean tract lengths for participant i
    lengthConnectomes(:,:,iParticipant) = readmatrix(strcat('.\final_analysis\connectome_data\connectome_lengths\', participant_data.participant_id{iParticipant}, '_hcpmmp1_connectome_length_MERGED.csv'));
end

for iParticipant = n:N
    fprintf(fid, '%s: %s\n', datestr(now, 0), strcat("Subject - ", participant_data.participant_id{iParticipant}));
    subjectFile = strcat("./final_analysis/connectome_data/maxflow/", participant_data.participant_id{iParticipant});
    flowFile = strcat(subjectFile,"/flow_graphs");
    mkdir(subjectFile);
    mkdir(flowFile);
    for s = 1:vertexCount
        parfor t = (s+1):vertexCount
            disp(strcat(string(s), " ", string(t)))
            [maxFlowMatrix(s,t,iParticipant), minCostMatrix(s,t,iParticipant), flowGraph] = flowMinCost(countConnectomes(:,:,iParticipant), lengthConnectomes(:,:,iParticipant), s, t, Inf);
            flowArray{s,t}=adjacency(flowGraph,'weighted');
        end
    end
    save(strcat(subjectFile,"/",participant_data.participant_id{iParticipant},"_maxflow.mat"),'flowArray');
    writematrix(maxFlowMatrix(:,:,iParticipant)+maxFlowMatrix(:,:,iParticipant)', strcat(subjectFile,"/",participant_data.participant_id{iParticipant},"_maxflow.csv"))
    writematrix(minCostMatrix(:,:,iParticipant)+minCostMatrix(:,:,iParticipant)', strcat(subjectFile,"/",participant_data.participant_id{iParticipant},"_mincost.csv"))
end

fprintf(fid, '%s: %s\n', datestr(now, 0), "... Process Finished");