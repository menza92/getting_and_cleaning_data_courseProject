
#Code Book


##Smartphone Accelerometer & Gyroscope Data

data file: **tidy.csv**

This set presents mean and standard deviations of measurements associated with an accelerometer/gyroscope.  There are 30 independent test subjects who's activity (eg lying down, walking up stairs), with each measurement has been tracked.  The table is 180 rows by 68 columns, where 66 of the columns are dependent variables.

###Independent Variables

* __subject__: <int> Indicates which of 30 test subjects..

* __activity__: <factor> Indicates one of six possible activities of the subject; LAYING,SITTING,STANDING,WALKING,WALKING_DOWNSTAIRS, and WALKING_UPSTAIRS.

###Dependent Variables

't/f' prefix denotes translational measurement vs fast-Fourier-transformed frequency measurement.

'X/Y/Z' sufix denotes a cartesian direction for the measurements.

'Body/Gravity' specifies component of the signal.

'Acc/Gyro' distinguishes and accelerometer measurement from a gyroscope measurement.

'Jerk' specifies rate of change (ie rate of change in acceleration, nicknamed 'jerk' in relation to the experience of stopping in a car).

'Mag' absolute magnitude (modulus) of a measurement ie accMag = sqrt( accX^2 + accY^2 + accZ^2 ).

'mean' mean measurement.

'std' standard deviation

All dependent variables are numeric.

* tBodyAcc-mean-X

* tBodyAcc-mean-Y

* tBodyAcc-mean-Z

* tBodyAcc-std-X

* tBodyAcc-std-Y

* tBodyAcc-std-Z

* tGravityAcc-mean-X

* tGravityAcc-mean-Y

* tGravityAcc-mean-Z

* tGravityAcc-std-X

* tGravityAcc-std-Y

* tGravityAcc-std-Z

* tBodyAccJerk-mean-X

* tBodyAccJerk-mean-Y

* tBodyAccJerk-mean-Z

* tBodyAccJerk-std-X

* tBodyAccJerk-std-Y

* tBodyAccJerk-std-Z

* tBodyGyro-mean-X

* tBodyGyro-mean-Y

* tBodyGyro-mean-Z

* tBodyGyro-std-X

* tBodyGyro-std-Y

* tBodyGyro-std-Z

* tBodyGyroJerk-mean-X

* tBodyGyroJerk-mean-Y

* tBodyGyroJerk-mean-Z

* tBodyGyroJerk-std-X

* tBodyGyroJerk-std-Y

* tBodyGyroJerk-std-Z

* tBodyAccMag-mean

* tBodyAccMag-std

* tGravityAccMag-mean

* tGravityAccMag-std

* tBodyAccJerkMag-mean

* tBodyAccJerkMag-std

* tBodyGyroMag-mean

* tBodyGyroMag-std

* tBodyGyroJerkMag-mean

* tBodyGyroJerkMag-std

* fBodyAcc-mean-X

* fBodyAcc-mean-Y

* fBodyAcc-mean-Z

* fBodyAcc-std-X

* fBodyAcc-std-Y

* fBodyAcc-std-Z

* fBodyAccJerk-mean-X

* fBodyAccJerk-mean-Y

* fBodyAccJerk-mean-Z

* fBodyAccJerk-std-X

* fBodyAccJerk-std-Y

* fBodyAccJerk-std-Z

* fBodyGyro-mean-X

* fBodyGyro-mean-Y

* fBodyGyro-mean-Z

* fBodyGyro-std-X

* fBodyGyro-std-Y

* fBodyGyro-std-Z

* fBodyAccMag-mean

* fBodyAccMag-std

* fBodyBodyAccJerkMag-mean

* fBodyBodyAccJerkMag-std

* fBodyBodyGyroMag-mean

* fBodyBodyGyroMag-std

* fBodyBodyGyroJerkMag-mean

* fBodyBodyGyroJerkMag-std

