#
# plot2.R
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

#Plotting plot2
library(graphics)
plot2<-function() {
  #par(mfcol=c(1,1))
  par(bg = rgb(241/255,246/255, 251/255))
  with(electric_power_consumption_df, plot(Global_active_power~DateTime,ylab="Global Active Power (kilowatts)",col="black", type="l"))  
}

#Plotting plot2: actual plotting on each device
# The copying option commented out: png created from the window can have distortions
#windows()
plot2()
#dev.copy(png, file="plot2.png", width=480, height=480)
#dev.off()
png("plot2.png", width = 480, height = 480)
plot2()
dev.off()

