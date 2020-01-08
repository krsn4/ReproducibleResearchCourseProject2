# Download data
getwd()
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
download.file(fileUrl, destfile = "stormdata.csv.bz2")
#data0 <- read.csv("stormdata.csv.bz2")
library(data.table)
data0 <- fread("stormdata.csv.bz2") # a bit faster than read.csv, 25 sec vs 50 sec
data0$BGN_DATE <- as.Date(data0$BGN_DATE, "%m/%d/%Y %H:%M:%S")
data0[which.min(data0$BGN_DATE), BGN_DATE]
data0[which.max(data0$BGN_DATE), BGN_DATE]

data1 <- data0[, .(sum_fatal_inj=sum(FATALITIES, INJURIES)), by=EVTYPE]

library(ggplot2)
data1 <- data1[order(-sum_fatal_inj)]
ggplot(data1[1:10,], aes(x=EVTYPE, y=sum_fatal_inj)) + geom_col() + coord_flip() +
  xlab("Storm Events") + ylab("Total Fatalities and Injuiries") + 
  ggtitle("Top 10 most harmful storm events")
data1[which.max(data1[, sum_fatal_inj]), ]

data2 <- data0[, .(sum_prop_crop_dmgs=sum(PROPDMG, CROPDMG)), by=EVTYPE]
data2 <- data2[order(-sum_prop_crop_dmgs)]
ggplot(data2[1:10,], aes(x=EVTYPE, y=sum_prop_crop_dmgs)) + geom_col() + coord_flip() +
  xlab("Storm Events") + ylab("Total Property and Crop Damages ($)") +
  ggtitle("Top 10 storm events with most economic consequences")
data2[which.max(data2[, sum_prop_crop_dmgs]), ]
