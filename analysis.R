# Getting and Cleaning Accelerometer Data - 2016/02/07
# A.C.Dennerley
#==============================================================================
library(data.table)

# Start by decompressing and/or assigning filepaths
filepaths <-  if(!dir.exists("tmpdir")) {
                dir.create("tmpdir")
                unzip("getdata_projectfiles_UCI HAR Dataset.zip",
                exdir="tmpdir")
              } else {
                list.files("tmpdir", recursive=TRUE, full.names=TRUE)
}

# Create tables holding variable information such as variable names
activityLabels <- fread( grep("/activity_labels.txt$",filepaths,value=TRUE),
                         col.names = c("actID","activity") )
features       <- fread( grep("/features.txt$",filepaths,value=TRUE),
                         col.names = c("featIndex","feature") )

# Mark variable names that refer to mean or std
features[,target := grepl( "([^a-z0-9]|^)(std)([^a-z0-9]|$)|([^a-z0-9]|^)(mean)([^a-z0-9]|$)",
                           feature, ignore.case=TRUE ) ]
# Use generic variable names until the data table is refined
features[,genVar := ""]
for(i in features$featIndex) {
  features[featIndex==i,"genVar"] <- paste0("V",as.character(i))
}

# Load training set data
dat.train <- cbind( fread( grep("/subject_train.txt$",filepaths,value=TRUE),
                           col.names = "subject" ),
                    fread( grep("/y_train.txt$",filepaths,value=TRUE),
                           col.names = "actID" ),
                    fread( grep("/X_train.txt$",filepaths,value=TRUE),
                           drop = unique(features[target==FALSE,genVar]))
)
# Load testing set data
dat.test  <- cbind( fread( grep("/subject_test.txt$",filepaths,value=TRUE),
                           col.names = "subject" ),
                    fread( grep("/y_test.txt$",filepaths,value=TRUE),
                           col.names = "actID" ),
                    fread( grep("/X_test.txt$",filepaths,value=TRUE),
                           drop = unique(features[target==FALSE,genVar]))
)

# Merge the training and testing sets, replace numeric ID with descriptive ID
dat.clean <- merge( activityLabels, rbind( dat.train, dat.test ), by='actID' )
dat.clean[ , actID := NULL ]

# Clean variable names for referencing and replace the generic names
features[,featureName := gsub("(.*)(\\(\\))(.*)","\\1\\3",feature)]
varNames <- names(dat.clean)
for(i in 1:length(varNames)) {
  if(grepl("^[Vv][0-9]+$",varNames[i])) {
    varNames[i] <- features[genVar==varNames[i],featureName]
  }
}
setnames(dat.clean, names(dat.clean), varNames)

# Average data by 2 independent variables and measurement type
idVars <- varNames[1:2]
meVars <- varNames[3:length(varNames)]
dat.tidy <- melt( dat.clean, id.vars=idVars, measure.vars=meVars )
dat.tidy <- dcast( dat.tidy, subject + activity ~ variable, mean )

# Write tidied data to a csv file
file.create("tidy.csv")
write.csv(dat.tidy, file="tidy.csv")





