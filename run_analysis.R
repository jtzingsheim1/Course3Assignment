# Coursera Data Science Specialization Course 3 Week 4 Assignment


# Acknowledgement for this dataset goes to: Davide Anguita, Alessandro Ghio,
# Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition
# on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine.
# International Workshop of Ambient Assisted Living (IWAAL 2012).
# Vitoria-Gasteiz, Spain. Dec 2012


# The purpose of this script is to satisfy the requirements of the week 4
# peer-graded assignment that is part of the Getting and Cleaning Data course
# within the Data Science Specialization on Coursera. As per the instructions
# the script must:
# - Merge the training and test data sets to create one data set
# - Extract only the measurements on the mean and standard deviation for each
# - Use descriptive activity names to name the activities in the data set
# - Appropriately label the data set with descriptive variable names
# - Create a tidy data set with the average of each variable for each activity
#
# This script does all of the above, however not necessarily in that order. The
# input for this script is the data set obtained from the url below. The output
# is the tidy data set called "data.sub1.means". This output is left as an
# object after running the script, and it is also saved as a file called
# "TidyData.txt".


library(dplyr)
library(tidyr)


# Part 1: Download and unzip the data as needed

file.name <- "ProjectData.zip"

# Check if the file exists in the directory before downloading it again
if (!file.exists(file.name)) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, file.name)
  date.downloaded <- date()  # Store the date of the download as a reference
  rm(url)  # Remove objects that are no longer needed
}

# Check if the file has been unzipped before unzipping again
if (!file.exists("UCI HAR Dataset")) {
  unzip(file.name)
}

rm(file.name)  # Remove objects that are no longer needed


# Part 2: Read in the raw data from the unzipped folder

activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              colClasses = c("integer", "character"),
                              col.names = c("activity.code", "activity"))
features        <- read.table("UCI HAR Dataset/features.txt",
                              colClasses = c("integer", "character"),
                              col.names = c("feature.index", "feature"))
subject.test    <- read.table("UCI HAR Dataset/test/subject_test.txt",
                              colClasses = "integer",
                              col.names = "subject")
x.test          <- read.table("UCI HAR Dataset/test/X_test.txt",
                              colClasses = c(rep("numeric", 561)),
                              col.names = features$feature)
y.test          <- read.table("UCI HAR Dataset/test/y_test.txt",
                              colClasses = "integer",
                              col.names = "activity.code")
subject.train   <- read.table("UCI HAR Dataset/train/subject_train.txt",
                              colClasses = "integer",
                              col.names = "subject")
x.train         <- read.table("UCI HAR Dataset/train/X_train.txt",
                              colClasses = c(rep("numeric", 561)),
                              col.names = features$feature)
y.train         <- read.table("UCI HAR Dataset/train/y_train.txt",
                              colClasses = "integer",
                              col.names = "activity.code")


# Part 3: Combine data frames, reclass as a tbl_df object

# Combine all the data into a single data frame
data.train <- bind_cols(subject.train, y.train, x.train)
data.test <- bind_cols(subject.test, y.test, x.test)
data.all <- bind_rows(data.train, data.test)

# Reclass as tbl_df object and add activity labels so activities are descriptive
data.all <- tbl_df(data.all)
data.all <- inner_join(data.all, activity.labels, by = "activity.code")

# Remove objects that are no longer needed
rm(data.test, data.train, subject.test, subject.train, x.test, x.train, y.test,
   y.train, features, activity.labels)


# Part 4: Subset out only the columns for mean and standard deviation

keep.features <- grep("mean\\.|std\\.", colnames(data.all), value = TRUE)
  # The instructions specify to extract only measurements  on the mean and
  # standard deviation, this would not include the meanFreq() components

# Selecting the "activity" column below will keep the descriptive names 
data.sub1 <- select(data.all, c("subject", "activity", keep.features))

# This would be a place to rename the columns if desired, but they are already
# descriptive from when initially loaded using read.table despite the fact that
# special characters such as () were converted to periods

rm(keep.features, data.all)  # Remove objects that are no longer needed


# Part 5: Create the tidy data set with the average of each variable for each
# activity and each subject

# The piping below will melt the previous dataset, then split-apply-combine to
# get the means for each group. The output is a tidy data set.
data.sub1.means <- data.sub1 %>%
  gather(feature, value, -(subject:activity)) %>%
  group_by(subject, activity, feature) %>%
  summarize(mean = mean(value))

rm(data.sub1)  # Remove objects that are no longer needed


# Part 6: Save the tidy data set to a .txt file and show an example read in

# The final result could be the tbl_df object from above, but if the result is
# instead considered a data frame it simplifies the code required to return an
# identical object after reading in the saved file.
data.sub1.means <- data.frame(data.sub1.means)

# Save the final result to a txt file
write.table(data.sub1.means, "TidyData.txt", row.names = FALSE)

# Below is an example of how the file could be read in to reproduce the exact
# object which was the final result of the assignment
# data.sub1.means <- read.table("TidyData.txt", stringsAsFactors = FALSE,
#                               header = TRUE)
