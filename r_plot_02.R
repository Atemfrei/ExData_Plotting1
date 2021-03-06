###
### PREAMBLE 
###

# Clear Environment
rm(list=ls(all=TRUE)) 
graphics.off()

# Set Working Directory
WD <- dirname(sys.frame(1)$ofile)
setwd (WD)

# Load packages
library(data.table)
library(dplyr)

###  
### DATA HANDLING 
###

# Create and save a smaller subset of data in order to save computation time. 
 if(!file.exists("data\\hpc_subset.csv")){
        # read data with fread() function from data.table package
        data <- fread("data/household_power_consumption.txt", na.strings="?", colClasses=c("date"))
        
        # create new DateTime variable and select data from dates 2007-02-01 and 2007-02-02
        data[,DateTime := as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")]
        data.subset <- filter(data, DateTime>=as.POSIXct("2007-02-01 00:00:00"), DateTime<as.POSIXct("2007-02-03 00:00:00"))
        
        # Reorder variables, delete the the original Date and Time variables and write new data file
        data.subset <- data.subset[, c(10,3:9)]
        write.table(data.subset, file="data/hpc_subset.csv", sep=",", row.name=F, col.names=T)
        
        # Clean workspace to save memory
        remove(data, data.subset)
 }

# Read smaller subset of data and format DateTime variable to POSIXlt class
 data           <- read.csv("data/hpc_subset.csv", header=T)
 data$DateTime  <- as.POSIXlt(data$DateTime)
 
###
### GRAPHICS
###
 
# Open PNG device
 png("g_plot_02.png", width=480, height=480)

# Create plot with a line instead of points
 plot(data$DateTime, data$Global_active_power, type="l", xlab="Weekday", ylab="Global Active Power (kilowatts)")

# Close PNG device
 dev.off()
 