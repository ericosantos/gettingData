download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "files.zip")
unzip("files.zip")

nn <- read.table(normalizePath("UCI HAR Dataset/features.txt"))
actLab <- read.table(normalizePath("UCI HAR Dataset/activity_labels.txt"))

xTrain <- read.table(normalizePath("UCI HAR Dataset/train/X_train.txt"))
names(xTrain) <- nn$V2
subjTrain <- read.table(normalizePath("UCI HAR Dataset/train/subject_train.txt"))
yTrain <- read.table(normalizePath("UCI HAR Dataset/train/y_train.txt"))
yTrain <- merge(yTrain,actLab,by="V1")
dTrain <- data.frame(type="Train",subject=subjTrain$V1,activity=yTrain$V2,xTrain)

xtest <- read.table(normalizePath("UCI HAR Dataset/test/X_test.txt"))
names(xtest) <- nn$V2
subjtest <- read.table(normalizePath("UCI HAR Dataset/test/subject_test.txt"))
ytest <- read.table(normalizePath("UCI HAR Dataset/test/y_test.txt"))
ytest <- merge(ytest,actLab,by="V1")
dtest <- data.frame(type="Test",subject=subjtest$V1,activity=ytest$V2,xtest)

data <- rbind(dTrain, dtest)
library(reshape2)
library(data.table)
moltendata <- data.table(melt(data,id.vars = c("type", "subject", "activity")))
moltendata[,mu:=mean(value),by=c("type", "subject", "activity")]
moltendata[,sigma:=sd(value),by=c("type", "subject", "activity")]

tidydata <- aggregate(cbind(moltendata$mu, moltendata$sigma) ~ moltendata$subject + moltendata$activity + moltendata$variable, FUN="max")
names(tidydata) <- names(moltendata)[c(2,3,4,6,7)]
write.table(tidydata, "tidydata.txt",row.names = FALSE)
