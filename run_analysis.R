################################################################################
## Coursera - Getting and Cleaning Data : Week 4 Course Project               ##
## Objective : To download a file and produce a set of tidy data from data in ##
##             in the file                                                    ##
##                                                                            ##
## Version History                                                            ##
## Date        Version  Comments                                              ##
## ----------  -------  ----------------------------------------------------- ##
## 2016-03-22   0       Initial                                               ##
## 2016-03-23   0.1     1. Added code to generate tidy data set               ##
##                      2. Added code to reshape data                         ##
################################################################################

## STEP 1 - load in the necessary libraries
## for data frame library
library(data.table)
## for subsetting, grouping, etc.
library(dplyr)
## for gathering
library(tidyr)
## for string manipulation
library(stringr)

## STEP 2 - download the zip file from URL given
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "Wk4Proj.zip", mode = "wb")

## STEP 3 - unzip the file
unzip("Wk4Proj.zip")

## STEP 4 - read in the column names
colNames <- fread("UCI HAR Dataset/features.txt")

## STEP 5 - read the contents of the test data file
test.raw <- fread("UCI HAR Dataset/test/X_test.txt")

## STEP 6 - read the contents of the test label file
test.label.raw <- fread("UCI HAR Dataset/test/y_test.txt")

## STEP 7 - rename the column to "Label" so that column names do not repeat when
## merged with data
names(test.label.raw) = "Label"

## STEP 8 - read the contents of the test subject file
test.subj.raw <- fread("UCI HAR Dataset/test/subject_test.txt")

## STEP 9 - rename the column to "Subject" so that column names do not repeat
## merged with data
names(test.subj.raw) = "Subject"

## STEP 9 - combine test data with labels
test <- cbind(test.raw, test.label.raw, test.subj.raw)

## STEP 10 - read the contents of the training data file
train.raw <- fread("UCI HAR Dataset/train/X_train.txt")

## STEP 11 - read the contents of the training label file
train.label.raw <- fread("UCI HAR Dataset/train/y_train.txt")

## STEP 12 - rename the column to "Label" so that column names do not repeat
## when merged with data
names(train.label.raw) = "Label"

## STEP 13 - read the contents of the train subject file
train.subj.raw <- fread("UCI HAR Dataset/train/subject_train.txt")

## STEP 14 - rename the column to "Subject" so that column names do not repeat
## merged with data
names(train.subj.raw) = "Subject"

## STEP 15 - combine training data with labels
train <- cbind(train.raw, train.label.raw, train.subj.raw)

## STEP 16 - merge the test and training data together
full.data <- rbind(test, train)

## STEP 17 - rename the columns in full.data per colNames
names(full.data)[1:561] = colNames$V2

## STEP 18 - select the columns for subject, label, mean and standard deviations
## Note : Per features_info.txt, these are columns labelled "mean()" and "std()"
mean_sd.data <- select(full.data, Subject, Label, contains("mean()"),
                       contains("std()"))

## STEP 19 - load lookup table for activties
labelNames <- fread("UCI HAR Dataset/activity_labels.txt")

## STEP 20 - rename 2nd column to "Activity"
names(labelNames)[2] = "Activity"

## STEP 21 - lookup the proper activity name for the labels
mean_sd.data.proper <- merge(mean_sd.data, labelNames,
                                  by.x = "Label", by.y = "V1")

## STEP 22 - remove the Label column now that the activity name is there
mean_sd.data.proper <- select(mean_sd.data.proper, -Label)

## STEP 23 - rename the measurement columns, removing brackets and substituting
## dashes for underscores.  Example : tBodyAcc-mean()-X becomes tBodyAcc_mean_X
names(mean_sd.data.proper) <- gsub("-", "_",
                                   gsub("(\\(|\\))", "",
                                        names(mean_sd.data.proper)))

## STEP 24 - create a data set which contains the mean per subject per activity
data.proper.avg <- mean_sd.data.proper %>% group_by(Subject, Activity) %>%
                                           summarise_each(funs(mean))

## STEP 25 - At this point, I think the data is sufficiently tidy.  However, I
## will like to reshape the data to this format :
## Column 1 : Subject - Subject identifier [Integer 1 to 30]
## Column 2 : Activity - Values ("WALKING", "WALKING_UPSTAIRS",
##                               "WALKING_DOWNSTAIRS", "SITTING", "STANDING",
##                               "STANDING")
## Column 3 : Measurement - Values ("BodyAcc", "GravityAcc", "BodyAccJerk",
##                                  "BodyGyro", "BodyGyroJerk")
## Column 4 : FFTApplied - Values ("Yes", "No")
## Column 5 : EstimateBy - Values ("Mean", "Standard Deviation")
## Column 6 : MeanX - Mean value computed from raw data at X axis 
## Column 7 : MeanY - Mean value computed from raw data at Y axis
## Column 8 : MeanZ - Mean value computed from raw data at Z axis
## Column 9 : MeanMag - Mean value computed from raw data of magnitude
## I think the above of having extra factors converted from columns might be
## more suitable for analysis.  In multi-dimensional data modelling terms,
## columns 1 to 5 are the dimensions, whereas, columns 6 to 9 are the measures.

tidy.data <- data.proper.avg %>%
             ## put column names as values for cnames, except Subject and
             ## Activity
             gather(cnames, value, -Subject, -Activity) %>%
             ## split cnames into 3 columns using underscore as a separator
             ## c1 = first character indicates whether FTT is applied;
             ##      rest of string represent Measurement
             ## c2 = the estimation method (Mean or Standard Deviation)
             ## c3 = axis X, Y or Z; will be NA for magnitude measurements
             separate(cnames, c("c1", "c2", "c3"), "_", extra = "drop",
                      fill = "right") %>%
             ## add in additional columns based on value in c1, c2, and c3
             mutate( ## removes the first character in c
                     ## Example : fBodyBodyGyroJerkMag -> BodyBodyGyroJerkMag
                    Measurement = substr(c1, 2, nchar(c1)),
                     ## removes "Mag" if any
                     ## Example : BodyBodyGyroJerkMag -> BodyBodyGyroJerk
                    Measurement = sub("Mag", "", Measurement),
                     ## removes duplicate "Body", if any
                     ## Example : BodyBodyGyroJerk -> BodyGyroJerk
                    Measurement = sub("BodyBody", "Body", Measurement),
                     ## if first character is f, FTT is applied
                    FTTApplied = ifelse(substr(c1, 1, 1) == "f",
                                        "Yes", "No"),
                     ## the method/formula used to derive value
                    EstimateBy = ifelse(c2 == "mean",
                                          "Mean", "Standard Deviation"),
                     ## these are the 4 types of measures, mean of X, Y, Z and
                     ## magnitude
                    measures = ifelse(is.na(c3), "MeanMag",
                                      paste("Mean", c3, sep = ""))) %>%
             ## remove columns c1 to c3
             select(-(c1:c3)) %>%
             ## spread the values of the measures into their separate columns
             ## Note that measurement of BodyGyroJerk with FTT applied is only
             ## present for MeanMag, hence NA values for MeanX, MeanY & MeanZ
             spread(measures, value)

## Step 26 - export tidy data to a csv file
write.csv(tidy.data, file = "tidy_data.csv", row.names = FALSE)