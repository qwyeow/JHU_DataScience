library(leaflet)
library(magrittr)

# url of dataset
setwd("~/Downloads")

#download data file from https://github.com/qwyeow/JHU_DataScience/blob/master/Leaflet_Map/star1.csv
url <- "https://raw.githubusercontent.com/qwyeow/JHU_DataScience/master/Leaflet_Map/star1.csv"
star1 <- read.csv(url,header =TRUE, sep = ",")

# Michelin Star Icon

Icon1 <- makeIcon(iconUrl = "https://upload.wikimedia.org/wikipedia/commons/5/5a/Etoile_Michelin-1.svg",
                  iconWidth = 31*215 /230 , iconHeight = 31,
                  iconAnchorX = 31*215 /230 /2, iconAnchorY = 16
)

# Convert features to dataframe

lat <- star1$lat
lng <- star1$lng
logo <- star1$logo
site <- star1$site
LatLong <- data.frame(lat = lat, lng = lng)

# Create leaflet map

my_map <- LatLong%>%leaflet() %>% 
        addTiles()%>% 
        addMarkers(icon = Icon1, 
                   popup = site, 
                   clusterOptions = markerClusterOptions())%>%
        addLegend(position = 'topright',
                  labels = "Last update 4 Nov 2016",
                  colors = "red", opacity = 0.2,
                  title = 'Michelin Star Restaurants in Singapore')

my_map
