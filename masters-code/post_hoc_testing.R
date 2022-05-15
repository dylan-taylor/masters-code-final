library('dplyr')
library('ggplot2')
library('jtools')
#library('flextable')

meansd_format <- function(metric, gender, dec) {
  return(paste(round(metric$estimate[gender], digits = dec),' (',round(metric$sd[gender], digits = dec),')', sep = ''))
}

teststat_format <- function(metric) {
  return(paste('t(',round(metric$parameter, digits = 2) ,') = ', round(metric$statistic, digits = 2), '\np = ',round(metric$p.value, digits = 3), sep = ''))
}

# REPLACE ALL CORRELATION TESTS WITH THE CORRELATION MATRIX

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




# Import data ----------------------------------------------------
#participantData$connectedComponents <- read.csv(file = "./graph_overview_metrics/connectedComponents.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$edgeDensities <- read.csv(file = "./graph_overview_metrics/edgeDensities.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1
participantData$totalWeights <- read.csv(file = "./graph_overview_metrics/totalWeights.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1
participantData$reflexivity <- read.csv(file = "./graph_overview_metrics/reflexivity.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1
participantData$avgTractLength <- read.csv(file = "./graph_overview_metrics/avgTractLength.csv", header = FALSE,  fileEncoding="UTF-8-BOM")$V1


participantData$countCpl <- read.csv(file = "./graph_weighted_metrics/countCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$lengthCpl <- read.csv(file = "./graph_weighted_metrics/lengthCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoCpl <- read.csv(file = "./graph_weighted_metrics/infoCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoNoReflexCpl <- read.csv(file = "./graph_weighted_metrics/infoNoReflexCpl.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

participantData$countEglob <- read.csv(file = "./graph_weighted_metrics/countEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$lengthEglob <- read.csv(file = "./graph_weighted_metrics/lengthEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoEglob <- read.csv(file = "./graph_weighted_metrics/infoEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$infoNoReflexEglob <- read.csv(file = "./graph_weighted_metrics/infoNoReflexEglob.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

participantData$countWeightedCluster <- read.csv(file = "./graph_weighted_metrics/countWeightedCluster.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$countCluster <- read.csv(file = "./graph_weighted_metrics/countCluster.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$clusterRatio <- participantData$countWeightedCluster/participantData$countCluster

participantData$avgSearchInformation <- read.csv(file = "./graph_weighted_metrics/avgSearchInformation.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

participantData$entropyRate <- read.csv(file = "./graph_weighted_metrics/entropyRate.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

participantData$countWeightedAssortativity <- read.csv(file = "./graph_weighted_metrics/countWeightedAssortativity.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1
participantData$countAssortativity <- read.csv(file = "./graph_weighted_metrics/countAssortativity.csv", header = FALSE, fileEncoding="UTF-8-BOM")$V1

participantData$assortativityRatio <- participantData$countWeightedAssortativity/participantData$countAssortativity

# Tests with other demographic data --------------------------------------------

# General overview
postHoc.avgTractLength.gender  <- t.test(participantData$avgTractLength~participantData$gender)

# CPL and Global Efficiency
postHoc.countCpl.gender  <- t.test(participantData$countCpl~participantData$gender)
postHoc.countCpl.gender$sd <- c(sd(participantData$countCpl[participantData$gender=='Female']), 
                                sd(participantData$countCpl[participantData$gender=='Male']))

postHoc.countCpl.age  <- lm(participantData$countCpl~ participantData$age)
postHoc.countCpl.ACEIII  <- lm(participantData$countCpl~ participantData$ACEII)

postHoc.lengthCpl.gender  <- t.test(participantData$lengthCpl~participantData$gender)
postHoc.lengthCpl.gender$sd <- c(sd(participantData$lengthCpl[participantData$gender=='Female']), 
                                sd(participantData$lengthCpl[participantData$gender=='Male']))

postHoc.lengthCpl.age  <- lm(participantData$lengthCpl~ participantData$age)
postHoc.lengthCpl.ACEIII  <- lm(participantData$lengthCpl~ participantData$ACEII)

postHoc.infoCpl.gender <- t.test(participantData$infoCpl~participantData$gender)
postHoc.infoCpl.gender$sd <- c(sd(participantData$infoCpl[participantData$gender=='Female']), 
                                sd(participantData$infoCpl[participantData$gender=='Male']))

postHoc.infoCpl.age  <- lm(participantData$infoCpl~ participantData$age)
postHoc.infoCpl.ACEIII  <- lm(participantData$infoCpl~ participantData$ACEII)

postHoc.countEglob.gender  <- t.test(participantData$countEglob~participantData$gender)
postHoc.countEglob.gender$sd <- c(sd(participantData$countEglob[participantData$gender=='Female']), 
                                  sd(participantData$countEglob[participantData$gender=='Male']))

postHoc.countEglob.age  <- lm(participantData$countEglob~ participantData$age)
postHoc.countEglob.ACEIII  <- lm(participantData$countEglob~ participantData$ACEII)

postHoc.lengthEglob.gender  <- t.test(participantData$lengthEglob~participantData$gender)
postHoc.lengthEglob.gender$sd <- c(sd(participantData$lengthEglob[participantData$gender=='Female']), 
                                   sd(participantData$lengthEglob[participantData$gender=='Male']))

postHoc.lengthEglob.age  <- lm(participantData$lengthEglob~ participantData$age)
postHoc.lengthEglob.ACEIII  <- lm(participantData$lengthEglob~ participantData$ACEII)

postHoc.infoEglob.gender <- t.test(participantData$infoEglob~participantData$gender)
postHoc.infoEglob.gender$sd <- c(sd(participantData$infoEglob[participantData$gender=='Female']), 
                                 sd(participantData$infoEglob[participantData$gender=='Male']))

postHoc.infoEglob.age  <- lm(participantData$infoEglob~ participantData$age)
postHoc.infoEglob.ACEIII  <- lm(participantData$infoEglob~ participantData$ACEII)

# Clustering Coefficient
postHoc.countWeightedCluster.gender  <- t.test(participantData$countWeightedCluster~participantData$gender)
postHoc.countWeightedCluster.gender$sd <- c(sd(participantData$countWeightedCluster[participantData$gender=='Female']), 
                                            sd(participantData$countWeightedCluster[participantData$gender=='Male']))

postHoc.countWeightedCluster.age  <- lm(participantData$countWeightedCluster~ participantData$age)
postHoc.countWeightedCluster.ACEIII  <- lm(participantData$countWeightedCluster~ participantData$ACEII)

postHoc.countCluster.gender  <- t.test(participantData$countCluster~participantData$gender)
postHoc.countCluster.gender$sd <- c(sd(participantData$countCluster[participantData$gender=='Female']), 
                                            sd(participantData$countCluster[participantData$gender=='Male']))

postHoc.countCluster.age  <- lm(participantData$countCluster~ participantData$age)
postHoc.countCluster.ACEIII  <- lm(participantData$countCluster~ participantData$ACEII)

# Assortativity Coefficient
postHoc.countWeightedAssortativity.gender  <- t.test(participantData$countWeightedAssortativity~participantData$gender)
postHoc.countWeightedAssortativity.gender$sd <- c(sd(participantData$countWeightedAssortativity[participantData$gender=='Female']), 
                                          sd(participantData$countWeightedAssortativity[participantData$gender=='Male']))

postHoc.countWeightedAssortativity.age  <- lm(participantData$countWeightedAssortativity~ participantData$age)
postHoc.countWeightedAssortativity.ACEIII  <- lm(participantData$countWeightedAssortativity~ participantData$ACEII)

postHoc.countAssortativity.gender  <- t.test(participantData$countAssortativity~participantData$gender)
postHoc.countAssortativity.gender$sd <- c(sd(participantData$countAssortativity[participantData$gender=='Female']), 
                                                  sd(participantData$countAssortativity[participantData$gender=='Male']))

postHoc.countAssortativity.age  <- lm(participantData$countAssortativity~ participantData$age)
postHoc.countAssortativity.ACEIII  <- lm(participantData$countAssortativity~ participantData$ACEII)

# Search Information 
postHoc.avgSearchInformation.gender  <- t.test(participantData$avgSearchInformation~participantData$gender)
postHoc.avgSearchInformation.gender$sd <- c(sd(participantData$avgSearchInformation[participantData$gender=='Female']), 
                                            sd(participantData$avgSearchInformation[participantData$gender=='Male']))

postHoc.avgSearchInformation.age  <- lm(participantData$avgSearchInformation~ participantData$age)
postHoc.avgSearchInformation.ACEIII  <- lm(participantData$avgSearchInformation~ participantData$ACEII)

# Entropy Rate
postHoc.entropyRate.gender  <- t.test(participantData$entropyRate~participantData$gender)
postHoc.entropyRate.gender$sd <- c(sd(participantData$entropyRate[participantData$gender=='Female']), 
                                   sd(participantData$entropyRate[participantData$gender=='Male']))

postHoc.entropyRate.age  <- lm(participantData$entropyRate~ participantData$age)
postHoc.entropyRate.ACEIII  <- lm(participantData$entropyRate~ participantData$ACEII)



### Create table dataframes ------------------------------------------------------
# Gender Effects
genderEffectsTable <- data.frame(row.names = c('Inverse Count CPL', 
                                               'Length CPL', 
                                               'Information CPL',
                                               'Inverse Count Global Efficiency', 
                                               'Length Global Efficiency', 
                                               'Information Global Efficiency',
                                               'Weighted CC',
                                               'Unweighted CC',
                                               'Weighted assortativty',
                                               'Unweighted assortativty',
                                               'Search Information',
                                               'Entropy Rate'))

genderEffectsTable$Metric <- c('Inverse Count CPL', 
                               'Length CPL', 
                               'Information CPL',
                               'Inverse Count Global Efficiency', 
                               'Length Global Efficiency', 
                               'Information Global Efficiency',
                               'Weighted CC',
                               'Unweighted CC',
                               'Weighted assortativty',
                               'Unweighted assortativty',
                               'Search Information',
                               'Entropy Rate')

genderEffectsTable$Female <- c(meansd_format(postHoc.countCpl.gender, 1, 4),
                               meansd_format(postHoc.lengthCpl.gender, 1, 2),
                               meansd_format(postHoc.infoCpl.gender, 1, 2),
                               meansd_format(postHoc.countEglob.gender, 1, 2),
                               meansd_format(postHoc.lengthEglob.gender, 1, 4),
                               meansd_format(postHoc.infoEglob.gender, 1, 4),
                               meansd_format(postHoc.countWeightedCluster.gender, 1, 4),
                               meansd_format(postHoc.countCluster.gender, 1, 4),
                               meansd_format(postHoc.countWeightedAssortativity.gender, 1, 4),
                               meansd_format(postHoc.countAssortativity.gender, 1, 4),
                               meansd_format(postHoc.avgSearchInformation.gender, 1, 4),
                               meansd_format(postHoc.entropyRate.gender, 1, 4))


genderEffectsTable$Male <- c(meansd_format(postHoc.countCpl.gender, 2, 4),
                               meansd_format(postHoc.lengthCpl.gender, 2, 2),
                               meansd_format(postHoc.infoCpl.gender, 2, 2),
                               meansd_format(postHoc.countEglob.gender, 2, 2),
                               meansd_format(postHoc.lengthEglob.gender, 2, 4),
                               meansd_format(postHoc.infoEglob.gender, 2, 4),
                               meansd_format(postHoc.countWeightedCluster.gender, 2, 4),
                               meansd_format(postHoc.countCluster.gender, 2, 4),
                               meansd_format(postHoc.countWeightedAssortativity.gender, 2, 4),
                               meansd_format(postHoc.countAssortativity.gender, 2, 4),
                               meansd_format(postHoc.avgSearchInformation.gender, 2, 4),
                               meansd_format(postHoc.entropyRate.gender, 2, 4))

genderEffectsTable$testDetails <- c(teststat_format(postHoc.countCpl.gender),
                                    teststat_format(postHoc.lengthCpl.gender),
                                    teststat_format(postHoc.infoCpl.gender),
                                    teststat_format(postHoc.countEglob.gender),
                                    teststat_format(postHoc.lengthEglob.gender),
                                    teststat_format(postHoc.infoEglob.gender),
                                    teststat_format(postHoc.countWeightedCluster.gender),
                                    teststat_format(postHoc.countCluster.gender),
                                    teststat_format(postHoc.countWeightedAssortativity.gender),
                                    teststat_format(postHoc.countAssortativity.gender),
                                    teststat_format(postHoc.avgSearchInformation.gender),
                                    teststat_format(postHoc.entropyRate.gender))

pvals_to_correct <- c(postHoc.countCpl.gender$p.value,
                                    postHoc.lengthCpl.gender$p.value,
                                    postHoc.infoCpl.gender$p.value,
                                    postHoc.countEglob.gender$p.value,
                                    postHoc.lengthEglob.gender$p.value,
                                    postHoc.infoEglob.gender$p.value,
                                    postHoc.countWeightedCluster.gender$p.value,
                                    postHoc.countCluster.gender$p.value,
                                    postHoc.countWeightedAssortativity.gender$p.value,
                                    postHoc.countAssortativity.gender$p.value,
                                    postHoc.avgSearchInformation.gender$p.value,
                                    postHoc.entropyRate.gender$p.value)


#tt <- flextable(genderEffectsTable) %>% autofit()
#tt <- set_header_labels(tt, testDetails = '')
#save_as_docx(tt, path = 'genderEffectsTable.docx')