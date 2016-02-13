library(jsonlite)
library(lubridate)
library(dplyr)
library(tidyr)
library(knitr)
library(ggplot2)
library(car)
library(xts)

.pardefault <- par()

#data-obtaining, given manual file munging
#highest ID: 3179574

#load our reference tables
tzones <- read.csv("timezones.csv", stringsAsFactors = FALSE)
names(tzones) <- c("TimeZoneId", "OlsonTime", "Offset","Order")
stages <- read.csv("stagemap.csv",stringsAsFactors = FALSE)
meters <- read.csv("powersources.csv", stringsAsFactors = FALSE)

setwd("~/datacourse/small projects/tour_data")
filepath <- "lists-of-rides/"

d <- NULL

file.names <- dir(filepath, pattern = ".json")
#start to build the file
file <- fromJSON(paste(filepath,file.names[1],sep = ''))
file <- file$Rides[,1:21]
d <- file
#add on new records
for (i in 2:length(file.names)) {
     file <- fromJSON(paste(filepath,file.names[i],sep = ''))
     rides <- file$Rides[,1:21]
     d <- rbind(d, rides)
}

#clean out duplicates and sort
d <- d %>% distinct() %>% arrange(desc(Id))
d <- left_join(d,tzones,by = "TimeZoneId")

#sort out the time zones - that loop is ugly but will do for now
d$pTime <- ymd_hms(d$WorkoutDate)

for (i in c(1:nrow(d))) {
     d[i,"pTime"] <- ymd_hms(d[i,"WorkoutDate"], tz = d[i,"OlsonTime"])
}

#drop the early starts
d <- filter(d, d$pTime >= ymd_hms("2016-02-04 10:00:00", tz = "UTC"))

#map in the stages
d <- left_join(d, stages, by="WorkoutName")

#drop the Not ToS stuff
d <- filter(d, substring(Stage,1,5) == "Stage")

#go get the trainers
d <- left_join(d, meters, by = "PowerSource")

#compile rider performance
d$RiderTSSRatio <- d$TSS/d$WorkoutTSS
d$RiderIFRatio <- d$IntensityFactor/d$WorkoutIF

#rider summary table
riders <- d %>% 
     group_by(MemberId) %>%
     summarize("Workouts"=n(), 
               "FTP" = median(Ftp),
               "Stages Ridden"= n_distinct(Stage),
               "PowerSourceType"=first(SourceType),
               "LTHR" = median(Lthr)
     )

#hourly summary table
hourly <- d %>%
     group_by(Stage, "Time"=round_date(pTime, unit = "hour")) %>%
     summarise("HourCount"=n()) %>%
     mutate("Cumulative"=cumsum(HourCount)) %>%
     arrange(Time)

hourly <- as.data.frame(hourly)

# build cumulative and spot hourly stage counts
yCums <- spread(hourly[,c(1,2,4)], Stage, Cumulative)
for(i in c(2:10)) {
     j <- 1
     while(is.na(yCums[j,i])) {
          yCums[j,i] <- 0
          j <- j+1
     }
}
for(i in c(2:10)) {yCums[,i] <- na.locf(yCums[,i], na.rm = FALSE)}

yCumsLong <- gather(yCums,"Stage", "Count", 2:10)


yCounts <- spread(hourly[,c(1,2,3)], Stage, HourCount)
for(i in c(2:10)) {
     j <- 1
     while(is.na(yCounts[j,i])) {
          yCounts[j,i] <- 0
          j <- j+1
     }
     j <- nrow(yCounts)
     while(is.na(yCounts[j,i])) {
          yCounts[j,i] <- 0
          j <- j-1
     }
}
for(i in c(2:10)) {yCounts[,i] <- na.locf(yCounts[,i], na.rm = FALSE)}

yCountsLong <- gather(yCounts,"Stage", "Count", 2:10)

for(i in c(2:10)) {
     lo <- loess(as.formula(paste("yCounts$`",names(yCounts)[i],"`","~ as.numeric(Time)", sep="")), 
                 data = yCounts, span = 0.25)
     yCounts[,i+9] <- predict(lo)
     names(yCounts)[i+9] <- paste("Smooth",i-1)
}

yCountsSmooth <- select(yCounts, Time, starts_with("Smooth"))
names(yCountsSmooth) <- gsub("Smooth", "Stage", names(yCountsSmooth))
yCountsSmoothLong <- gather(yCountsSmooth, "Stage", "Count", 2:10)
yCountsSmoothLong[yCountsSmoothLong$Count < 0, "Count"] <- 0



