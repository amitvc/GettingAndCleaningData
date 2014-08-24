GettingAndCleaningData
======================

Repository for course work Getting and cleaning data
run_analysis.R source file has number of functions which are used to complete the project.
Assumptions : 
run_analysis.R source assumes that the data[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ] is unzipped at
the same level as the file is. The unzipped data goes into 'UCI HAR Dataset' directory. The source code in run_analysis.R has some hard coded paths
to files that are required to be read as part of this project. 
For part of the project which is combining test and train data sets function such as cbind, rbind have been used. Also the combined dataset is then filtered
based on measurements[features.txt] which contain mean, std. Totally there are 561 measurements but after the filter happens there are only 79 left. We also 
assign descriptive activity type based on the data from 'activity_labels.txt'. The function combineTestAndTrainDataSet() is required to be called which returns
a dataframe as expected by the first part of the assignment. I created a text file from the dataframe returned by the combineTestAndTrainDataSet function and uploaded
the tidy dataset file called 'tidydataset1.txt'. 
