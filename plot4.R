#
# plot4.R
#

library(data.table) 
library(dplyr)      # enhanced data table and (scoped) pipeline with operator %>%
library(lubridate)  # just for simpler date handling

# Download the zip, extract the file, load the data 

# Download the zip file containing the source data
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# The local temp zip file
tempzipfile<-"household_power_consumption.zip"

# Extract the source datafile inside the downloaded zip file
datafile<-"household_power_consumption.txt"

if ( !file.exists(datafile) ) {
  download.file(url,tempzipfile, mode="wb")
  unzip(tempzipfile, datafile)
}

#Read and filter the table

if ( !exists("electric_power_consumption_df") ) {
  electric_power_consumption_df<-read.table(datafile, sep=";", header = TRUE, na.strings=c("?"))
  
  startDate<-ymd("2007-02-01")
  endDate<-ymd("2007-02-02")
  
  # For convenience convert to the dplyr table data.frame format
  electric_power_consumption_df<-tbl_df(electric_power_consumption_df) %>% 
    mutate(Date_dmy=dmy(Date))  %>% 
    filter(Date_dmy==startDate | Date_dmy ==endDate) %>%
    mutate(DateTime=Date_dmy+hms(Time))
}



#Plotting plot4: definitions
library(graphics)
plot4 <- function() {
  par(mfcol = c(2, 2))
  #par(bg = rgb(241/255,246/255, 251/255))
  with(electric_power_consumption_df, {
    plot(Global_active_power ~ DateTime, xlab = "", ylab = "Global Active Power", col = "black", type = "l")
    # 
    plot(Sub_metering_1 ~ DateTime, xlab = "", ylab = "Energy sub metering", type = "n")
    lines(Sub_metering_1 ~ DateTime, col = "black", type = "l")
    lines(Sub_metering_2 ~ DateTime, col = "red",   type = "l")
    lines(Sub_metering_3 ~ DateTime, col = "blue",  type = "l")
    legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3") ) #, pt.cex = 0.6)
    # 
    plot(Voltage ~ DateTime, xlab = "datetime", col = "black", type = "l")
    # 
    plot(Global_reactive_power ~ DateTime, xlab = "datetime", ylab = "Global_reactive_power", col = "black", type = "l")
    #     
  })
}

#Plotting plot4: actual plotting on each device
# The copying option commented out: png created from the window can have distortions
#windows()
plot4()
# dev.copy(png, file="plot4.png", width=480, height=480) # this approach can result in distortions ...
#dev.off()
png("plot4.png", width = 480, height = 480)
plot4()
dev.off()

