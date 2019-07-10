# Course project for the "Getting and Cleaning Data" course

## Project background

The purpose of this project is to demonstrate the student's ability to collect, work with, and clean a data set. The goal is to prepare a tidy data that can be used for later analysis.

As a data source for this project, measurement data from the accelerometers of Samsung Galaxy 5 smartphones was used. This data can be found at the following address: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

A detailed description of the source data set is found here: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>


## Project tasks

The student should create one R script called `run_analysis.R` that does the following:

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in the previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## In this repository

- `README.md` is this document. It serves as an introduction to the project, and the source data and explains the other contents of the repository.
- `CodeBook.md` is the code book, which explains which steps, summaries and transformations were taken to produce the resulting tidy data set from the original source data. It also contains a list of all variables in the output data, along with their units and other relevant information.
- `run_analysis.R` is the actual analysis code, written in R, which downloads the source data, applies all the necessary transformations as outlined in the code book, and produces the output file.
- `tidy_data_output.txt` is the output file, generated according to the project tasks and tidy data principles by the `run_analysis.R` code.