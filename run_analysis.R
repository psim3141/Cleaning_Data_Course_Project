##
## run_analysis.R
##
## Created by Patrick Simon, July 2019
##
## An analysis script for the course project of the
## "Getting and Cleaning Data" course on coursera.org
##
## It downloads data from accelerometer measurements made using
## the Samsung Galaxy 5 smartphone, and returns a tidy dataset
## Full description of the data can be found at the following adress:
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##
## The output is saved using the write.table method and saved
## in the file "tidy_data_output.txt"
##
## It can be read into R using the following command:
## tidy_data <- read.table("tidy_data_output.txt", header=TRUE)
##



## Check if the data zipfile has already been downloaded
if(!file.exists("UCI_HAR_Dataset.zip")){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,destfile="UCI_HAR_Dataset.zip",method="libcurl")
}

## Check if the file has already been unzipped, otherwise do so
if(!file.exists("UCI HAR Dataset")){
        unzip("UCI_HAR_Dataset.zip")
} 


##
## TASK 1: Merge the training and the test sets to create one data set.
##

## Reading the list of 561 feature names, corresponding to the 
## columns in the test and training sets
features <- read.table(file.path("UCI HAR Dataset","features.txt"),
                       header = FALSE,col.names = c("ColumnNumber","Feature"))


## Reading in the test subject file
test_subject <- read.table(file.path("UCI HAR Dataset","test","subject_test.txt"),
                           header = FALSE,col.names = "SubjectID")

## Reading in the corresponding activity labels
test_activities <- read.table(file.path("UCI HAR Dataset","test","y_test.txt"),
                               header = FALSE,col.names = "Activity")

## Reading in the test data and assigning the feature names to the columns
test_data <- read.table(file.path("UCI HAR Dataset","test","X_test.txt"),
                        header = FALSE)
colnames(test_data) <- features[,2]

## Binding the subjects, activities and measurements together to
## a single data from for all test data
all_test_data <- cbind(test_subject,test_activities,test_data)


## Repeat the last steps, for the training data
train_subject <- read.table(file.path("UCI HAR Dataset","train","subject_train.txt"),
                           header = FALSE,col.names = "SubjectID")
train_activities <- read.table(file.path("UCI HAR Dataset","train","y_train.txt"),
                               header = FALSE,col.names = "Activity")
train_data <- read.table(file.path("UCI HAR Dataset","train","X_train.txt"),
                        header = FALSE)
colnames(train_data) <- features[,2]
all_train_data <- cbind(train_subject,train_activities,train_data)


## Finally, combine both the test and the training data sets
all_data <- rbind(all_test_data,all_train_data)



##
## TASK 2: Extract only the measurements on the mean and standard deviation for each measurement.
##

## Find all columns that are either SubjectID, Activity, or which are 
## the mean and standard deviation measurements as signified by including
## "mean()" or "std()" in the feature name
relevant_columns <- grep("SubjectID|Activity|mean\\(|std\\(",names(all_data))

## Reduce the data to only those columns
relevant_data <- all_data[relevant_columns]



##
## TASK 3: Use descriptive activity names to name the activities in the data set.
##

## The descriptive activity names are defined in "activity_labels.txt"
activity_labels <- read.table(file.path("UCI HAR Dataset","activity_labels.txt"),
                       header = FALSE,col.names = c("ActivityID","ActivityLabel"))

## Replace the numbered Activity column of the reduced data set
## with a factor column, based on the activity labels
relevant_data$Activity <- factor(relevant_data$Activity, 
                                 levels=activity_labels[,1],
                                 labels=activity_labels[,2])



##
## TASK 4: Appropriately labels the data set with descriptive variable names.
##

## Read the column names into a variable that will be modified
colnames <- names(relevant_data)

## Substituting more descriptive terms for the abbreviations that were used
colnames <- gsub("^t","TimeDomain\\-",colnames)
colnames <- gsub("^f","FrequencyDomain\\-",colnames)
colnames <- gsub("Acc","Acceleration",colnames)
colnames <- gsub("Gyro","Gyroscope",colnames)
colnames <- gsub("Mag","Magnitude",colnames)
colnames <- gsub("mean","Mean",colnames)
colnames <- gsub("std","StandardDeviation",colnames)

## Removing parentheses (but keeping dashes) for better readability
colnames <- gsub("\\(","",colnames)
colnames <- gsub("\\)","",colnames)

## There is a mistake in some of the variable names, including the word
## "Body" twice in a row. This fixes that
colnames <- gsub("BodyBody","Body",colnames)

## Assign the more descriptive names to the dataset
colnames(relevant_data) <- colnames



##
## TASK 5: From the data set in step 4, creates a second, independent tidy data set
##         with the average of each variable for each activity and each subject.
##

## Load the package dplyr into the library, installing it if necessary
if(!require("dplyr")){
        install.packages("dplyr")
        library(dplyr)
}

## Group the data by the Subject ID and by the six activity levels
grouped_data <- group_by(relevant_data,SubjectID,Activity)

## Summarise the data over both groupings, calculating the mean function
tidy_data <- summarise_all(grouped_data, mean)
             
## Create the tidy data output file "tidy_data_output.txt"
## NOTE: use header = TRUE when reading the data
write.table(tidy_data,file = "tidy_data_output.txt",row.names = FALSE)