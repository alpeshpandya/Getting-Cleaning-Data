#This R script does the following:
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive activity names. 
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Step number 1: merging data sets
xtrain <- read.table("train/X_train.txt")
xtest <- read.table("test/X_test.txt")
xmerged <- rbind(xtrain, xtest)

subtrain <- read.table("train/subject_train.txt")
subtest <- read.table("test/subject_test.txt")
submerged <- rbind(subtrain, subtest)

ytrain <- read.table("train/y_train.txt")
ytest <- read.table("test/y_test.txt")
ymerged <- rbind(ytrain, ytest)

#Step number 2: Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
keepfeatures <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
xmerged <- xmerged[, keepfeatures]
names(xmerged) <- features[keepfeatures, 2]
names(xmerged) <- gsub("\\(|\\)", "", names(xmerged))
names(xmerged) <- tolower(names(xmerged)) 

#Step number 3: Uses descriptive activity names to name the activities in the data set

actlabels <- read.table("activity_labels.txt")
actlabels[, 2] = gsub("_", "", tolower(as.character(actlabels[, 2])))
ymerged[,1] = actlabels[ymerged[,1], 2]
names(ymerged) <- "activity"

#Step number 4: Appropriately labels the data set with descriptive activity names.

names(submerged) <- "subject"
cleandata <- cbind(submerged, ymerged, xmerged)
write.table(cleandata, "cleandata.txt")

#Step number 5: Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

subjects = unique(submerged)[,1]
i = length(unique(submerged)[,1])
j = length(actlabels[,1])
columns = dim(cleandata)[2]
data = cleandata[1:(i*j), ]

row = 1
for (sub in 1:i) {
	for (act in 1:j) {
		data[row, 1] = subjects[sub]
		data[row, 2] = actlabels[act, 2]
		temp <- cleandata[cleandata$subject==sub & cleandata$activity==actlabels[act, 2], ]
		data[row, 3:columns] <- colMeans(temp[, 3:columns])
		row = row+1
	}
}
write.table(data, "averagedata.txt")

