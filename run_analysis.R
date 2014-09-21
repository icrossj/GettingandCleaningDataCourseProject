#For a better explanation, please look at the CodeBook.md


### Download the File



setInternet2(use = TRUE)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="UCI_HAR_DATASET.zip", method="auto")
unzip("UCI_HAR_Dataset.zip")

### Reading the x_test, x_train, y_test, y_train, subject_test, subject_train


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



### Replacing numbers with more readable names (Objective 3)

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



### Merging the data into one dataset (Objective 1)



full_dataset <- cbind(subject,y,x)


### Making columns more readable in Dataset (Objective 4)

features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors =FALSE)
readable_colnames <- c("SubjectNumber","Activity",features$V2)

names(full_dataset) <- readable_colnames

### Subsetting the full dataset to a smaller dataset (Objective 2)

require(dplyr)
subset_Dataset <- select(full_dataset,contains("Subject"),contains("Activity"), contains("mean"),contains("std"),-contains("angle"))
write.table(full_dataset, file="full_tidy_set.txt", row.name=FALSE)


### Arranging means over two factors (Objective 5)

require(dplyr)
tidy_set <- group_by(subset_Dataset,SubjectNumber,Activity) %>% summarise_each(funs(mean))
write.table(tidy_set, file="smaller_tidy_set.txt", row.name=FALSE)


