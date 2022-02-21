# data for statistics page
getwd()
source("../doc/helpers_server.R")
source("../doc/helpers_ui.R")
data<-read_csv('../data/data_for_statistics/Associated_Address_by_Borough_and_Community_District.csv')
# min(data$`Report Date`)

## merge covid case tibble and homeless_by_type tibble, prepare for visualization
covid<-read_csv('../data/data_for_statistics/COVID-19_Daily_Counts_of_Cases__Hospitalizations__and_Deaths.csv')
covid<-covid%>%mutate(date=mdy(DATE_OF_INTEREST))
homeless_by_type<-read_csv("../data/data_for_statistics/DHS_Daily_Report.csv")
homeless_by_type<-homeless_by_type%>%mutate(date=mdy(`Date of Census`))
# colnames(homeless_type)
#only select time after 01/31/2018
m<-right_join(covid,homeless_by_type,by="date")%>%
  arrange(date)%>%
  filter(date>mdy("01/31/2018"))
#colnames(m)
saveRDS(m, file = "../data/data_for_statistics/m.rds")


# check if 2 data sources (homeless_by_time and homeless by borough) could get the same result
# n<-inner_join(data_nyc,homeless_by_type,by=c("Report Date"="date"))              
#   ggplot(n,aes(x=`Report Date`,y=`Total Individuals in Shelter`,color="type"))+
#     geom_line()+
#     geom_line(aes(y =individuals_sum ,color="borough"))
# n%>%
#   select(`Report Date`,`Total Individuals in Shelter`,individuals_sum)

data_borough<-data%>%
  mutate(Borough=factor(Borough))%>%
  mutate(`Report Date`=mdy(`Report Date`))%>%
  group_by(Borough, `Report Date`)%>%
  summarize(cases_sum=sum(Cases), individuals_sum=sum(Individuals))%>%
  ungroup()

saveRDS(data_borough, file = "../data/data_for_statistics/data_borough.rds")

data_nyc<-data%>%
  mutate(Borough=factor(Borough))%>%
  mutate(`Report Date`=mdy(`Report Date`))%>%
  group_by(`Report Date`)%>%
  summarize(cases_sum=sum(Cases), individuals_sum=sum(Individuals))%>%
  ungroup()
saveRDS(data_nyc, file = "../data/data_for_statistics/data_nyc.rds")

most_recent_ind <- data_borough%>%
  ungroup()%>%
  filter(`Report Date`==max(`Report Date`))
saveRDS(most_recent_ind, file = "../data/data_for_statistics/most_recent_ind.rds")

borough_names<-as.character(unique(data_borough$Borough))
saveRDS(borough_names, file = "../data/data_for_statistics/borough_names.rds")

