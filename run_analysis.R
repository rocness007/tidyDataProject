# You should create one R script called run_analysis.R that does the following. 
#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names. 
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.

#checks to see if there is a file named data in the working directory, if not it will create one

if((!file.exists("data"))){
        dir.create("data")
}

#The below code is used if you would like to download from the website but is commented out
        #file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        #download.file(file.url, destfile ="./data/project.zip")

#stores date of downloaded file
        #datadownloaded <- date()

#this is only used if you have downloaded the zip file from the website that was provided
#unzips file and loads activity and feature files
        #unzip("./data/project.zip", exdir="./data")

#this saves the activity and feature information for later use 
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt", sep="",header=F)
features <- read.table("./data/UCI HAR Dataset/features.txt", sep="",header=F)

#Ignoring the Inertial Signals folders
#loads in the test files and combines to one file
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", sep="",header=F)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", sep="",header=F)
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", sep="",header=F)

combinedTest <- cbind(subject_test,y_test,X_test)


#loads in the train files and combines to one file
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", sep="",header=F)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", sep="",header=F)
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", sep="",header=F)

combinedTrain <- cbind(subject_train,y_train,X_train)

#combine test and train files
combinedData <- rbind(combinedTrain, combinedTest)

#extract the index of the names that contain mean() or sd() from the features.txt file loaded earlier
#first create a new features object that combines "subject" and "activity" variable names with the original 
#features.txt variable names
features2 <- c("subject", "activity", as.character(features[,2]))

#extract the files only the columns asked for (mean(), and std()) by first identifying their locations
my_pattern <- "mean()|std()|subject|activity"
mean_std_index <- unique(grep(my_pattern, features2))

#name the columns of the combinedData with the names from the features2 file we created before
names(combinedData)[1:dim(combinedData)[2]] <- features2

#subset the dataframe to only include those that have been asked for
combinedData2 <- combinedData[,mean_std_index]

#add the descriptive activity as matched to the activity text file (used a for loop)
combinedData2_activity <- combinedData2$activity

#overwrite the activity with the descriptive activity
a <- "test"
for(i in 1:length(combinedData2_activity)){
        a <- activity[combinedData2_activity[i],2]
        combinedData2$activity[i] <- as.character(a)
}

#clean up the names a little, starting with removing mean() and std()
colNames_old <- names(combinedData2)
colNames_new <- gsub("mean()","Average", colNames_old, fixed=TRUE)
colNames_new <- gsub("std()", "StdDev", colNames_new, fixed=TRUE)
colNames_new <- gsub("()", "", colNames_new,fixed=TRUE)
colNames_new <- gsub("mean", "Average", colNames_new, fixed=TRUE)
colNames_new <- gsub("-", "", colNames_new, fixed=TRUE)
colNames_new <- gsub("X", "OfAxisX", colNames_new, fixed=TRUE)
colNames_new <- gsub("Y", "OfAxisY", colNames_new, fixed=TRUE)
colNames_new <- gsub("Z", "OfAxisZ", colNames_new, fixed=TRUE)
colNames_new <- gsub("BodyAccJerk", "AccJerkOfBody", colNames_new, fixed=TRUE)
colNames_new <- gsub("Mag", "Magnitude", colNames_new, fixed=TRUE)
colNames_new <- gsub("BodyGyroJerk", "GyroJerkOfBody", colNames_new, fixed=TRUE)

#add new names to the data set
names(combinedData2) <- colNames_new

#create a tidy data set with the averages of each of the variables from data set for each activity and each subject
#uses the reshape2 library

library(reshape2)
dataMelt <- melt(combinedData2,id=c("subject", "activity"))

tidyData <- dcast(dataMelt, activity + subject ~ variable,mean)

#change the names a little
coNames_old2 <- names(tidyData)
for(i in 3:length(coNames_old2)){
        coNames_old2[i] <- paste0("Average",coNames_old2[i])
        
}
names(tidyData) <- coNames_old2

#writes tidyData txt file to data directory
write.table(tidyData,"./data/tidyData.txt", row.names=FALSE)
