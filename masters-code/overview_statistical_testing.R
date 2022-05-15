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

participantData$radialSearchTotalWeights <- read.csv(file = "./graph_overview_metrics/radialSearchTotalWeights.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$radialSearchEdgeDensities <- read.csv(file = "./graph_overview_metrics/radialSearchEdgeDensities.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

participantData$eTIV <- read.csv(file = "eTIV.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
# Demographic Statistics -------------------------------------------------------

# Summary statistics
summary(participantData)

# Demographic tests
demographicTests.gender <- chisq.test(participantData$classification, participantData$gender, correct = FALSE)
demographicTests.gender.counts <- table(participantData$gender, participantData$classification)

demographicTests.age <- t.test(participantData$age~participantData$classification)
demographicTests.age.sd <- c(sd(participantData$age[participantData$classification=='Control']), 
                             sd(participantData$age[participantData$classification=='aMCI']))

demographicTests.ACEIII <- t.test(participantData$ACEIII~participantData$classification)
demographicTests.ACEIII.sd <- c(sd(participantData$ACEIII[participantData$classification=='Control']), 
                                sd(participantData$ACEIII[participantData$classification=='aMCI']))

demographicTests.eTIV <- t.test(participantData$eTIV~participantData$classification)
demographicTests.eTIV.sd <- c(sd(participantData$eTIV[participantData$classification=='Control']), 
                                sd(participantData$eTIV[participantData$classification=='aMCI']))

genderTests.eTIV <- t.test(participantData$eTIV~participantData$gender)
genderTests.eTIV.sd <- c(sd(participantData$eTIV[participantData$gender=='Female']), 
                              sd(participantData$eTIV[participantData$gender=='Male']))

# SET UP FOR APA STYLE, CURRENT USE IS FOR UNDERSTANDING
demographicPlots.gender <- ggplot(participantData, aes(x = classification, fill = gender)) + 
                           geom_bar(width = 0.95)

demographicPlots.age <- ggplot(participantData, aes(x = classification, y = age, fill = classification)) + 
                        geom_violin() +
                        geom_boxplot(width=0.1, color="black", alpha=0.2)

demographicPlots.ACEIII <- ggplot(participantData, aes(x = classification, y = ACEIII, fill = classification)) + 
                        geom_violin() +
                        geom_boxplot(width=0.1, color="black", alpha=0.2)

# Graph overview statistics ----------------------------------------------------
participantData$connectedComponents <- read.csv(file = "./graph_overview_metrics/connectedComponents.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$edgeDensities <- read.csv(file = "./graph_overview_metrics/edgeDensities.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1
participantData$totalWeights <- read.csv(file = "./graph_overview_metrics/totalWeights.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1
participantData$reflexivity <- read.csv(file = "./graph_overview_metrics/reflexivity.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1
participantData$avgTractLength <- read.csv(file = "./graph_overview_metrics/avgTractLength.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1

# SHOULD PROBABLY TEST ASSUMPTIONS
overviewTest.edgeDensities <- t.test(participantData$edgeDensities~participantData$classification)
overviewTest.edgeDensities.sd <- c(sd(participantData$edgeDensities[participantData$classification=='Control']), 
                                 sd(participantData$edgeDensities[participantData$classification=='aMCI']))

overviewTest.radialSearchEdgeDensities <- t.test(participantData$radialSearchEdgeDensities~participantData$classification)
overviewTest.radialSearchEdgeDensities.sd <- c(sd(participantData$radialSearchEdgeDensities[participantData$classification=='Control']), 
                                   sd(participantData$radialSearchEdgeDensities[participantData$classification=='aMCI']))

cor.test(participantData$edgeDensities, participantData$radialSearchEdgeDensities)

overviewTest.totalWeights <- t.test(participantData$totalWeights~participantData$classification)
overviewTest.totalWeights.sd <- c(sd(participantData$totalWeights[participantData$classification=='Control']), 
                                  sd(participantData$totalWeights[participantData$classification=='aMCI']))

overviewTest.radialSearchTotalWeights <- t.test(participantData$radialSearchTotalWeights~participantData$classification)
overviewTest.radialSearchTotalWeights.sd <- c(sd(participantData$radialSearchTotalWeights[participantData$classification=='Control']), 
                                  sd(participantData$radialSearchTotalWeights[participantData$classification=='aMCI']))

cor.test(participantData$totalWeights, participantData$radialSearchTotalWeights)

overviewTest.reflexivity <- t.test(participantData$reflexivity~participantData$classification)
overviewTest.reflexivity.sd <- c(sd(participantData$reflexivity[participantData$classification=='Control']), 
                                 sd(participantData$reflexivity[participantData$classification=='aMCI']))

overviewTest.avgTractLength <- t.test(participantData$avgTractLength~participantData$classification)
overviewTest.avgTractLength.sd <- c(sd(participantData$avgTractLength[participantData$classification=='Control']), 
                                 sd(participantData$avgTractLength[participantData$classification=='aMCI']))


overviewPlots.edgeDensities <- ggplot(participantData, aes(x = classification, y = edgeDensities, fill = classification)) + 
                               geom_violin() +
                               geom_boxplot(width=0.1, color="black", alpha=0.2)
overviewPlots.totalWeights <- ggplot(participantData, aes(x = classification, y = totalWeights, fill = classification)) + 
                              geom_violin() +
                              geom_boxplot(width=0.1, color="black", alpha=0.2)
overviewPlots.reflexivity <- ggplot(participantData, aes(x = classification, y = reflexivity, fill = classification)) + 
                             geom_violin() +
                             geom_boxplot(width=0.1, color="black", alpha=0.2)

# Graph weighted statistics ----------------------------------------------------

# Import characteristic path length metrics
participantData$countCpl <- read.csv(file = "./graph_weighted_metrics/countCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$lengthCpl <- read.csv(file = "./graph_weighted_metrics/lengthCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoCpl <- read.csv(file = "./graph_weighted_metrics/infoCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoNoReflexCpl <- read.csv(file = "./graph_weighted_metrics/infoNoReflexCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

overviewTest.countCpl <- t.test(participantData$countCpl~participantData$classification)
overviewTest.countCpl.sd <- c(sd(participantData$countCpl[participantData$classification=='Control']), 
                              sd(participantData$countCpl[participantData$classification=='aMCI']))

overviewTest.lengthCpl <- t.test(participantData$lengthCpl~participantData$classification)
overviewTest.lengthCpl.sd <- c(sd(participantData$lengthCpl[participantData$classification=='Control']), 
                               sd(participantData$lengthCpl[participantData$classification=='aMCI']))

overviewTest.infoNoReflexCpl <- t.test(participantData$infoNoReflexCpl~participantData$classification)
overviewTest.infoNoReflexCpl.sd <- c(sd(participantData$infoNoReflexCpl[participantData$classification=='Control']), 
                                     sd(participantData$infoNoReflexCpl[participantData$classification=='aMCI']))

overviewTest.infoCpl <- t.test(participantData$infoCpl~participantData$classification)
overviewTest.infoCpl.sd <- c(sd(participantData$infoCpl[participantData$classification=='Control']), 
                             sd(participantData$infoCpl[participantData$classification=='aMCI']))

# Import global efficiency metrics
participantData$countEglob <- read.csv(file = "./graph_weighted_metrics/countEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$lengthEglob <- read.csv(file = "./graph_weighted_metrics/lengthEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoEglob <- read.csv(file = "./graph_weighted_metrics/infoEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoNoReflexEglob <- read.csv(file = "./graph_weighted_metrics/infoNoReflexEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

overviewTest.countEglob <- t.test(participantData$countEglob~participantData$classification)
overviewTest.countEglob.sd <- c(sd(participantData$countEglob[participantData$classification=='Control']), 
                                sd(participantData$countEglob[participantData$classification=='aMCI']))

overviewTest.lengthEglob <- t.test(participantData$lengthEglob~participantData$classification)
overviewTest.lengthEglob.sd <- c(sd(participantData$lengthEglob[participantData$classification=='Control']), 
                                 sd(participantData$lengthEglob[participantData$classification=='aMCI']))

overviewTest.infoNoReflexEglob <- t.test(participantData$infoNoReflexEglob~participantData$classification)
overviewTest.infoNoReflexEglob.sd <- c(sd(participantData$infoNoReflexEglob[participantData$classification=='Control']), 
                                       sd(participantData$infoNoReflexEglob[participantData$classification=='aMCI']))

overviewTest.infoEglob <- t.test(participantData$infoEglob~participantData$classification)
overviewTest.infoEglob.sd <- c(sd(participantData$infoEglob[participantData$classification=='Control']), 
                               sd(participantData$infoEglob[participantData$classification=='aMCI']))

# Import clustering metrics - ADD/DERIVE CLUSTERING WEIGHT TO UNWEIGHT RATIO
participantData$countWeightedCluster <- read.csv(file = "./graph_weighted_metrics/countWeightedCluster.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$countCluster <- read.csv(file = "./graph_weighted_metrics/countCluster.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

overviewTest.countWeightedCluster <- t.test(participantData$countWeightedCluster~participantData$classification)
overviewTest.countWeightedCluster.sd <- c(sd(participantData$countWeightedCluster[participantData$classification=='Control']), 
                                          sd(participantData$countWeightedCluster[participantData$classification=='aMCI']))

overviewTest.countCluster <- t.test(participantData$countCluster~participantData$classification)
overviewTest.countCluster.sd <- c(sd(participantData$countCluster[participantData$classification=='Control']), 
                                  sd(participantData$countCluster[participantData$classification=='aMCI']))

participantData$clusterRatio <- participantData$countWeightedCluster/participantData$countCluster

overviewTest.clusterRatio <- t.test(participantData$clusterRatio~participantData$classification)
overviewTest.clusterRatio.sd <- c(sd(participantData$clusterRatio[participantData$classification=='Control']), 
                                  sd(participantData$clusterRatio[participantData$classification=='aMCI']))

# Import search information metric.
participantData$avgSearchInformation <- read.csv(file = "./graph_weighted_metrics/avgSearchInformation.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$avgLengthSearchInformation <- read.csv(file = "./graph_weighted_metrics/avgLengthSearchInformation.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
overviewTest.avgSearchInformation <- t.test(participantData$avgSearchInformation~participantData$classification)
overviewTest.avgSearchInformation.sd <- c(sd(participantData$avgSearchInformation[participantData$classification=='Control']), 
                                          sd(participantData$avgSearchInformation[participantData$classification=='aMCI']))


# Path transitivity
participantData$avgPathTransitivity <- read.csv(file = "./graph_weighted_metrics/avgPathTransitivity.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
overviewTest.avgPathTransitivity <- t.test(participantData$avgPathTransitivity~participantData$classification)
overviewTest.avgPathTransitivity.sd <- c(sd(participantData$avgPathTransitivity[participantData$classification=='Control']), 
                                         sd(participantData$avgPathTransitivity[participantData$classification=='aMCI']))

# Import entropy rate
participantData$entropyRate <- read.csv(file = "./graph_weighted_metrics/entropyRate.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
overviewTest.entropyRate <- t.test(participantData$entropyRate~participantData$classification)
overviewTest.entropyRate.sd <- c(sd(participantData$entropyRate[participantData$classification=='Control']), 
                                sd(participantData$entropyRate[participantData$classification=='aMCI']))

# Import assortativity coefficients
participantData$countWeightedAssortativity <- read.csv(file = "./graph_weighted_metrics/countWeightedAssortativity.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$countAssortativity <- read.csv(file = "./graph_weighted_metrics/countAssortativity.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

overviewTest.countWeightedAssortativity <- t.test(participantData$countWeightedAssortativity~participantData$classification)
overviewTest.countWeightedAssortativity.sd <- c(sd(participantData$countWeightedAssortativity[participantData$classification=='Control']), 
                                                sd(participantData$countWeightedAssortativity[participantData$classification=='aMCI']))

overviewTest.countAssortativity <- t.test(participantData$countAssortativity~participantData$classification)
overviewTest.countAssortativity.sd <- c(sd(participantData$countAssortativity[participantData$classification=='Control']), 
                                        sd(participantData$countAssortativity[participantData$classification=='aMCI']))

participantData$assortativityRatio <- participantData$countWeightedAssortativity/participantData$countAssortativity

overviewTest.assortativityRatio <- t.test(participantData$assortativityRatio~participantData$classification)
overviewTest.assortativityRatio.sd <- c(sd(participantData$assortativityRatio[participantData$classification=='Control']), 
                                        sd(participantData$assortativityRatio[participantData$classification=='aMCI']))

# Import flow statistics
participantData$avgGraphFlow <- read.csv(file = "./graph_weighted_metrics/avgGraphFlow.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$avgGraphCost <- read.csv(file = "./graph_weighted_metrics/avgGraphCost.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
participantData$avgGraphInfoCost <- read.csv(file = "./graph_weighted_metrics/avgGraphInfoCost.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1

t.test(participantData$avgGraphFlow~participantData$classification)
avgGraphFlow.sd <- c(sd(participantData$avgGraphFlow[participantData$classification=='Control']), 
                     sd(participantData$avgGraphFlow[participantData$classification=='aMCI']))

t.test(participantData$avgGraphCost~participantData$classification)
avgGraphCost.sd <- c(sd(participantData$avgGraphCost[participantData$classification=='Control']), 
                     sd(participantData$avgGraphCost[participantData$classification=='aMCI']))

t.test(participantData$avgGraphInfoCost~participantData$classification)
avgGraphInfoCost.sd <- c(sd(participantData$avgGraphInfoCost[participantData$classification=='Control']), 
                     sd(participantData$avgGraphInfoCost[participantData$classification=='aMCI']))

# Some other graph metrics
participantData$minConnDensity <- read.csv(file = "./graph_overview_metrics/minConnDensity.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
t.test(participantData$minConnDensity~participantData$classification)

participantData$avgStrengths <- read.csv(file = "./graph_overview_metrics/avgStrengths.csv",  fileEncoding="UTF-8-BOM", header = FALSE)$V1
avgStrengths.ttest <- t.test(participantData$avgStrengths~participantData$classification)
avgStrengths.sd <- c(sd(participantData$avgStrengths[participantData$classification=='Control']), 
                     sd(participantData$avgStrengths[participantData$classification=='aMCI']))

# Testing the relationship between eTIV and other measures.
cor.test(participantData$eTIV, participantData$totalWeights)
cor.test(participantData$eTIV, participantData$edgeDensities)
cor.test(participantData$eTIV, participantData$avgTractLength)
cor.test(participantData$eTIV, participantData$reflexivity)
