---
Title: Codebook for the Getting and Cleaning Data Course Project
File(s): run_analysis.R
---
This document lists out the various variables used and the logic employed in run_analysis.R file.

# The Code layout
The run_analysis.R file contains 2 methods: runAnalysis() and readFinalData(). The Script uses Dplyr package.
## runAnalysis()
### Input
This method does not take any input.
### Output
This returns the final dataset that contains the average of all the columns that
 represent the Mean or Standard Deviation of the various measurements. This
 dataset is grouped by the Activity and Subject ID.
This output can be written into a file using write.table (with the row.names set to FALSE)
### Main variables
 - folderName - the path of the root folder that contains the "test" and "train" subfolders
 - testFolder - the path of the folder that contains the test data
 - trainFolder - the path of the folder that contains the train data
 - xTest/xTrain - the temporary datasets that contain the data read from from the X_test/X_train file
 - subTest/subTrain - the temporary datasets that contains the subject data from the subject_xxx.txt files. These are merged with the xTest/xTrain datasets.
 - combined - temporary dataset that holds the merged Train and Test datasets
 - yTest/yTrain - the temporary datasets that contain the y-axis data (aka Activity Indices) from the y_test/y_train files.
 - activities - holds the Activity Index list as read from the activity_labels.txt file
 - activityIndex - the combined yTest and yTrain values where the numerical indices are replaced by the textual Activity Labels.
 - yCombined - holds the activity lists that represents the y-axis Activity Lables. Contains both test and train data.
 - features - holds the names of the various measurement variable names as read from features.txt. This will serve as the column header for our merged data.
 - selectedCols - The subset of the columns/features that are either means or standard deviation variables. Note that this program treats only the features whose names end with mean() or std() for this selection. This subset will also contain Activity and Subject columns which we have added as a part of our data Cleaning
 - selected - the subset of the "combined" dataset that contains only the columns specified in "selectedCols"
 - groupedData - a temporary dataset that holds the "selected" dataset group by Activity and then by Subject columns
 - finalData - this is the final dataset that is the output of this function. This has the averages of all the columns (except Activity and Subject columns)

### Data Cleaning approach
 - First, all the "X" data is read from the test and train files
 - Next, the "Subject" data is read from the subject_xxx files in the test and train folders
 - The Subject data is then added as the first column in the X datasets
 - The X datasets are then combined into a single dataset
 - Next, the "Y" data is read from the y_xxx files in the test and train folders and combined into a single dataset
 - The "Y" data has numeric Activity Indices, so these are replaced by the Activity Labels by reading the data in activity_labels.txt files and using the match() function
 - The Activity Labels are then added as the first column to the combined X dataset. At this point our combined dataset has Activity data as the first column, Subject data as the second column and all the rest of 561 (unnamed) columns of the X Data.
 - The 561 X data columns are now named by first reading the feature names as listed in the features.txt file. "Activity" and "Subject" are added as the first 2 column names. So we now have 563 column names, which are set as the column names for the consolidated dataset from the last step.
 - Now we filter the columns to get only the columns that represent the mean or standard deviation data. The script uses grep to find all the columns whose names end with either "-mean()" or "-std()". The "Activity" and "Subject" columns are included in the regular expression to ensure that these grouping columns are included in our dataset.
 - The names of the columns are then cleaned a little bit by changing "-mean()" to "Mean" and "-std()" to "StdDev".
 - Next, we group the filtered consolidated dataset by first the Activity column and then by the Subject column. The script uses Dplyr package's group_by() function to achieve this.
 - Finally, the grouped data is summarized to get the averages of the various columns. Dplyr's summarize_all() function is used to achieve this.
 - This final result is then return as the output. This can be written to a table using write.table:
 ```
  write.table(x, "finalDataSet.txt", row.names = F) # row.names = F is important!
 ```
 To verify the written table, we can use readFinalData() method.

## readFinalData()
This function reads and displays the data as read from the persisted data saved from the runAnalysis() method's result.
This function does not alter the data in any way.
### Inputs
This function takes the file path as the input.
### Outputs
There are no outputs but the function displays the data in a View Grid.
