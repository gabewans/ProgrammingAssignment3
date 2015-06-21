library(dplyr)

# Read in the column names
col_names_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt"
col_names <- read.table(col_names_filename)

# Make a vector of the column names to use for naming the columns in the file
col_vector <- col_names[,2]
# Cleanup column names to remove dashes and parens since they are invalid column header chars
col_vector <- gsub("\\(\\)", "", gsub("-", "", col_vector))

# read in the activity labels
activity_labels_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt"
activity_labels <- read.table(activity_labels_filename, col.names=c("Activity", "ActivityName"))

# set filenames
X_test_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt"
Y_test_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\Y_test.txt"
subject_test_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt"

X_train_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt"
Y_train_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\Y_train.txt"
subject_train_filename <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt"

# Read in the test/train data using the column names vector to name the columns
X_test <- read.table(X_test_filename, col.names=col_vector)
Y_test <- read.table(Y_test_filename, col.names=c("Activity"))
subject_test <- read.table(subject_test_filename, col.names=c("Subject"))

X_train <- read.table(X_train_filename, col.names=col_vector)
Y_train <- read.table(Y_train_filename, col.names=c("Activity"))
subject_train <- read.table(subject_train_filename, col.names=c("Subject"))


# row bind the test and train data files
merged_X_file <- rbind(X_test, X_train)
merged_Y_file <- rbind(Y_test, Y_train)
merged_subject_file <- rbind(subject_test, subject_train)

# column bind the subjects, activities, and measurement data into one file
merged_working_file <- cbind(merged_subject_file, merged_Y_file, merged_X_file)

# identify the subject, activity, std and mean columns we want to keep
colsToKeep <- c(1, 2, 3:8, 43:48, 83:88, 123:128, 163:168, 203, 204, 216, 217, 229, 230, 242, 243, 255, 256, 268:273, 347:352, 426:431, 505, 506, 518, 519, 531, 532, 544, 545)

# subset only the columns we need
slim_working_file <- merged_working_file[, colsToKeep]

# merge the working file with the Activity Labels file to get meaningful activity labels
slim_working_file <- merge(slim_working_file, activity_labels, by.x="Activity", by.y="Activity",  all=TRUE)

# reorder the columns so the subject is first and the activity second
slim_working_file <- select(slim_working_file, Subject, ActivityName, tBodyAccmeanX:fBodyBodyGyroJerkMagstd)

# re-name ActivityName to just Activity
slim_working_file <- rename(slim_working_file, Activity=ActivityName)

# Order the data by Subject and Activity
slim_working_file <- arrange(slim_working_file, Subject, Activity)

# group the columns by Subject and Activity, averaging the std and mean columns
grouped_working_file <- aggregate(slim_working_file, by=list(Subject=slim_working_file$Subject, Activity=slim_working_file$Activity), FUN=mean)

# The aggregate function added 2 extra columns - remove those
grouped_working_file <- grouped_working_file[,-c(3:4)]

# print the results to a file
write.table(grouped_working_file, "Course3ProjectTidyDataset.txt", row.names=FALSE)

