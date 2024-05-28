library("readxl")
library(dplyr)
library(tidyr)
library(plotly)

dft <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/wykres2/totallocomotive.xlsx",na = ":")
dft <- as.data.frame(dft)
dft <- dft[-1,]
df1 <- dft %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='total_locomotive') 

df1 <- transform(df1,total_locomotive = as.numeric(total_locomotive))

df1 <- df1 %>% filter(TIME != "European Union - 27 countries (from 2020)")
########
dfp <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/wykres2/diesellocomotive.xlsx",na = ":")
dfp <- as.data.frame(dfp)
dfp <- dfp[-1,]
df2 <- dfp %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='diesel_locomotive') 

df2 <- transform(df2,diesel_locomotive = as.numeric(diesel_locomotive))

df2 <- df2 %>% filter(TIME != "European Union - 27 countries (from 2020)")
###########
dfe <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/wykres2/electricitylocomotive.xlsx",na = ":")
dfe <- as.data.frame(dfe)
dfe <- dfe[-1,]
df3 <- dfe %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='electricity_locomotive') 

df3 <- transform(df3,electricity_locomotive = as.numeric(electricity_locomotive))

df3 <- df3 %>% filter(TIME != "European Union - 27 countries (from 2020)")
############
dfl <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/wykres2/totalrailcarxlsx.xlsx",na = ":")
dfl <- as.data.frame(dfl)
dfl <- dfl[-1,]
df4 <- dfl %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='total_carrail') 

df4 <- transform(df4,total_carrail = as.numeric(total_carrail))

df4 <- df4 %>% filter(TIME != "European Union - 27 countries (from 2020)")
##############
dfa <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/wykres2/dieselrailcarxlsx.xlsx",na = ":")
dfa <- as.data.frame(dfa)
dfa <- dfa[-1,]
df5 <- dfa %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='diesel_carrail') 

df5 <- transform(df5,diesel_carrail = as.numeric(diesel_carrail))

df5 <- df5 %>% filter(TIME != "European Union - 27 countries (from 2020)")
###################
dfu <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/wykres2/electricitycarrail.xlsx",na = ":")
dfu <- as.data.frame(dfu)
dfu <- dfu[-1,]
df6 <- dfu %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='electricity_carrail') 

df6 <- transform(df6,electricity_carrail = as.numeric(electricity_carrail))

df6 <- df6 %>% filter(TIME != "European Union - 27 countries (from 2020)")

t1 <-merge(df1,df2)
t2 <- merge(t1,df3)
t3 <- merge(t2,df4)
t4 <- merge(t3,df5)
t5 <- merge(t4,df6)

