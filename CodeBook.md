# Code book for the "Getting and Cleaning Data" course project

This code book outlines the steps, summaries and transformations which are taken by the `run_analysis.R` code to produce the resulting tidy data set `tidy_data_output.txt` from the original source data. 

It also contains a list of all variables in the output data, along with their units and other relevant information.

## Source data

As outlined in the `README.md` file, measurement data from the accelerometers of Samsung Galaxy 5 smartphones was used as source data, which is downloadable from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

The dataset includes more detailed information about the source data in its `README.txt`. Information on the 561 feature vector of measurements is collected in `features_info.txt`, the list of all features is collected in `features.txt`. The links between the numbered activity levels and their labels are found in `activity_labels.txt`. The subjects of the study have been separated into two groups: those generating training data, and those generating test data.

For each group, there is a folder (`test` and `train`) which contains the full 561-feature measurement data (`X_test.txt` and `X_train.txt`), the subject identifiers (`subject_test.txt` and `subject_train.txt`) and the respective activity levels (`y_test.txt` and `y_train.txt`). There is also a further subfolder containing triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration and triaxial angular velocity from the gyroscope, which is irrelevant for the task of this project.


## Transformations of the source data

The following steps are performed by `run_analysis.R` in order to fulfill the project task and produce the desired output file:

#### Obtaining the source data
The program checks, whether the source data file has already been downloaded and unzipped. If not, it will do both.

#### Merging the training and the test sets to create one data set
The program reads the feature names from the feature list. Then, for both the training and the test sets, the program will first read the subject identifiers, the activity levels and the measurements from their respective files, as outlined in the previous section. Then it combines those three lists into one, by binding the columns together, and renames them according to the feature list. Finally, it merges both the training and the test lists by row-binding them.

#### Extracting only the mean and standard deviation measurements
The program identifies all columns that are the calculated mean and standard deviation quantities of their respective measurement. These can be identified by the `mean()` and `std()` substrings. The data set is reduced to only these columns, as well as the subject identifier and the activity level. Other columns that contain the word "mean" are not taken into account.

#### Replacing the activity identifiers with descriptive activity names
The activity names are read from the activity lable file that was described in the previous section. The numeric activity identifier column is replaced with a factor column that uses these names.

#### Appropriately labeling the data set with descriptive variable names
For this step, the column names of the data set are modified according to the following rules: 

- The prefixes `t` and `f` are replaced by the more descriptive `TimeDomain-` and `FrequencyDomain-`.
- The abbreviated terms `Acc`, `Gyro`, `Mag` and `std` are replaced by the more descriptive `Acceleration`, `Gyroscope`, `Magnitude` and `StandardDeviation`.
- The lowercase `mean` is replaced with an uppercase `Mean`, in order to have consistently spelled variable names.
- All parentheses are removed for better readability.
- In variable names that mistakenly included the term `BodyBody`, only a single `Body` is used.

#### Creating a second, independent tidy data set with the average of each variable for each activity and each subject
For this step, the R package `dplyr` is required, and will be installed if it does not exist. The program then uses the `group_by` method to group the data by its two identifiers, i.e. the subject ID and the activity level. Using the `summarise_all` method, the mean value across each of the measurement columns is calculated for each combination of subject and activity. The output file `tidy_data_output.txt` is created from the resulting data with the `write.table()` method and the `row.names=FALSE` flag. To read the output data back into R, the following command can be used: `tidy_data <- read.table("tidy_data_output.txt", header=TRUE)`.


## Output Data

The output data is a text file in a space-separated format, consisting of 181 rows and 68 columns. The first row of the data contains the variable names.

