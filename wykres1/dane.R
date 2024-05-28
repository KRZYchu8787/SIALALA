library("readxl")
library(dplyr)
library(tidyr)
library(plotly)

dft <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/totalkilled.xlsx",na = ":")
dft <- as.data.frame(dft)
dft <- dft[-1,]
df1 <- dft %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
                names_to='year',
                values_to='total') 

df1 <- transform(df1,total = as.numeric(total))
  
df1 <- df1 %>% filter(TIME != "European Union - 27 countries (from 2020)")
########
dfp <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/passengerskilled.xlsx",na = ":")
dfp <- as.data.frame(dfp)
dfp <- dfp[-1,]
df2 <- dfp %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='passengers') 

df2 <- transform(df2,passengers = as.numeric(passengers))

df2 <- df2 %>% filter(TIME != "European Union - 27 countries (from 2020)")
###########
dfe <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/employeekilled.xlsx",na = ":")
dfe <- as.data.frame(dfe)
dfe <- dfe[-1,]
df3 <- dfe %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='employee') 

df3 <- transform(df3,employee = as.numeric(employee))

df3 <- df3 %>% filter(TIME != "European Union - 27 countries (from 2020)")
############
dfl <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/lvlcrossinguserskilled.xlsx",na = ":")
dfl <- as.data.frame(dfl)
dfl <- dfl[-1,]
df4 <- dfl %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='lvlcrossingusers') 

df4 <- transform(df4,lvlcrossingusers = as.numeric(lvlcrossingusers))

df4 <- df4 %>% filter(TIME != "European Union - 27 countries (from 2020)")
##############
dfa <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/unauthorisedkilled.xlsx",na = ":")
dfa <- as.data.frame(dfa)
dfa <- dfa[-1,]
df5 <- dfa %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='unauthorised') 

df5 <- transform(df5,unauthorised = as.numeric(unauthorised))

df5 <- df5 %>% filter(TIME != "European Union - 27 countries (from 2020)")
###################
dfu <- read_excel("C:/Users/Legion/Desktop/studia/sem4/ED/projekt2/unknownkilled.xlsx",na = ":")
dfu <- as.data.frame(dfu)
dfu <- dfu[-1,]
df6 <- dfu %>%
  pivot_longer(cols=c("2006","2007","2008","2009","2010",'2011', '2012',"2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
               names_to='year',
               values_to='unknown') 

df6 <- transform(df6,unknown = as.numeric(unknown))

df6 <- df6 %>% filter(TIME != "European Union - 27 countries (from 2020)")

t1 <-merge(df1,df2)
t2 <- merge(t1,df3)
t3 <- merge(t2,df4)
t4 <- merge(t3,df5)
t5 <- merge(t4,df6)
 
