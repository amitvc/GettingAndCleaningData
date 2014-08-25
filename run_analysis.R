##This script is part of project work for Getting and cleaning Data offered by
## Johns Hopkins university.
## Assumptions - The assumption made to run this script is the data sets have been downloaded
## and placed in 'UCI HAR Dataset' directory which is at the same level as this script.

## Function goes through the 'features.txt' file and finds
## indexes for the all measurements which mean or standard deviation.
## This function can be modified to access an vector of filter strings to make it more generic
library(plyr)
library(reshape2)
filterMeasurementIndexes <- function() {
  features <- read.table("UCI HAR Dataset//features.txt")
  meanIdx <- grepl("mean", features$V2)
  stdIdx <- grepl("std", features$V2)
  combineIdx <- append(features[which(meanIdx),1], features[which(stdIdx),1])
  combineIdx <- sort(combineIdx)
  combineIdx
}

## Function returns the index ids of rows in the dataframe which match the activity id.
findIndexesByActivity <- function(df, activityId) {
  indexes <- df$activity_type == activityId
  indexes <- which(indexes)
  indexes
}

##Function assigns descriptive activity labels to activity_type column
assignActivityLabels <- function(df, activityLabel, rowIndexes) {
  for(i in rowIndexes) {
    df[i, 81] <- activityLabel 
  }
  df
}

## function combines test, training datasets.
## it also filters the measurements based on mean,std criteria as specified in the first 
## part of assignment. This leaves us with only 79 columns + 2 columns [one for subject id, and other for activity type]
## the function returns a dataframe which is result of steps mentioned above.
combineTestAndTrainDataSet <- function() {
  xtest <- read.table("UCI HAR Dataset//test/X_test.txt")
  ytest <- read.table("UCI HAR Dataset//test//y_test.txt")
  subtest <- read.table("UCI HAR Dataset//test//subject_test.txt")
  combine_test <- cbind(xtest, subtest, ytest)
  ## include column 562 and 563 for subject type and actitity  type.
  combine_test_filtered <- combine_test[, append(filterMeasurementIndexes(), c(562,563))]
  colnames(combine_test_filtered)[80] <- "subject_id"
  colnames(combine_test_filtered)[81] <- "activity_type"
  
  xtrain <- read.table("UCI HAR Dataset//train/X_train.txt")
  ytrain <- read.table("UCI HAR Dataset//train//y_train.txt")
  subtrain <- read.table("UCI HAR Dataset//train//subject_train.txt")
  combine_train <- cbind(xtrain, subtrain, ytrain)
  ## include column 562 and 563 for subject type and actitity  type.
  combine_train_filtered <- combine_train[, append(filterMeasurementIndexes(), c(562,563))]
  colnames(combine_train_filtered)[80] <- "subject_id"
  colnames(combine_train_filtered)[81] <- "activity_type"
  ## combine test and train data sets.
  combine_test_train_filtered <- rbind(combine_test_filtered, combine_train_filtered)
  ## Assign descriptive values to activity column.
  combine_test_train_filtered <- assignActivityLabels(combine_test_train_filtered, "WALKING", findIndexesByActivity(combine_test_train_filtered,1))
  combine_test_train_filtered <- assignActivityLabels(combine_test_train_filtered, "WALKING Upstairs", findIndexesByActivity(combine_test_train_filtered,2))
  combine_test_train_filtered <- assignActivityLabels(combine_test_train_filtered, "WALKING Downstairs", findIndexesByActivity(combine_test_train_filtered,3))
  combine_test_train_filtered <- assignActivityLabels(combine_test_train_filtered, "Sitting", findIndexesByActivity(combine_test_train_filtered,4))
  combine_test_train_filtered <- assignActivityLabels(combine_test_train_filtered, "Standing", findIndexesByActivity(combine_test_train_filtered,5))
  combine_test_train_filtered <- assignActivityLabels(combine_test_train_filtered, "LAYING", findIndexesByActivity(combine_test_train_filtered,6))
  combine_test_train_filtered
}

## function summarizes data by activity and subject id.
summarizeDataBySubjectAndActivity <- function() {
    data <- combineTestAndTrainDataSet()
    ## melt the data set by subject_id and activity_type
    melted <- melt(data, id.vars = c("subject_id", "activity_type"))
    ## calculate the mean.
    tidy <- ddply(melted, c("subject_id", "activity_type"), summarise, mean = mean(value))
    tidy
}
