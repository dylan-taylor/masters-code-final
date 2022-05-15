# Import participant demographic data.
participantData <- read.csv(file = "participant_demographics.csv",  fileEncoding="UTF-8-BOM")
participantData$classification <- as.factor(participantData$classification)

# Set gender to readable names.DOUBLE-CHECK-THESE-CLASSIFICATION
participantData$gender[participantData$gender=="1"] <- "Female"
participantData$gender[participantData$gender=="2"] <- "Male"

participantData$gender <- as.factor(participantData$gender)

# Beautify data frame
participantData$classification <- factor(participantData$classification, levels = c('Control', 'aMCI'))
participantData <- participantData[c('participant_id', 'classification', 'gender', 'age', 'ACEIII')]

participantData$meanInvCountCloseness <- read.csv(file = "graph_vertex_metrics/meanInvCountCloseness.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$meanLengthCloseness <- read.csv(file = "graph_vertex_metrics/meanLengthCloseness.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$meanInfoInCloseness <- read.csv(file = "graph_vertex_metrics/meanInfoInCloseness.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$meanInfoOutCloseness <- read.csv(file = "graph_vertex_metrics/meanInfoOutCloseness.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1

participantData$meanInvCountBetweeness <- read.csv(file = "graph_vertex_metrics/meanInvCountBetweeness.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$meanLengthBetweeness <- read.csv(file = "graph_vertex_metrics/meanLengthBetweeness.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$meanInfoBetweeness <- read.csv(file = "graph_vertex_metrics/meanInfoBetweeness.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1

participantData$meanCountEigenvector <- read.csv(file = "graph_vertex_metrics/meanCountEigenvector.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1

participantData$meanVertexEntropy <- read.csv(file = "graph_vertex_metrics/meanVertexEntropy.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1

# closeness
t.test(participantData$meanInvCountCloseness~participantData$classification)
meanInvCountCloseness.sd <- c(sd(participantData$meanInvCountCloseness[participantData$classification=='Control']), 
                              sd(participantData$meanInvCountCloseness[participantData$classification=='aMCI']))

t.test(participantData$meanLengthCloseness~participantData$classification)
meanLengthCloseness.sd <- c(sd(participantData$meanLengthCloseness[participantData$classification=='Control']), 
                            sd(participantData$meanLengthCloseness[participantData$classification=='aMCI']))

t.test(participantData$meanInfoInCloseness~participantData$classification)
meanInfoInCloseness.sd <- c(sd(participantData$meanInfoInCloseness[participantData$classification=='Control']), 
                            sd(participantData$meanInfoInCloseness[participantData$classification=='aMCI']))

t.test(participantData$meanInfoOutCloseness~participantData$classification)
meanInfoOutCloseness.sd <- c(sd(participantData$meanInfoOutCloseness[participantData$classification=='Control']), 
                             sd(participantData$meanInfoOutCloseness[participantData$classification=='aMCI']))
# betweenness
t.test(participantData$meanInvCountBetweeness~participantData$classification)
meanInvCountBetweeness.sd <- c(sd(participantData$meanInvCountBetweeness[participantData$classification=='Control']), 
                               sd(participantData$meanInvCountBetweeness[participantData$classification=='aMCI']))

t.test(participantData$meanLengthBetweeness~participantData$classification)
meanLengthBetweeness.sd <- c(sd(participantData$meanLengthBetweeness[participantData$classification=='Control']), 
                            sd(participantData$meanLengthBetweeness[participantData$classification=='aMCI']))

t.test(participantData$meanInfoBetweeness~participantData$classification)
meanInfoBetweeness.sd <- c(sd(participantData$meanInfoBetweeness[participantData$classification=='Control']), 
                           sd(participantData$meanInfoBetweeness[participantData$classification=='aMCI']))

# entropy
t.test(participantData$meanVertexEntropy~participantData$classification)
meanVertexEntropy.sd <- c(sd(participantData$meanVertexEntropy[participantData$classification=='Control']), 
                          sd(participantData$meanVertexEntropy[participantData$classification=='aMCI']))
