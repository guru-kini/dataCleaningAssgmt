library(dplyr)
runAnalysis <- function() {
    folderName <- "./UCI HAR Dataset/"
    testFolder <- paste0(folderName, "test/")
    trainFolder <- paste0(folderName, "train/")
   
    # Read the x_test and x_train as separate datasets
    xTest <- read.table(paste0(testFolder, "X_test.txt"), header = F)
    xTrain <- read.table(paste0(trainFolder, "X_train.txt"), header = F)

    # The "X-Files" do not have the subjects - the subject index should be picked up from the corresponding
    # subject_xxx.txt files and added as a column.
    subTest <- read.table(paste0(testFolder, "subject_test.txt"), header = F)
    subTrain <- read.table(paste0(trainFolder, "subject_train.txt"), header = F)
    
    # Append the Subject Column Data 
    xTest <- cbind(subTest, xTest)
    xTrain <- cbind(subTrain, xTrain)

    # Merge the x_test and x_train data
    combined <- rbind(xTest, xTrain)
    
    # The activity labels for the test and train data are in the y files.
    yTest <- read.table(paste0(testFolder, "y_test.txt"))
    yTrain <- read.table(paste0(trainFolder, "y_train.txt"))
    
    yCombined <- rbind(yTest, yTrain)
    
    # Find the descriptive activity names
    activities <- (read.table(paste0(folderName, "activity_labels.txt"), header = F))
    
    # Now let us replace the activity label IDs with the actual Label text
    activityIndex <- match(yCombined[,1], activities[, 1])
    yCombined <- activities[activityIndex, 2]

    combined <- cbind(yCombined, combined)
    
    # Set the Column names as per features.
    features <- read.table(paste0(folderName, "features.txt"), header = F)
    features <- as.vector(features[, 2])

    # Insert the "Activity" and "Subject" columns
    features <- append(features, "Activity", after = 0)
    features <- append(features, "Subject", after = 1)

    # Find the column IDs for all the mean() and std() variables in the features file
    # Assuming that we have to just pick up the columns whose names end with a mean() or std()
    # Also include the "Activity" and "Subject" Column
    colnames(combined) <- features

    selectedCols <- grep("(Activity|Subject|mean\\(\\)$|std\\(\\)$)", colnames(combined))

    # Extract the columns for only the mean() and std() variables
    selected <- combined[, selectedCols]
    
    # Clean up the Column Names
    colnames(selected) <- gsub("-mean\\(\\)$", "Mean", colnames(selected))
    colnames(selected) <- gsub("-std\\(\\)$", "StdDev", colnames(selected))

    # Now let us find the final dataset, which is an average of the columns 
    # grouped by Activity and Subject
    groupedData <- group_by(selected, Activity, Subject)
    finalData <- summarise_all(groupedData, mean)
    finalData
    
}

# Test Method to read the final data from a saved table file. 
readFinalData <- function(filePath) {
    
    if(!file.exists(filePath)) {
        print(paste("The file: ", filePath, "does not exist"))
        return()
    }
    
    finalData <- read.table(filePath, header = T)
    View(finalData)
}