- `SubjectID`: The ID of the test subject, ranges from 1 to 30.
- `Activity`: The activity level of the subject, it can take one of the following six values: `WALKING`,`WALKING_UPSTAIRS`,`WALKING_DOWNSTAIRS`,`SITTING`,`STANDING` or `LAYING`.
- `TimeDomain-BodyAcceleration-Mean-X`, `TimeDomain-BodyAcceleration-Mean-Y`, `TimeDomain-BodyAcceleration-Mean-Z`, `TimeDomain-BodyAcceleration-StandardDeviation-X`,`TimeDomain-BodyAcceleration-StandardDeviation-Y`,`TimeDomain-BodyAcceleration-StandardDeviation-Z` : The mean and the standard deviation of the body acceleration in the X, Y and Z directions, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-GravityAcceleration-Mean-X`, `TimeDomain-GravityAcceleration-Mean-Y`, `TimeDomain-GravityAcceleration-Mean-Z`, `TimeDomain-GravityAcceleration-StandardDeviation-X`,`TimeDomain-GravityAcceleration-StandardDeviation-Y`, `TimeDomain-GravityAcceleration-StandardDeviation-Z`: The mean and the standard deviation of the gravity acceleration in the X, Y and Z directions, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-BodyAccelerationJerk-Mean-X`, `TimeDomain-BodyAccelerationJerk-Mean-Y`, `TimeDomain-BodyAccelerationJerk-Mean-Z`, `TimeDomain-BodyAccelerationJerk-StandardDeviation-X`,`TimeDomain-BodyAccelerationJerk-StandardDeviation-Y`, `TimeDomain-BodyAccelerationJerk-StandardDeviation-Z`: The mean and the standard deviation of the body acceleration jerk, which is the time derivation of the acceleration, in the X, Y and Z directions, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-BodyGyroscope-Mean-X`, `TimeDomain-BodyGyroscope-Mean-Y`, `TimeDomain-BodyGyroscope-Mean-Z`, `TimeDomain-BodyGyroscope-StandardDeviation-X`,`TimeDomain-BodyGyroscope-StandardDeviation-Y`,`TimeDomain-BodyGyroscope-StandardDeviation-Z` : The mean and the standard deviation of the body angular velocity in the X, Y and Z directions, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-BodyGyroscopeJerk-Mean-X`, `TimeDomain-BodyGyroscopeJerk-Mean-Y`, `TimeDomain-BodyGyroscopeJerk-Mean-Z`, `TimeDomain-BodyGyroscopeJerk-StandardDeviation-X`,`TimeDomain-BodyGyroscopeJerk-StandardDeviation-Y`,`TimeDomain-BodyGyroscopeJerk-StandardDeviation-Z` : The mean and the standard deviation of the body angular velocity jerk, which is the time derivation of the angular velocity, in the X, Y and Z directions, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-BodyAccelerationMagnitude-Mean`, `TimeDomain-BodyAccelerationMagnitude-StandardDeviation`: The mean and the standard deviation of the body acceleration magnitude, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-GravityAccelerationMagnitude-Mean`, `TimeDomain-GravityAccelerationMagnitude-StandardDeviation`: The mean and the standard deviation of the gravity acceleration magnitude, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-BodyAccelerationJerkMagnitude-Mean`, `TimeDomain-BodyAccelerationJerkMagnitude-StandardDeviation`: The mean and the standard deviation of the body acceleration jerk magnitude, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-BodyGyroscopeJerkMagnitude-Mean`, `TimeDomain-BodyGyroscopeMagnitude-StandardDeviation`: The mean and the standard deviation of the body angular velocity magnitude, measured in the time domain. Normalised to values between -1 and 1.
- `TimeDomain-BodyGyroscopeJerkMagnitude-Mean`, `TimeDomain-BodyGyroscopeMagnitude-StandardDeviation`: The mean and the standard deviation of the body angular jerk velocity magnitude, measured in the time domain. Normalised to values between -1 and 1.

- `FrequencyDomain-BodyAcceleration-Mean-X`, `FrequencyDomain-BodyAcceleration-Mean-Y`, `FrequencyDomain-BodyAcceleration-Mean-Z`, `FrequencyDomain-BodyAcceleration-StandardDeviation-X`,`FrequencyDomain-BodyAcceleration-StandardDeviation-Y`,`FrequencyDomain-BodyAcceleration-StandardDeviation-Z` : The mean and the standard deviation of the body acceleration in the X, Y and Z directions, measured in the frequency domain. Normalised to values between -1 and 1.
- `FrequencyDomain-BodyAccelerationJerk-Mean-X`, `FrequencyDomain-BodyAccelerationJerk-Mean-Y`, `FrequencyDomain-BodyAccelerationJerk-Mean-Z`, `FrequencyDomain-BodyAccelerationJerk-StandardDeviation-X`,`FrequencyDomain-BodyAccelerationJerk-StandardDeviation-Y`, `FrequencyDomain-BodyAccelerationJerk-StandardDeviation-Z`: The mean and the standard deviation of the body acceleration jerk, which is the time derivation of the acceleration, in the X, Y and Z directions, measured in the frequency domain. Normalised to values between -1 and 1.
- `FrequencyDomain-BodyGyroscope-Mean-X`, `FrequencyDomain-BodyGyroscope-Mean-Y`, `FrequencyDomain-BodyGyroscope-Mean-Z`, `FrequencyDomain-BodyGyroscope-StandardDeviation-X`,`FrequencyDomain-BodyGyroscope-StandardDeviation-Y`,`FrequencyDomain-BodyGyroscope-StandardDeviation-Z` : The mean and the standard deviation of the body angular velocity in the X, Y and Z directions, measured in the frequency domain. Normalised to values between -1 and 1.
- `FrequencyDomain-BodyAccelerationMagnitude-Mean`, `FrequencyDomain-BodyAccelerationMagnitude-StandardDeviation`: The mean and the standard deviation of the body acceleration magnitude, measured in the frequency domain. Normalised to values between -1 and 1.
- `FrequencyDomain-BodyAccelerationJerkMagnitude-Mean`, `FrequencyDomain-BodyAccelerationJerkMagnitude-StandardDeviation`: The mean and the standard deviation of the body acceleration jerk magnitude, measured in the frequency domain. Normalised to values between -1 and 1.
- `FrequencyDomain-BodyGyroscopeJerkMagnitude-Mean`, `FrequencyDomain-BodyGyroscopeMagnitude-StandardDeviation`: The mean and the standard deviation of the body angular velocity magnitude, measured in the frequency domain. Normalised to values between -1 and 1.
- `FrequencyDomain-BodyGyroscopeJerkMagnitude-Mean`, `FrequencyDomain-BodyGyroscopeMagnitude-StandardDeviation`: The mean and the standard deviation of the body angular jerk velocity magnitude, measured in the frequency domain. Normalised to values between -1 and 1.

Prior to normalization (or prior to time derivation for the calculation of the respective jerk) the acceleration measurements were measured in standard gravity units `g = 9.81m/s²` and the angular velocity measurements were in `rad/s`. Magnitudes were calculated using the Euclidean norm. All frequency domain quantities were calculated from the respective time domain data via Fast Fourier Transform.