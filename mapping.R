# This script is the beginning of experiments for building a chloropleth
# map of the world - lots of learning going on, very little actual map-making yet

library(leaflet)
library(rgdal) #for reading/writing geo files
library(rgeos) #for simplification
library(sp)

zonedir<-"ne_10m_time_zones"

filename<-list.files(zonedir, pattern=".shp", full.names=FALSE)
filename<-gsub(".shp", "", filename)

# ----- Read in shapefile 
zones <-readOGR(zonedir, filename) 

# ----- save the data slot
zones_data<-zones@data[,c("name", "zone", "utc_format")]

# ----- simplification yields a SpatialPolygons class
zone_frame <-gSimplify(zones,tol=0.01, topologyPreserve=TRUE)




# noUTC <- d[d$OlsonTime != "UTC",]
# ggplot(noUTC, aes(round_date(noUTC$pTime, "hour"), fill=as.factor(Offset))) + 
#      geom_bar()

zonebins <- d %>% group_by(round_date(pTime, "hour"), name) %>%
     summarise(Count = n())
zonebins <- as.data.frame(zonebins)
zonebins[is.na(zonebins$Count), "Count"] <- 0
names(zonebins)[1] <- "tour_hour"
zonewide <- spread(zonebins,key = tour_hour, value = Count)

i <- 77
this_data <- zones_data #making a short term copy of the basic zone data
these_cols <- left_join(this_data,zonewide[,c(1,i)], by = "name") #add this col i
names(these_cols)[4] <- "Counts"
this_data <- cbind(this_data,these_cols$Counts) #strip off that column 
this_data$name <- as.factor(this_data$name) #factor it for colours
names(this_data)[4] <- "Counts" #and rename

# ----- to write to geojson we need a SpatialPolygonsDataFrame
# we're just building a quickie of of zone_frame and this_data

zone_show<-SpatialPolygonsDataFrame(zone_frame, data=this_data)

leaflet(zone_show) %>% 
     fitBounds(-180,60,180,-60) %>%
     addTiles() %>% 
     addPolygons(stroke = TRUE,weight = 1,
                 color = ~colorQuantile("YlOrRd", zone_show$Counts) (Counts))
