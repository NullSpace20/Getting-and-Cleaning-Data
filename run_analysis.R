if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

                             #Reading files

# Reading trainings tables
Xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
SubjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables
Xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
SubjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector
Features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels
ActivityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')



# Assigning column names
colnames() <- features[,2] 
colnames(Ytrain) <-"activityId"
colnames(SubjectTrain) <- "subjectId"

colnames(Xtest) <- features[,2] 
colnames(Ytest) <- "activityId"
colnames(SubjectTest) <- "subjectId"

colnames(ActivityLabels) <- c('activityId','activityType')


#Merging all data in one set
MergeTrain <- cbind(Ytrain, SubjectTrain, Xtrain)
MergeTest <- cbind(Ytest, SubjectTest, Xtest)
setAllInOne <- rbind(MergeTrain, MergeTest)


#Reading column names
colNames <- colnames(setAllInOne)

#Create a vector for ID, mean and sd
mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)

# subset from setAllInOne
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


#name the activities in the data set
setWithActivityNames <- merge(setForMeanAndStd,activityLabels,by='activityId',all.x=TRUE)
                              
                        
#Making second tidy data set
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
secTidySet

#Writing second tidy data set in txt file
write.table(secTidySet, "Sec_Tidy_Set.txt", row.name=FALSE)

