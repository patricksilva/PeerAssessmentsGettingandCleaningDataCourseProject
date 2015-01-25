


## Stops execution if there is no Samsung data inside working directory.
if(!file.exists(".\\UCI HAR Dataset")){
        stop(paste("run_analysis.R can be run as long as the Samsung data is in
your working directory:",getwd(),sep=" " ))
}













