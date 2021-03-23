library(tidyverse)
library(lubridate)
library(rworldmap)

covid <- read_csv(
 "https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv"
)

world <- map_data(getMap("coarse"))

# for some reason matching fails on antigua and barbuda
covid$country[grepl("^Antigua", covid$country)] <- "Antigua and Barbuda"

covid2 <-
  covid %>%
  as_tibble() %>%
  select(-source) %>%
  filter(!str_detect(country, "total"),
         !(country %in% c("Bonaire, Saint Eustatius and Saba"))) %>%
  mutate(
    country = recode(
      country,
      "Antigua and Barbuda" = "Antigua and Barb.",
      "Bosnia and Herzegovina" = "Bosnia and Herz.",
      "British Virgin Islands" = "British Virgin Is.",
      "Bosnia and Herz." = "Bosnia and Herzegovina",
      "Brunei Darussalam" = "Brunei",
      "Cabo Verde" = "Cape Verde",
      "Cayman Islands" = "Cayman Is.",
      "Central African Republic" = "Central African Rep.",
      "Czechia" = "Czech Rep.",
      "Congo" = "Congo (Brazzaville)",
      "Côte d’Ivoire" = "Ivory Coast",
      "Congo (Brazzaville)" = "Congo",
      "Curaçao" = "Curacao",
      "Democratic Republic of the Congo" = "Congo (Kinshasa)",
      "Dominican Republic" = "Dominican Rep.",
      "Eswatini" = "Swaziland",
      "Faroes" = "Faroe Is.",
      "Timor-Leste" = "East Timor" ,
      "Equatorial Guinea" = "Eq. Guinea",
      "Falkland Islands" = "Falkland Is.",
      "French Polynesia" = "Fr. Polynesia",
      "Guinea-Bissau" = "Guinea Bissau",
      "Ivory Coast" = "Côte d’Ivoire",
      "Marshall Islands" = "Marshall Is.",
      "Myanmar/Burma" = "Myanmar",
      "North Macedonia" = "Macedonia",
      "Northern Mariana Islands" = "N. Mariana Is.",
      "North Macedonia" = "N. Macedonia",
      "Palestine" = "Gaza",
      #"Palestine" = "West Bank",
      "South Korea" = "S. Korea",
      "South Sudan" = "S. Sudan",
      "United Republic of Tanzania" = "Tanzania",
      "US Virgin Islands" = "U.S. Virgin Is.",
      "United States of America" = "United States",
      "Western Sahara" = "W. Sahara",
      "Saint Kitts and Nevis" = "St. Kitts and Nevis",
      "Saint Vincent and the Grenadines" = "St. Vin. and Gren.",
      "São Tomé and Príncipe" = "Sao Tome and Principe",
      "Solomon Islands" = "Solomon Is.",
      "Turks and Caicos Islands" = "Turks and Caicos Is.",
      "The Gambia" = "Gambia",
      "the Holy See/ Vatican City State" = "Vatican"
    )
  )

# making sure that the names are matched up
a <- sort(unique(covid2$country))
b <- sort(unique(world$region))

a[is.na(match(a, b))]

#inner_join(world, covid2, by = c("region" = "country"))

write_csv(covid2, "data/covid.csv")
