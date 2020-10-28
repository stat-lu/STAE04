## code to prepare `swe-cities` dataset goes here

library(tidyverse)
library(readxl)
library(rgdal)

tmp <- read_excel(
  "data-raw/mi0810_2018a01_tatorter2018_bef_arealer_200827.xlsx",
  skip = 10
)

# # convert coordinates to latitude, longitude
# sweref99tm <-
#   CRS("+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
# wgs84 <- CRS("+proj=longlat +datum=WGS84 +no_defs")
#
# coords_sweref <- cbind(tmp$`y-koordinat Sweref 99TM`, tmp$`x-koordinat  Sweref 99TM`)
#
# temp <- SpatialPoints(coords_sweref, proj4string = sweref99tm)
# coords <- spTransform(temp, wgs84)

tmp2 <-
  #as_tibble(coords) %>%
  #rename(lat = coords.x1, lon = coords.x2) %>%
  #bind_cols(tmp) %>%
  tmp %>%
  select(region_code = Länskod,
         region_name = Länsnamn,
         municipalty_code = Kommunkod,
         municipalty_name = Kommunnamn,
         city_code = Tätortskod,
         city_name = Tätortsbeteckning,
         population_2015 = "Folkmängd 2015-12-31",
         population_2018 = "Folkmängd 2018-12-31",
         populationdensity_2015 = "Befolknings-täthet 2015, antal invånare/km2",
         populationdensity_2018 = "Befolknings-täthet 2018, antal invånare/km2",
         x = "x-koordinat  Sweref 99TM",
         y = "y-koordinat Sweref 99TM") %>%
  pivot_longer(starts_with("population")) %>%
  separate(name, into = c("var", "year")) %>%
  pivot_wider(names_from = var, values_from = value) %>%
  rename(population_density = populationdensity) %>%
  mutate(year = as.integer(year))

write_csv(tmp2, "data/swe-cities.csv")

