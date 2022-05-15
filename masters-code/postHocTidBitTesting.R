library('dplyr')
library('ggplot2')
library('jtools')

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

# Graph clustering max density test.

participantData$weightedCCMaxDensity <- read.csv(file = "discussion_post_hoc/weightedClusterCoefficientMaxDensity.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1
participantData$unweightedCCMaxDensity <- read.csv(file = "discussion_post_hoc/unweightedClusterCoefficientMaxDensity.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1

weightCCTest <- t.test(participantData$weightedCCMaxDensity~participantData$classification)

weightCCTest.sd <- c(sd(participantData$weightedCCMaxDensity[participantData$classification=='Control']), 
                     sd(participantData$weightedCCMaxDensity[participantData$classification=='aMCI']))

unweightCCTest <- t.test(participantData$unweightedCCMaxDensity~participantData$classification)

unweightCCTest.sd <- c(sd(participantData$unweightedCCMaxDensity[participantData$classification=='Control']), 
                       sd(participantData$unweightedCCMaxDensity[participantData$classification=='aMCI']))


strengthClustering <- read.csv(file = "discussion_post_hoc/strengthClusterArrayWithHeader.csv",  fileEncoding="UTF-8-BOM")


strengthClustering.lm <- lm(scale(clustering)~scale(log(strength))*classification, data = strengthClustering)

qplot(x = log(strength), y = clustering, data = strengthClustering, color = classification) +
  geom_point(color = "grey") +
  geom_smooth(method = "lm")


## FEF testing
participantData$FEFdegree <- read.csv(file = "discussion_post_hoc/L_FEF_degree.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1
participantData$FEFstrength <- read.csv(file = "discussion_post_hoc/L_FEF_strength.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1

FEFdegreeTest <- t.test(participantData$FEFdegree~participantData$classification)
FEFdegreeTest.sd <- c(sd(participantData$FEFdegree[participantData$classification=='Control']), 
                            sd(participantData$FEFdegree[participantData$classification=='aMCI']))

FEFstrengthTest <- t.test(participantData$FEFstrength~participantData$classification)
FEFstrengthTest.sd <- c(sd(participantData$FEFstrength[participantData$classification=='Control']), 
                        sd(participantData$FEFstrength[participantData$classification=='aMCI']))

participantData$L_Pol2_degree <- read.csv(file = "discussion_post_hoc/L_Pol2_degree.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1
participantData$L_Pol2_strength <- read.csv(file = "discussion_post_hoc/L_Pol2_strength.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1

L_Pol2_degreeTest <- t.test(participantData$L_Pol2_degree~participantData$classification)
L_Pol2_degreeTest.sd <- c(sd(participantData$L_Pol2_degree[participantData$classification=='Control']), 
                        sd(participantData$L_Pol2_degree[participantData$classification=='aMCI']))

L_Pol2_strengthTest <- t.test(participantData$L_Pol2_strength~participantData$classification)
L_Pol2_strengthTest.sd <- c(sd(participantData$L_Pol2_strength[participantData$classification=='Control']), 
                            sd(participantData$L_Pol2_strength[participantData$classification=='aMCI']))

participantData$R_d23ab_degree <- read.csv(file = "discussion_post_hoc/R_d23ab_degree.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1
participantData$R_d23ab_strength <- read.csv(file = "discussion_post_hoc/R_d23ab_strength.csv",  fileEncoding="UTF-8-BOM", header =  FALSE)$V1
R_d23ab_degreeTest <- t.test(participantData$R_d23ab_degree~participantData$classification)
R_d23ab_degreeTest.sd <- c(sd(participantData$R_d23ab_degree[participantData$classification=='Control']), 
                            sd(participantData$R_d23ab_degree[participantData$classification=='aMCI']))

R_d23ab_strengthTest <- t.test(participantData$R_d23ab_strength~participantData$classification)
R_d23ab_strengthTest.sd <- c(sd(participantData$R_d23ab_strength[participantData$classification=='Control']), 
                            sd(participantData$R_d23ab_strength[participantData$classification=='aMCI']))

## Testing to understand where flow failed to capture
participantData$avgMinStrength <- read.csv(file = "./graph_weighted_metrics/avgMinStrength.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
avgMinStrengthTest <- t.test(participantData$avgMinStrength~participantData$classification)
avgMinStrengthTest.sd <- c(sd(participantData$avgMinStrength[participantData$classification=='Control']), 
                           sd(participantData$avgMinStrength[participantData$classification=='aMCI']))

# Testing the average slack between maxflow and minstrength
participantData$avgSlack <- read.csv(file = "./graph_weighted_metrics/avgSlack.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
avgSlackTest <- t.test(participantData$avgSlack~participantData$classification)
avgSlackTest.sd <- c(sd(participantData$avgSlack[participantData$classification=='Control']), 
                           sd(participantData$avgSlack[participantData$classification=='aMCI']))


participantData$avgBinarisedFlow <- read.csv(file = "./graph_threshold_overview/avgBinarisedFlow.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
avgBinarisedFlowTest <- t.test(participantData$avgBinarisedFlow~participantData$classification)
avgBinarisedFlowTest.sd <- c(sd(participantData$avgBinarisedFlow[participantData$classification=='Control']), 
                         sd(participantData$avgBinarisedFlow[participantData$classification=='aMCI']))

avgBinarisedFlowAgeTest <- cor.test(participantData$avgBinarisedFlow,participantData$age)

