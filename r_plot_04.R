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
 
# Open PNG Device and set up a 2x2 grid for 4 plots
 png("g_plot_04.png", width=480, height=480)
 par(mfrow=c(2,2))
 
# Create 1st plot - position 1,1
 plot(data$DateTime, data$Global_active_power, type="l", xlab="Weekday", ylab="Global Active Power")
 
# Create 2nd plot - position 1,2
 plot(data$DateTime, data$Voltage, type="l", xlab="Weekday", ylab="Voltage")
 
# Create 3rd plot - position 2,1
 plot(data$DateTime, data$Sub_metering_1, type="l", xlab="Weekday", ylab="Energy sub metering")
 lines(data$DateTime, data$Sub_metering_2, col=2)
 lines(data$DateTime, data$Sub_metering_3, col=4)
 legend("topright", bty="n", lty=1, col=c(1,2,4), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex=1)
 
# Create 4th plot - position 2,2
 plot(data$DateTime, data$Global_reactive_power, type="l", xlab="Weekday", ylab="Global Reactive Power")
 
# Close PNG Device
 dev.off()
 