# Getting and Cleaning Accelerometer/Gyroscope Data
A. C. Dennerley  
February 9, 2016  

Accelerometer/Gyroscope data collected for the Samsung Galaxy S smartphone can be used to help users spot patterns in their daily activity.  Before any modelling or prediction, it's important to prepare the data from the raw form to a tidy data set.  A tidy data set is complete and descriptive, containing any variable that are needed in the eventual regression or machine learning algorithms.  

This project is written for the Coursera 'Getting and Cleaning Data' (Jan 2016 offering) course project.  More information on the raw data is available <a href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">here</a>.  This is the <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">original zip file</a> source.


```
## Loading required package: data.table
```

The raw data is contained in a zip-file (supplied by Coursera) with this repository.  Uncompressing the data and retrieving a list of relevant file paths is the first step.  


```r
filepaths <- if(!dir.exists("tmpdir")) {
                dir.create("tmpdir")
                unzip("getdata_projectfiles_UCI HAR Dataset.zip",
                      exdir="tmpdir")
              } else {
                list.files("tmpdir", recursive=TRUE, full.names=TRUE)
}
```

There are five parts to this project:

1.  Merge the training and the test sets to create one data set

2.  Extract only measurements of mean and std for each measurement type.

3.  Use descriptive activity names to name the activities in the data set.

4.  Appropriately label the data set with descriptive variable names.

5.  From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

Starting with the generic information about labels and features/variables.


```r
activityLabels <- fread( grep("/activity_labels.txt$",filepaths,value=TRUE),
                         col.names = c("actID","activity") )

features       <- fread( grep("/features.txt$",filepaths,value=TRUE),
                         col.names = c("featIndex","feature") )
```

R's regular expressions functions are used to pull any feature name that involves mean or std.  Due to the volume of features that will be ignored, a generic variable 'V1','V2',etc.  Descriptive variable names will be added in after changes to data table dimensions.


```r
features[,target := grepl( "([^a-z0-9]|^)(std)([^a-z0-9]|$)|([^a-z0-9]|^)(mean)([^a-z0-9]|$)",
                           feature, ignore.case=TRUE ) ]

features[,genVar := ""]

for(i in features$featIndex) {
  features[featIndex==i,"genVar"] <- paste0("V",as.character(i))
}
```

Training data sets are combined.


```r
dat.train <- cbind( fread( grep("/subject_train.txt$",filepaths,value=TRUE),
                           col.names = "subject" ),
                    fread( grep("/y_train.txt$",filepaths,value=TRUE),
                           col.names = "actID" ),
                    fread( grep("/X_train.txt$",filepaths,value=TRUE),
                           drop = unique(features[target==FALSE,genVar]))
)

dim(dat.train)
```

```
## [1] 7352   68
```

Testing sets repeat the process.


```r
dat.test  <- cbind( fread( grep("/subject_test.txt$",filepaths,value=TRUE),
                           col.names = "subject" ),
                    fread( grep("/y_test.txt$",filepaths,value=TRUE),
                           col.names = "actID" ),
                    fread( grep("/X_test.txt$",filepaths,value=TRUE),
                           drop = unique(features[target==FALSE,genVar]))
)

dim(dat.test)
```

```
## [1] 2947   68
```

Sets are joined.  Descriptive activity is added.  'actID' is no longer necessary thus removed.


```r
dat.clean <- merge( activityLabels, rbind( dat.train, dat.test ), by='actID' )
dat.clean[ , actID := NULL ]
```

Next, the generic variable names should be replaced with more descriptive names.  The feature names ('features$feature') are good, but the parentheses need to go.


```r
features[,featureName := gsub("(.*)(\\(\\))(.*)","\\1\\3",feature)]
```

The column names are copied and changed from the generic name (where they occur) to a descriptive name.  The column names are then updated.


```r
varNames <- names(dat.clean)
for(i in 1:length(varNames)) {
  if(grepl("^[Vv][0-9]+$",varNames[i])) {
    varNames[i] <- features[genVar==varNames[i],featureName]
  }
}

setnames(dat.clean, names(dat.clean), varNames)
```

Lastly, is a simplified table with the average of each variable for each activity and subject.


```r
idVars <- varNames[1:2]
meVars <- varNames[3:length(varNames)]

dat.tidy <- melt( dat.clean, id.vars=idVars, measure.vars=meVars )
dat.tidy
```

```
##         activity subject                 variable      value
##      1:  WALKING       1          tBodyAcc-mean-X  0.2820216
##      2:  WALKING       1          tBodyAcc-mean-X  0.2558408
##      3:  WALKING       1          tBodyAcc-mean-X  0.2548672
##      4:  WALKING       1          tBodyAcc-mean-X  0.3433705
##      5:  WALKING       1          tBodyAcc-mean-X  0.2762397
##     ---                                                     
## 679730:   LAYING      24 fBodyBodyGyroJerkMag-std -0.9881846
## 679731:   LAYING      24 fBodyBodyGyroJerkMag-std -0.9884832
## 679732:   LAYING      24 fBodyBodyGyroJerkMag-std -0.9920103
## 679733:   LAYING      24 fBodyBodyGyroJerkMag-std -0.9921368
## 679734:   LAYING      24 fBodyBodyGyroJerkMag-std -0.9902872
```

It's easy to see that the next step will be to actually average for common id variables and measurement type.  'dcast()' from the 'data.table' package makes this very easy.


```r
dat.tidy <- dcast( dat.tidy, subject + activity ~ variable, mean )
```

A little dense to print out, but comparing dimensions with the 'dat.clean' table shows the change.


```r
dim(dat.clean)
```

```
## [1] 10299    68
```

```r
dim(dat.tidy)
```

```
## [1] 180  68
```

The end result is an averaged table where each combination of independent variables is a unique one.  Both smaller in volume and more meaningful.  To finish, the tidied data table is stored as a csv file.


```r
file.create("tidy.csv")
write.csv(dat.tidy, file="tidy.csv")
```

####Version info:

#####R 3.2.3

#####data.table_1.9.6
