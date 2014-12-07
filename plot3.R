#
# plot3.R
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
  electric_power_consumption_raw<-read.table(datafile, sep=";", header = TRUE, na.strings=c("?"))
  
  startDate<-ymd("2007-02-01")
  endDate<-ymd("2007-02-02")
  
  # For convenience convert to the dplyr table data.frame format
  electric_power_consumption_df<-tbl_df(electric_power_consumption_raw) %>% 
    mutate(Date_dmy=dmy(Date))  %>% 
    filter(Date_dmy==startDate | Date_dmy ==endDate) %>%
    mutate(DateTime=Date_dmy+hms(Time))
  rm("electric_power_consumption_raw")
}

#Plotting plot3: definition
plot3<-function() {
  par(mfcol=c(1,1))
  par(bg = rgb(241/255,246/255, 251/255))
  with(electric_power_consumption_df,  {
    plot(Sub_metering_1~DateTime,xlab="", ylab="Energy sub metering", type="n")
    lines(Sub_metering_1~DateTime,ylab="Energy sub metering",col="black", type="l")
    lines(Sub_metering_2~DateTime,ylab="Energy sub metering",col="red",   type="l")
    lines(Sub_metering_3~DateTime,ylab="Energy sub metering",col="blue",  type="l")
    legend("topright", lty=1, col=c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
  })
}

#Plotting plot3: actual plotting on each device
library(graphics)
windows()
plot3()
# dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()
png("plot3.png", width = 480, height = 480)
plot3()
dev.off()
