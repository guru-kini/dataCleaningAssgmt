# Data Cleaning Final Assignment
This repo has the submission for Final Peer Graded assignment for Coursera's Getting and Cleaning Data Course.
The assignment was to clean the a bunch of raw received from various sensors (like Accelerometers) of smartphones. More details of this data can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## run_analysis.R
This is the main R Script file that reads and cleans the data. The script's main function is runAnalysis() that achieves the following assignment goals:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The Script has the following pre-requisites:
1. The [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is downloaded and unzipped into a folder called "UCI HAR Dataset" which is placed in the current working directory of the R environment.
2. The dplyr package is installed.

The runAnalysis() function will output a dataset that fulfills the requirements of the assignment. The dataset can be written to a file using the following:
```
write.table(x, "finalDataSet.txt", row.names = F) # row.names = F is important!
```
After executing this, the "finalDataSet.txt" can read and viewed as a grid using the readFinalData() function in the run_analysis.R file. This function takes the file path as the input and shows the read data as a grid. 
