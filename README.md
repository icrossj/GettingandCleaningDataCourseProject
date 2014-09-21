Getting andCleaning Data Course Project
===================================

Project for Getting and Cleaning Data

The work involves running one R script called "run_analysis.R" that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

What the code does is the following:
- It will download the dataset into the working directory, and then use rbind to combine the x and y sets of data into one dataset for objective (1).
- It will then read the names from the "features.txt" and "activity_labels.txt" to give more descriptive names and activities for objectives (3) and (4)
- It will then extract the measurements that have mean and standard deviation for objective (2).
- Finally, it will create a second independent tidy dataset for objective (5).

How To Use
===================================
1. source(run_analysis.R)

This will produce a dataset file for Parts 1-4, and another dataset file for Part 5.

