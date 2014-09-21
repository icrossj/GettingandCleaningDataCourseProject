# Getting and Cleaning Data Course Project

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

Each of the codeblock will be detailed below.

### Download the File

This takes the data from the web and downloads it to the working directory. It will then unzip the files for the process to go further.


```r
setInternet2(use = TRUE)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="UCI_HAR_DATASET.zip", method="auto")
unzip("UCI_HAR_Dataset.zip")
```

### Reading the x_test, x_train, y_test, y_train, subject_test, subject_train

In this part, the files are separated into a test and train section. To combine the whole dataset, we will need to merge these x, y, and subject files together. The **x** files are the actual data gathered. Each of the 561 columns have names found in "factor.txt". The **subject** files contain the subject number of the participant. The **y** files indicate the activity that the participant are performing. This includes "walking", "lying down" and so on. The sequence is in the same order and merging them will be performed in the same order.




```r
#Read in the datasets
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",stringsAsFactors =F)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",stringsAsFactors =F)

y_test <- read.table("UCI HAR Dataset/test/y_test.txt",stringsAsFactors =F)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",stringsAsFactors =F)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",stringsAsFactors =F)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",stringsAsFactors =F)

#Merge the test and train
x <- rbind(x_test,x_train)
y <- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)
```


### Replacing numbers with more readable names (Objective 3)
The **y** files had numbers to represent the activities performed. This activites correlation is found in "activity_labels.txt". The code below converts the numbers to something more meaningful.


```r
toActivity <- function(x){
  if(x == 1){return ("WALKING")}
  if(x == 2){return ("WALKING_UPSTAIRS")}
  if(x == 3){return ("WALKING_DOWNSTAIRS")}
  if(x == 4){return ("SITTING")}
  if(x == 5){return ("STANDING")}
  if(x == 6){return ("LAYING")}
  return ("NA")
  }

y$V1 <- unlist(lapply(y$V1,toActivity))
```


### Merging the data into one dataset (Objective 1)
Finally, the merging of the datasets.


```r
full_dataset <- cbind(subject,y,x)
```

### Making columns more readable in Dataset (Objective 4)
The column names were missing. This imports the column names and inserts it into the dataframe.

```r
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors =FALSE)
readable_colnames <- c("SubjectNumber","Activity",features$V2)

names(full_dataset) <- readable_colnames
```

### Subsetting the full dataset to a smaller dataset (Objective 2)
Here, we are extracting only the columns that have "mean" and "std". I'm removing "angles" because it does not seem to make sense.


```r
require(dplyr)
```

```
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
subset_Dataset <- select(full_dataset,contains("Subject"),contains("Activity"), contains("mean"),contains("std"),-contains("angle"))
write.table(full_dataset, file="full_tidy_set.txt", row.name=FALSE)
```

### Arranging means over two factors (Objective 5)
This is arranging the results by Subject and Activity. It takes the average of all the columns attached and writes it out to a text file.

```r
require(dplyr)
tidy_set <- group_by(subset_Dataset,SubjectNumber,Activity) %>% summarise_each(funs(mean))
write.table(tidy_set, file="smaller_tidy_set.txt", row.name=FALSE)
```

