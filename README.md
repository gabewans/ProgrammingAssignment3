# ProgrammingAssignment3
Getting and Cleaning Data course: Programming Assignment 3

The code contained in this project use data collected from wearable computing devices, and prepares a tidy data set that could be used to perform further analysis.

At a high level, the program does the following:
1: Merges the training and the test data sets into one data set.
2: Extracts only the columns containing measurements on the mean and standard deviation for each measurement. 
3: Updates the data set to use descriptive activity names
4: Labels the data set with descriptive variable names. 
5: Creates a second tidy data set with the average of each variable for each activity and each subject.

Variable and column descriptions can be found in the CodeBook.md file.

The data for the project can be downloaded here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The analysis is performed in 'run_analysis.R'.  It is assumed the data was downloaded and extracted into the current working directory for R.

The results of the analysis is a tidy data set contained in the current working directory for R, called 'Course3ProjectTidyDataset.txt'.
