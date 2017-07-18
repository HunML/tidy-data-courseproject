#### Install, load required packages

install.packages('reshape2')
library('reshape2')


#### Download and unzip the data

filename <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"

if (!file.exists(filename)){

  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "

  download.file(fileURL, filename)

}  

if (!file.exists("UCI HAR Dataset")) { 

  unzip(filename) 

}


#### Load activity labels and features

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

activityLabels[,2] <- as.character(activityLabels[,2])

features <- read.table("UCI HAR Dataset/features.txt")

features[,2] <- as.character(features[,2])


#### Extract the mean and standard deviation data

featuresNeeded <- grep(".*mean.*|.*std.*", features[,2])

featuresNeeded.names <- features[featuresNeeded,2]

featuresNeeded.names = gsub('-mean', 'Mean', featuresNeeded.names)

featuresNeeded.names = gsub('-std', 'Std', featuresNeeded.names)

featuresNeeded.names <- gsub('[-()]', '', featuresNeeded.names)


#### Load train dataset

trainData <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresNeeded]

trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")

trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

trainData <- cbind(trainSubjects, trainActivities, trainData)


#### Load test dataset

testData <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresNeeded]

testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")

testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

testData <- cbind(testSubjects, testActivities, testData)


#### merge datasets and add labels

allData <- rbind(trainData, testData)

colnames(allData) <- c("subject", "activity", featuresNeeded.names)


#### turn activities and subjects into factors

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])

allData$subject <- as.factor(allData$subject)


#### stack the data

allData.melted <- melt(allData, id = c("subject", "activity"))

allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)


#### write the data in a text file

write.table(allData.mean, "tidy1.txt", row.names = FALSE, quote = FALSE)
