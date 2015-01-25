
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




