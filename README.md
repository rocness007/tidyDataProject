# Tidy Dataset Project
#
##This README document explains how the tidy dataset was generated for the Coursera Course Getting and Cleaning Data.
*Background information of the data used can be found at <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.
##
*The original dataset can be found at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. 
###run_analysis.R Script General Information
*This script has been created to assist in generating the tidy data set.
###
*In order to use the script, the working directory has to contain an unzipped file containing the "UCI HAR Dataset".
###
*The script will write a text file to the working directory titled "tidyData".
###
*The "tidyData" text file is a merged and subsetted dataset version of the original files found in "UCI HAR Dataset".
###
###run_analysis.R Detailed Information
*Merges the training and the test sets to create one data set, ignoring any files in the "Inertial Signals" folder.
###
*Extracts only the measurements on the mean and standard deviation for each measurement.
###
*Uses descriptive activity names to name the activities in the data set.
###
*Appropriately labels the data set with descriptive variable names.
###
*Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

