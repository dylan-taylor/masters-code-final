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

# Import integral statistics
participantData$invCountCplThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/invCountCplThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$lengthCplThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/lengthCplThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$infoCplThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/infoCplThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1 
participantData$invCountEglobThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/invCountEglobThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$lengthEglobThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/lengthEglobThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$infoEglobThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/infoEglobThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1 
participantData$countClusterThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/countClusterThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$countAssortativityThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/countAssortativityThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$entropyRateThreshIntegral <- read.csv(file = "graph_threshold_metrics/integral/entropyRateThreshIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1

# Perform t-tests across all parameters
t.test(participantData$invCountCplThreshIntegral~participantData$classification)
t.test(participantData$lengthCplThreshIntegral~participantData$classification)
t.test(participantData$infoCplThreshIntegral~participantData$classification)
t.test(participantData$invCountEglobThreshIntegral~participantData$classification)
t.test(participantData$lengthEglobThreshIntegral~participantData$classification)
t.test(participantData$infoEglobThreshIntegral~participantData$classification)
t.test(participantData$countClusterThreshIntegral~participantData$classification)
t.test(participantData$countAssortativityThreshIntegral~participantData$classification)
t.test(participantData$entropyRateThreshIntegral~participantData$classification)

# Import integral statistics
participantData$cplBinIntegral <- read.csv(file = "graph_binary_metrics/integral/cplBinIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$infoCplBinIntegral <- read.csv(file = "graph_binary_metrics/integral/infoCplBinIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1 
participantData$eglobBinIntegral <- read.csv(file = "graph_binary_metrics/integral/eglobBinIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$infoEglobBinIntegral <- read.csv(file = "graph_binary_metrics/integral/infoEglobBinIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1 
participantData$clusterBinIntegral <- read.csv(file = "graph_binary_metrics/integral/clusterBinIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$assortativityBinIntegral <- read.csv(file = "graph_binary_metrics/integral/assortativityBinIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$entropyRateBinIntegral <- read.csv(file = "graph_binary_metrics/integral/entropyRateBinIntegral.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1

# Perform t-tests across all parameters
t.test(participantData$cplBinIntegral~participantData$classification)
t.test(participantData$infoCplBinIntegral~participantData$classification)
t.test(participantData$eglobBinIntegral~participantData$classification)
t.test(participantData$infoEglobBinIntegral~participantData$classification)
t.test(participantData$clusterBinIntegral~participantData$classification)
t.test(participantData$assortativityBinIntegral~participantData$classification)
t.test(participantData$entropyRateBinIntegral~participantData$classification)
t.test(participantData$countAssortativityThreshIntegral~participantData$classification)
t.test(participantData$entropyRateThreshIntegral~participantData$classification)

