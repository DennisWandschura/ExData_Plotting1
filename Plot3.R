library(vroom)
library(lubridate)
library(dplyr)
#Date: Date in format dd/mm/yyyy
#Time: time in format hh:mm:ss
#Global_active_power: household global minute-averaged active power (in kilowatt)
#Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#Voltage: minute-averaged voltage (in volt)
#Global_intensity: household global minute-averaged current intensity (in ampere)
#Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

pathToData <- "./exdata_data_household_power_consumption/household_power_consumption.txt"
# dates for filtering data
filterDates <- c(ymd("2007-02-01"), ymd("2007-02-02"))

#define column types
csvCols <- cols(
  col_date(format = "%d/%m/%Y"),
  col_character(),
  col_double(), col_double(), col_double(), col_double(), col_double(), col_double(), col_double()
)

# 2007-02-01 and 2007-02-02
data <- vroom::vroom(pathToData, delim = ";", col_types = csvCols, na = c("?", "NA")) %>% 
  filter(Date == filterDates[1] | Date == filterDates[2]) %>%
  mutate(Time = hms(Time), DateTime = Date + Time)

# Construct the plot
plot(Sub_metering_1 ~ DateTime, data, type = "l", xlab = "", ylab = "Energy sub metering", xaxt = "n")
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")
axis(1, at = ymd_hms("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"), labels = c("Thu", "Fri", "Sat"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

# save it to a PNG file with a width of 480 pixels and a height of 480 pixels
dev.copy(png, file = "Plot3.png",width = 480, height = 480)
dev.off()