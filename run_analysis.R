
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
        stop(paste("run_analysis.R can be run as long as the Samsung data is in
your working directory:", getwd(), sep=" " ))
}



### Check dplyr version 
if(packageVersion("dplyr") != "") {
        stop("run_analysis.R requires dplyr greather than or equals to 0.3
Please, reinstall dplyr package")
} else { library(dplyr) }


getwd()
x_test <- read.table(".\\UCI HAR Dataset\test\\X_test.txt")

read.table(".\\HCI HAR Dataset\\test\\y_test.txt")


# It is generally considered "politer" to explain what is needed than include install.package commands.
