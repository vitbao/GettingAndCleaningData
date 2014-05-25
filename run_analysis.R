## Getting And Cleanning Data - Course Project

##-----Getting Data-----

# load necessary packages
library(reshape2) # to use melt
library(plyr) # to use ddply

# download the data file to current working directory if it hasn't been downloaded
if (file.exists("CourseProject.zip") == FALSE){
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, "CourseProject.zip")
        # unzip the file to current directory
        unzip("CourseProject.zip")
}

# specify path to files
wd <- getwd() # current working directory
train_dir <- paste(wd, "/UCI HAR Dataset/train/", sep = "")
test_dir <- paste(wd, "/UCI HAR Dataset/test/", sep = "")
X_train_file <- paste(train_dir, "X_train.txt", sep = "")
y_train_file <- paste(train_dir, "y_train.txt", sep = "")
subject_train_file <- paste(train_dir, "subject_train.txt", sep = "")
X_test_file <- paste(test_dir, "X_test.txt", sep = "")
y_test_file <- paste(test_dir, "y_test.txt", sep = "")
subject_test_file <- paste(test_dir, "subject_test.txt", sep = "")
features_file <- paste(wd, "/UCI HAR Dataset/features.txt", sep = "")
activity_file <- paste(wd, "/UCI HAR Dataset/activity_labels.txt", sep = "")

# read in above files using read.table
X_train <- read.table(X_train_file)
y_train <- read.table(y_train_file)
subject_train <- read.table(subject_train_file)
X_test <- read.table(X_test_file)
y_test <- read.table(y_test_file)
subject_test <- read.table(subject_test_file)
features <- read.table(features_file)
activity <- read.table(activity_file)

##-----Part 1: Merging Data-----

# create train and test data frames from respected subject, y and X data
train_data <- data.frame(subject_train, y_train, X_train)
test_data <- data.frame(subject_test, y_test, X_test)

# merge two data sets using rbind (Part 1)
merged_data <- rbind(train_data, test_data)

##-----Part 3 & 4: Adding Data Labels-----

# add column names (Part 3 & 4)
colnames <- c("subject", "activity", as.character(features[, 2]))
colnames(merged_data) <- colnames

# get the dimension of merged_data and activity
dim_merged_data <- dim(merged_data)
dim_activity <- dim(activity)
# convert "activity" column in merged_data to character
merged_data$activity <- as.character(merged_data$activity)
# convert data in activity table to character
activity[, 1] <- as.character(activity[, 1])
activity[, 2] <- as.character(activity[, 2])
# replace numbers in "activity" column by activity names (as in activity table)
for (i in 1:dim_merged_data[1]) {
        for (j in 1:dim_activity[1]) {
                if (merged_data$activity[i] == activity[j, 1]) {
                        merged_data$activity[i] <- activity[j, 2]
                }        
                j = j + 1
        }
        i = i + 1
}

##-----Part 2: Extracting Data-----

# identify mean and std variables from table features
mean_variables <- grep("mean()", as.character(features[, 2]), fixed = TRUE) 
std_variables <- grep("std()", as.character(features[, 2]), fixed = TRUE) 

# column index of mean and std (in X data (train and test))
column_index <- c(mean_variables, std_variables)

# since we add two columns (subject and activity to the measurement data), shift the index by 2
column_index <- column_index + rep(2, length(column_index))

# extract mean and std measurements
mean_std <- merged_data[ ,c(1:2, column_index)]

##-----Part 5: Creating Tidy Data-----

# column index of mean measurements in merged_data
mean_index <- mean_variables + rep(2, length(mean_variables))

# extract mean measurements
mean <- merged_data[ ,c(1:2, mean_index)]

# extract mean variables' names 
mean_column_names <- colnames(mean)[3:length(colnames(mean))]

# reshape the data frame to a 4-column data frame
tidy_data <- melt(mean, id = c("subject", "activity"), measure.vars = mean_column_names)

# view the reshape data to see the new column names
head(tidy_data)

# split data frame by subject, activity and measurement, 
# apply mean function to measurements, and return new data frame
tidy_data <- ddply(tidy_data, .(subject, activity, variable), summarize, mean = mean(value))

# cast the data to 180x35 data frame
tidy_data <- dcast(tidy_data, subject + activity ~ variable)

# write the tidy data to a csv file
write.table(tidy_data, "CourseProject_tidy_data.txt", sep = ",", row.names = FALSE)