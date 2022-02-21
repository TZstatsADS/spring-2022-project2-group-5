# Project 2: Shiny App Development
### Data folder

The Data directory contains the data files for the Shiny App (i.e., ui.R and server.R).
 - [homeless_tidy.csv](homeless_tidy.csv), [covid_tidy.csv](covid_tidy.csv), [homeless_covid.csv](homeless_covid.csv) and [shelters_tidy.csv](shelters_tidy.csv) are genereated using [API endpoint](http://dev.socrata.com/docs/endpoints.html) from [NYC Open Data By Agency](https://opendata.cityofnewyork.us/data/)
 - The whole website of above data set are from: [Associated Address by Borough and Community District](https://data.cityofnewyork.us/Social-Services/Associated-Address-by-Borough-and-Community-Distri/ur7y-ziyb), [COVID-19 Daily Counts of Cases, Hospitalizations, and Deaths](https://data.cityofnewyork.us/Health/COVID-19-Daily-Counts-of-Cases-Hospitalizations-an/rc75-m7u3) and [Directory Of Homeless Drop- In Centers](https://data.cityofnewyork.us/Social-Services/Directory-Of-Homeless-Drop-In-Centers/bmxf-3rd4)
 - The [shape files](nycd_21d/nycd.shp) are from [NYC Planning](https://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page).
 - All data set are processed by [data_processing.Rmd](../doc/data_processing.Rmd) and [process_data_for_statistics.R](../doc/process_data_for_statistics.R) files

