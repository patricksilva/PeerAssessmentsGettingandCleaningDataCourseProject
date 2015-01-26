
noDataDirectory = FALSE

## Stops execution if there is no Samsung data inside working directory.
if("windows" == .Platform$OS.type)
{
        if(!file.exists(".\\UCI HAR Dataset")){ noDataDirectory = TRUE }
} else {
        if(!file.exists("./UCI HAR Dataset")){ noDataDirectory = TRUE }
}

if(noDataDirectory)
{
        stop(paste("run_analysis.R can be run as long as the Samsung data (UCI HAR Dataset) is in
the root of your working directory:", getwd(), sep=" " ))
}



### Check dplyr version 
if(as.numeric(substr(packageVersion("dplyr"),3,3)) < 3) {
        stop("run_analysis.R requires dplyr greather than or equals to 0.3
             Please, reinstall dplyr package")
} else { library(dplyr) }



# Step 0: loading data files

X_test          <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test          <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_train         <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train         <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test    <- read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
subject_train   <- read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
features        <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)



# Step 1: binding X_test.txt, X_train.txt, y_test.txt, y_train.txt
rbind_X <- rbind(X_train, X_test)
rm(X_train, X_test)

rbind_y <- rbind(y_train, y_test)
rm(y_train, y_test)



# Step 2: Appropriately labels the data set with descriptive variable names.
# steps necessary to reaname features.
# To use only features related to mean and standard deviation

bool_valid_features <- (grepl("mean",features$V2) | grepl("std",features$V2))
valid_features <- features[bool_valid_features, ]
valid_features$V2 <- str_trim( tolower(valid_features$V2) )
valid_features$V2 <- gsub("(body){2, }", "body", valid_features$V2)
valid_features$V2 <- gsub("-|\\(|\\)", "", valid_features$V2)
valid_features$V2 <- sub("acc","accelerometer", valid_features$V2)
valid_features$V2 <- sub("gyro", "gyroscope", valid_features$V2)
valid_features$V2 <- sub("^f","frequencydomainsignals", valid_features$V2)
valid_features$V2 <- sub("^t","timedomainsignals", valid_features$V2)

rm(features)

rbind_X_valid_features          <- rbind_X[ , bool_valid_features]
names(rbind_X_valid_features)   <- valid_features$V2

rm(rbind_X)



# Generates the valid features txt file. For conference means.
# write.table(valid_features$V2, file = "features_samsung.txt")



# Step 3: subject_test.txt, subject_train.txt

# 10299 1
cbind_train     <- cbind(subject_train , "train")
cbind_test      <- cbind(subject_test  , "test" )

names(cbind_train)      <- c("V1s","Subject")
names(cbind_test)       <- c("V1s","Subject")
rbind_subject <- rbind( cbind_train, cbind_test  )



# Step 4: merging subject_test and activity_labels
merge_activity <- merge(rbind_y, activity_labels, by.x = "V1", by.y = "V1")
names(merge_activity) <- c("V1a","Activity")

tidy_data2 <- cbind(rbind_X_valid_features, rbind_subject)
tidy_data1 <- cbind(tidy_data2, merge_activity)
tidy_data0 <- tbl_df(tidy_data1)

# Step 5: drop undesired features  
tidy_data <- dplyr::select(tidy_data0, -V1a, -V1s)


rm(tidy_data2)
rm(tidy_data1)
rm(tidy_data0)




# Step 6: group data
tidy_data_grouped <- dplyr::group_by(tidy_data, Subject, Activity)

# Step 7: Summaryze
dplyr::summarize(tidy_data_grouped,
                avg_timedomainsignalsbodyaccelerometermeanx = mean( timedomainsignalsbodyaccelerometermeanx ),
                avg_timedomainsignalsbodyaccelerometermeany = mean( timedomainsignalsbodyaccelerometermeany ),
                avg_timedomainsignalsbodyaccelerometermeanz = mean( timedomainsignalsbodyaccelerometermeanz ),
                avg_timedomainsignalsbodyaccelerometerstdx = mean( timedomainsignalsbodyaccelerometerstdx ),
                avg_timedomainsignalsbodyaccelerometerstdy = mean( timedomainsignalsbodyaccelerometerstdy ),
                avg_timedomainsignalsbodyaccelerometerstdz = mean( timedomainsignalsbodyaccelerometerstdz ),
                avg_timedomainsignalsgravityaccelerometermeanx = mean( timedomainsignalsgravityaccelerometermeanx ),
                avg_timedomainsignalsgravityaccelerometermeany = mean( timedomainsignalsgravityaccelerometermeany ),
                avg_timedomainsignalsgravityaccelerometermeanz = mean( timedomainsignalsgravityaccelerometermeanz ),
                avg_timedomainsignalsgravityaccelerometerstdx = mean( timedomainsignalsgravityaccelerometerstdx ),
                avg_timedomainsignalsgravityaccelerometerstdy = mean( timedomainsignalsgravityaccelerometerstdy ),
                avg_timedomainsignalsgravityaccelerometerstdz = mean( timedomainsignalsgravityaccelerometerstdz ),
                avg_timedomainsignalsbodyaccelerometerjerkmeanx = mean( timedomainsignalsbodyaccelerometerjerkmeanx ),
                avg_timedomainsignalsbodyaccelerometerjerkmeany = mean( timedomainsignalsbodyaccelerometerjerkmeany ),
                avg_timedomainsignalsbodyaccelerometerjerkmeanz = mean( timedomainsignalsbodyaccelerometerjerkmeanz ),
                avg_timedomainsignalsbodyaccelerometerjerkstdx = mean( timedomainsignalsbodyaccelerometerjerkstdx ),
                avg_timedomainsignalsbodyaccelerometerjerkstdy = mean( timedomainsignalsbodyaccelerometerjerkstdy ),
                avg_timedomainsignalsbodyaccelerometerjerkstdz = mean( timedomainsignalsbodyaccelerometerjerkstdz ),
                avg_timedomainsignalsbodygyroscopemeanx = mean( timedomainsignalsbodygyroscopemeanx ),
                avg_timedomainsignalsbodygyroscopemeany = mean( timedomainsignalsbodygyroscopemeany ),
                avg_timedomainsignalsbodygyroscopemeanz = mean( timedomainsignalsbodygyroscopemeanz ),
                avg_timedomainsignalsbodygyroscopestdx = mean( timedomainsignalsbodygyroscopestdx ),
                avg_timedomainsignalsbodygyroscopestdy = mean( timedomainsignalsbodygyroscopestdy ),
                avg_timedomainsignalsbodygyroscopestdz = mean( timedomainsignalsbodygyroscopestdz ),
                avg_timedomainsignalsbodygyroscopejerkmeanx = mean( timedomainsignalsbodygyroscopejerkmeanx ),
                avg_timedomainsignalsbodygyroscopejerkmeany = mean( timedomainsignalsbodygyroscopejerkmeany ),
                avg_timedomainsignalsbodygyroscopejerkmeanz = mean( timedomainsignalsbodygyroscopejerkmeanz ),
                avg_timedomainsignalsbodygyroscopejerkstdx = mean( timedomainsignalsbodygyroscopejerkstdx ),
                avg_timedomainsignalsbodygyroscopejerkstdy = mean( timedomainsignalsbodygyroscopejerkstdy ),
                avg_timedomainsignalsbodygyroscopejerkstdz = mean( timedomainsignalsbodygyroscopejerkstdz ),
                avg_timedomainsignalsbodyaccelerometermagmean = mean( timedomainsignalsbodyaccelerometermagmean ),
                avg_timedomainsignalsbodyaccelerometermagstd = mean( timedomainsignalsbodyaccelerometermagstd ),
                avg_timedomainsignalsgravityaccelerometermagmean = mean( timedomainsignalsgravityaccelerometermagmean ),
                avg_timedomainsignalsgravityaccelerometermagstd = mean( timedomainsignalsgravityaccelerometermagstd ),
                avg_timedomainsignalsbodyaccelerometerjerkmagmean = mean( timedomainsignalsbodyaccelerometerjerkmagmean ),
                avg_timedomainsignalsbodyaccelerometerjerkmagstd = mean( timedomainsignalsbodyaccelerometerjerkmagstd ),
                avg_timedomainsignalsbodygyroscopemagmean = mean( timedomainsignalsbodygyroscopemagmean ),
                avg_timedomainsignalsbodygyroscopemagstd = mean( timedomainsignalsbodygyroscopemagstd ),
                avg_timedomainsignalsbodygyroscopejerkmagmean = mean( timedomainsignalsbodygyroscopejerkmagmean ),
                avg_timedomainsignalsbodygyroscopejerkmagstd = mean( timedomainsignalsbodygyroscopejerkmagstd ),
                avg_frequencydomainsignalsbodyaccelerometermeanx = mean( frequencydomainsignalsbodyaccelerometermeanx ),
                avg_frequencydomainsignalsbodyaccelerometermeany = mean( frequencydomainsignalsbodyaccelerometermeany ),
                avg_frequencydomainsignalsbodyaccelerometermeanz = mean( frequencydomainsignalsbodyaccelerometermeanz ),
                avg_frequencydomainsignalsbodyaccelerometerstdx = mean( frequencydomainsignalsbodyaccelerometerstdx ),
                avg_frequencydomainsignalsbodyaccelerometerstdy = mean( frequencydomainsignalsbodyaccelerometerstdy ),
                avg_frequencydomainsignalsbodyaccelerometerstdz = mean( frequencydomainsignalsbodyaccelerometerstdz ),
                avg_frequencydomainsignalsbodyaccelerometermeanfreqx = mean( frequencydomainsignalsbodyaccelerometermeanfreqx ),
                avg_frequencydomainsignalsbodyaccelerometermeanfreqy = mean( frequencydomainsignalsbodyaccelerometermeanfreqy ),
                avg_frequencydomainsignalsbodyaccelerometermeanfreqz = mean( frequencydomainsignalsbodyaccelerometermeanfreqz ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmeanx = mean( frequencydomainsignalsbodyaccelerometerjerkmeanx ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmeany = mean( frequencydomainsignalsbodyaccelerometerjerkmeany ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmeanz = mean( frequencydomainsignalsbodyaccelerometerjerkmeanz ),
                avg_frequencydomainsignalsbodyaccelerometerjerkstdx = mean( frequencydomainsignalsbodyaccelerometerjerkstdx ),
                avg_frequencydomainsignalsbodyaccelerometerjerkstdy = mean( frequencydomainsignalsbodyaccelerometerjerkstdy ),
                avg_frequencydomainsignalsbodyaccelerometerjerkstdz = mean( frequencydomainsignalsbodyaccelerometerjerkstdz ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmeanfreqx = mean( frequencydomainsignalsbodyaccelerometerjerkmeanfreqx ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmeanfreqy = mean( frequencydomainsignalsbodyaccelerometerjerkmeanfreqy ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmeanfreqz = mean( frequencydomainsignalsbodyaccelerometerjerkmeanfreqz ),
                avg_frequencydomainsignalsbodygyroscopemeanx = mean( frequencydomainsignalsbodygyroscopemeanx ),
                avg_frequencydomainsignalsbodygyroscopemeany = mean( frequencydomainsignalsbodygyroscopemeany ),
                avg_frequencydomainsignalsbodygyroscopemeanz = mean( frequencydomainsignalsbodygyroscopemeanz ),
                avg_frequencydomainsignalsbodygyroscopestdx = mean( frequencydomainsignalsbodygyroscopestdx ),
                avg_frequencydomainsignalsbodygyroscopestdy = mean( frequencydomainsignalsbodygyroscopestdy ),
                avg_frequencydomainsignalsbodygyroscopestdz = mean( frequencydomainsignalsbodygyroscopestdz ),
                avg_frequencydomainsignalsbodygyroscopemeanfreqx = mean( frequencydomainsignalsbodygyroscopemeanfreqx ),
                avg_frequencydomainsignalsbodygyroscopemeanfreqy = mean( frequencydomainsignalsbodygyroscopemeanfreqy ),
                avg_frequencydomainsignalsbodygyroscopemeanfreqz = mean( frequencydomainsignalsbodygyroscopemeanfreqz ),
                avg_frequencydomainsignalsbodyaccelerometermagmean = mean( frequencydomainsignalsbodyaccelerometermagmean ),
                avg_frequencydomainsignalsbodyaccelerometermagstd = mean( frequencydomainsignalsbodyaccelerometermagstd ),
                avg_frequencydomainsignalsbodyaccelerometermagmeanfreq = mean( frequencydomainsignalsbodyaccelerometermagmeanfreq ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmagmean = mean( frequencydomainsignalsbodyaccelerometerjerkmagmean ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmagstd = mean( frequencydomainsignalsbodyaccelerometerjerkmagstd ),
                avg_frequencydomainsignalsbodyaccelerometerjerkmagmeanfreq = mean( frequencydomainsignalsbodyaccelerometerjerkmagmeanfreq ),
                avg_frequencydomainsignalsbodygyroscopemagmean = mean( frequencydomainsignalsbodygyroscopemagmean ),
                avg_frequencydomainsignalsbodygyroscopemagstd = mean( frequencydomainsignalsbodygyroscopemagstd ),
                avg_frequencydomainsignalsbodygyroscopemagmeanfreq = mean( frequencydomainsignalsbodygyroscopemagmeanfreq ),
                avg_frequencydomainsignalsbodygyroscopejerkmagmean = mean( frequencydomainsignalsbodygyroscopejerkmagmean ),
                avg_frequencydomainsignalsbodygyroscopejerkmagstd = mean( frequencydomainsignalsbodygyroscopejerkmagstd ),
                avg_frequencydomainsignalsbodygyroscopejerkmagmeanfreq = mean( frequencydomainsignalsbodygyroscopejerkmagmeanfreq )
) %>%
write.table( file = "tidy_data.txt", row.name=FALSE )












