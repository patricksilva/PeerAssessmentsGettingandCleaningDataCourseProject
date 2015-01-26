# PeerAssessmentsGettingandCleaningDataCourseProject

## How to run the script run_analysis.R
Where the script should be?
At the root of your working directory.

Where the data files should be?
At the root of your working directory.

## Codebook
The code book is a plain text written with Markdown sintax and
saved as .md. It must contain a list of all variables, a brief
description of each variable and all possible values and descriptions.

## Package requirements
"It is generally considered politer to explain what is needed
than include install.package commands."
Packages required: dplyr

## The algorithm
run_analysis.R was designed to make 6 main steps:

### Step 0: Load the data files

1. UCI HAR Dataset/test/X_test.txt
2. UCI HAR Dataset/test/y_test.txt
3. UCI HAR Dataset/train/X_train.txt
4. UCI HAR Dataset/train/y_train.txt
5. UCI HAR Dataset/test/subject_test.txt
6. UCI HAR Dataset/train/subject_train.txt
7. UCI HAR Dataset/activity_labels.txt
8. UCI HAR Dataset/features.txt

### Step 1: Bind files
Files 1 and 3 by row.
Files 2 and 4 by row.

### Step 2: Appropriately labels the data set with descriptive variable names
Apply a series of text parsing in order to clean and apply the feature names.

### Step 3: Creates the feature "Subject".

### Step 4: Merges and binds
Binds "Subject" feature to step 2.
Merges feature "Activity" data with activity labels and binds it to step 2.

### Step 5: Drop undesired features
Drops features V1a and V1s.

### Step 6: Group data
Groups the data by Subject and Activity.

### Step 7: Summaryzes and writes output file

