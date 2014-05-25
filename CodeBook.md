Getting And Cleanning Data - Course Project - CodeBook
========================================================

This is a document that describes how to obtain, extract, and prepare a tidy data


Variables and Data 
------------------------
The data is from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
The description for the files in the zip folder is in the README.txt file in the UCI HAR Dataset folder (appear after unzipping the files).  

### Data and Variables in the tidy data set
The final tidy data set named "CourseProject_tidydata.txt" is a text file containing entries seprated by commas
* The data has 180 rows and 35 columns
* The first column is the subject participating in the measurements
* The second column is the activity the subject was performing
* The other 33 columns are averaged mean-measurements of various features for each subject performing a particular activity
* The name of the mean-measurements are taken from the feature.txt file in the UCI HAR Dataset

Processing Data
================================

The following describes how to get, extract and clean data


Getting Data
------------------------

### Load necessary packages
Assuming these packages are already installed. If not, use install.packages("packagename") 
to install the packages
* reshape2: to use melt and dcast methods
* plyr: to use ddply method

### Download the zip file containing data
* This will download the zip file to the current working directory as "CourseProject.zip"  
* The script first check if "CourseProject.zip" is already downloaded, if not, it will download and unzip the file. 


Reading Data
-------------------------

### Specify path to files in the UCI HAR Dataset
* Assume that UCI HAR Dataset is in your working directory (if you unzip the file sucessfully, it should be there)  
* Using the getwd(), and paste functions to create strings of characters that specify the paths. There should be 8 files in total

### Read in the files
* There should be a total of 8 tables
* For each set (train or test), there are 3 tables to read
  * subject: which subject was measured 
  * y: which activity the subject performed
  * X: which feature of the activity was measured for the subject
* Tables features and activity stores the descriptive names of features and activities that can be used to label data later


Merging Data
--------------------------
### Merge train and set data in one single data 
* Create a data frame for each train and test set from subject, activities
* Merge two data frames into one single data frame using rbind


Labeling Data 
---------------------------
### Add column labels
* Create a vector of column names using the features' names from features table
* Replace the column names in the merged data frame (merged_data) by the column names just created

### Add descriptive names for activities
* Loop through entries in column 'activity' in merged_data, and first columns in activity table
* If the entries are equal, replace the entry in 'activity' column of merged_data by the corresponding entry in the second column of activity table
* Has to make sure to first convert entries to class character


Extracting Data
---------------------------
* Use grep function to extract the index of mean() and std() from feature table
* The result vector is the position of all mean and std measurements in the original X data
* Since the merged data has 2 additional columns (subect and activity, we need to shift the index of the mean and std in the merged data by 2
* Subset merged data using the column index of mean and std measurements


Creating Tidy Data
---------------------------
* Use the index vector of mean measurements (from the above step), shift the index by 2 to create the column index for mean measurements in the merged data
* Subset merged data to extract only mean measurements using the column index of mean measurements
* Reshape the data using ddply to calculate the average for each feature of mean measurements (33 features), subject and activity
* Cast the long data to wide data using dcast to organize data into a 180X35 data frames
* Write tidy data to a txt file using write.table





