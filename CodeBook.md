# Coursera : Getting & Cleaning Data - Week 4 Course Project
*Please refer to README.md for an overview of this project*

## Data Source
### Abstract
Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

### Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Attribute Information
For each record in the dataset it is provided: 
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

### Feature Selection
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

## R Script
The script to run to get the final output `tidy_data.csv` is `run_analysis.R`.  Running this script will start with the process of downloading the zip file containing the raw data, and end with the creation of `tidy_data.csv`.    
                
To execute the script, make sure that the script is saved in the current working directory first.  Next, type at the R console :
```
source("run_analysis.R")
```           
                 
The following gives a quick overview of the steps taken in the script :
### Getting the raw data files
1. Download zip file from URL (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. Unzip file into working directory
   + Structure
   ```
   +-- UCI HAR Dataset
   |   +-- activity_labels.txt  
   |   +-- features.txt
   |   +-- features_info.txt
   |   +-- README.txt
   +-- test
   |   +-- Inertial Signals
   |   |   +-- [Not relevant]
   |   +-- subject_test.txt
   |   +-- X_test.txt
   |   +-- y_test.txt
   +-- train
   |   +-- Inertial Signals
   |   |   +-- [Not relevant]
   |   +-- subject_train.txt
   |   +-- X_train.txt
   |   +-- y_train.txt
   ```

### Create a single data table
3. Read in the following files and merge them into a single data table
   + `features.txt` - contains the column names for `X_test.txt` and `X_train.txt`
   + `subject_test.txt` - contains the subject ID for `X_test.txt`
   + `y_test.txt` - contains the activity label for each row in `X_test.txt`
   + `X_test.txt` - contains the measurements for test data
   + `subject_train.txt` - contains the subject ID for `X_train.txt`
   + `y_train.txt` - contains the activity label for each row in `X_train.txt`
   + `X_train.txt` - contains the measurements for train data

### Reduce data through selection, grouping and summarizing
4. Reduce data by selecting only columns for Subject, Activity Label and column names containing "mean()" or "std()"

5. Lookup the respective activity (WALKING, SITTING, etc.) from `activity_labels.txt`.

6. Clean up column names by replacing "-" (dash) with "_" (underscore) and removing "()" (brackets).

7. Group by Subject and Activity and summarize the mean for each column.

### Tidy up the data
8. Tidy up the data by reshaping it.

### Output
9. Output data into `tidy_data.csv`.

## Final Output
Final output is a comma-delimited file - `tidy_data.csv`.

### Columns
* Subject (int) : An ID that is used to identify the subject being measured (Values - 1 to 30)
* Activity (chr) : A factor indicating the activity that was being measured (Values - LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS)
* Measurement (chr) : A factor indicating what was bring measured (Values - BodyAcc, BodyAccJerk, BodyGyro, BodyGyroJerk, GravityAcc)
* FTTApplied (chr) : A factor indicating if Fast Fourier Transform was applied (Values - Yes, No)
* EstimateBy (chr) : A factor indicating the function used to estimate the measurements in the raw data. (Values - Mean,  Standard Deviation)
* MeanMag (num) : Mean value computed from raw data of magnitude
* MeanX (num) : Mean value computed from raw data of X axis
* MeanY (num) : Mean value computed from raw data of Y axis
* MeanZ (num) : Mean value computed from raw data of Z axis

### Consideration
The data has been reshaped based on multi-dimensional data modelling technique.  Columns Subject to EstimateBy are the dimensions while the Mean* columns are the measures.

### Note
For measurement of BodyGyroJerk with FTT applied, data is only present for magnitude, hence you will see NA values for MeanX, MeanY and MeanZ.

-------
*References :*
* http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
* https://web.stanford.edu/dept/itss/docs/oracle/10g/olap.101/b10333/multimodel.htm

*Author : Linda Wong*      
*Last Modified : 24 March 2016*
