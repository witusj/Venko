library(leaflet)
location <- read.csv("data.csv")[1:5,]

location$Lat <- as.numeric(lapply(strsplit(as.character(location$Notitie.2), "\\,"), "[", 1))
location$Long <- as.numeric(lapply(strsplit(as.character(location$Notitie.2), "\\,"), "[", 2))

location$txt <- sapply(c(1:5), function(x) paste0(
                                                 paste0("<h4>",location$Notitie.1[x],"</h4>"),
                                                 paste0("Verbruik: ", location$Hoeveelheid[x]," ", location$Eenheid[x]),
                                                 "<br/>",
                                                 paste0(" = ", location$MT_CO2[x], " MT CO2")
                                                 )
                       ) # Volledige pop-up tekst


m <- leaflet(location) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircles(lng = ~Long,
             lat = ~Lat,
             weight = 2,
             radius = ~sqrt(as.numeric(MT_CO2))*3000,
             color = "Red",
             fillOpacity = 0.5,
             popup = ~txt
             )
m

