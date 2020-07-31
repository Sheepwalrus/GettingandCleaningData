## The purpose of this file is to do the following:
#1. Reads the dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#2. Merges the training and the test sets to create one data set.
#3. Extracts only the measurements on the mean and standard deviation for each measurement.
#4. Uses descriptive activity names to name the activities in the data set
#5. Appropriately labels the data set with descriptive variable names.
#6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# The dplyr package will be used throughout
library(dplyr)

## 1. Reads the dataset in. 
# I worked with a local copy downloaded to "C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\UCI HAR Dataset"

# Read features and activity labels 
features <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\UCI HAR Dataset\features.txt")
activityLabels <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\UCI HAR Dataset\activity_labels.txt")
# Tag activity labels.  
colnames(activityLabels) <- c('activityId','activityType')

# Read training dataset
trainingSubject <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\train\UCI HAR Dataset\subject_train.txt")
trainingX <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\train\UCI HAR Dataset\X_train.txt")
trainingY <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\train\UCI HAR Dataset\y_train.txt")
# Tag training dataset
colnames(trainingSubject) = "subjectId"
colnames(trainingY) = "activityId"
colnames(trainingX) = features[,2]

# Read test dataset 
testSubject <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\test\UCI HAR Dataset\subject_test.txt")
testX <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\test\UCI HAR Dataset\X_test.txt")
testY <- read.table("C:\Users\Josh\Documents\R\getdata_projectfiles_UCI HAR Dataset\dataset\test\UCI HAR Dataset\y_test.txt")
# Tag test dataset 
colnames(testSubject) = "subjectId"
colnames(testY) = "activityId"
colnames(testX) = features[,2]

## 2.Merges the training and the test sets to create one data set.
training <- cbind(trainingY,trainingSubject,trainingX)
testing <- cbind(testY,testSubject,testX) 
mergedActivityData <-rbind(training,testing)

## 3.Extracts only the measurements on the mean and standard deviation for each measurement.
# Give column names, so we can extract only needed columns
columnNames <- colnames(mergedActivityData)
extractColumns <- grepl("subjectId|activityId|mean|std",columnNames)
mergedActivityData<-mergedActivityData[ ,extractColumns]

## 4.Uses descriptive activity names to name the activities in the data set
mergedActivityData <- merge(mergedActivityData, activityLabels,by="activityId",all.x=TRUE)
columnNames <- colnames(mergedActivityData)
mergedActivityData$activityId <- mergedActivityData$activityType
mergedActivityData <- select(mergedActivityData,-activityType)

# Replace names in columns
columnNames <- colnames(mergedActivityData)
columnNames <- gsub("[\\(\\)-]", "", columnNames)
columnNames <- gsub("^f", "frequency", columnNames)
columnNames <- gsub("^t", "time", columnNames)
columnNames <- gsub("Acc", "Accelerometer", columnNames)
columnNames <- gsub("Gyro", "Gyroscope", columnNames)
columnNames <- gsub("Magn", "Magnitude", columnNames)
columnNames <- gsub("Freq", "Frequency", columnNames)
columnNames <- gsub("mean", "Mean", columnNames)
columnNames <- gsub("std", "StandardDeviation", columnNames)

# Use new labels as column names
colnames(mergedActivityData) <- columnNames

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
groupBy<-group_by(mergedActivityData,subjectId,activityId)
mergedActivityDataMean<-summarise_each(groupBy,funs = mean)
View(mergedActivityDataMean)
write.table(mergedActivityDataMean, "tidy_data.txt", row.names = FALSE, quote = TRUE)