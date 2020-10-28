# remotes::install_github("reinholdsson/swemaps")

library(swemaps)
library(tidyverse)

tmp <-
  as_tibble(swemaps::map_kn) %>%
  select(region_code = lnkod,
         region_name = lnnamn,
         municipalty_code = knkod,
         municipalty_name = knnamn,
         group,
         lon = leaflet_long,
         lat = leaflet_lat) %>%
  mutate(region_code = str_trunc(region_code, 2, "left", ""))

write_csv(tmp, "data/swe-map.csv")
