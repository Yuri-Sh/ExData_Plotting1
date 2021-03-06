#
# plot1.R
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



# Plotting plot1
library(graphics)
plot1<-function() {
  par(mfcol=c(1,1))
  #par(bg = rgb(241/255,246/255, 251/255))
  #par(cex.lab=0.8)
  with(electric_power_consumption_df, 
       hist(Global_active_power,xlab="Global Active Power (kilowatts)",ylab="Frequency",col="red",
            main="Global Active Power"))
}

#Plotting plot1: actual plotting on each device
# The copying option commented out: png created from the window can have distortions
#windows()
plot1()
#dev.copy(png, file="plot1.png", width=480, height=480)  # this approach can result in distortions ...
#dev.off()
png("plot1.png", width = 480, height = 480)
plot1()
dev.off()
