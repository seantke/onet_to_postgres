library(tidyverse)
library(readxl)
library(janitor)

con <- DBI::dbConnect(
  RPostgreSQL::PostgreSQL(),
  host= 'cscgikdcapweb02',
  dbname='onet',
  user = 'au',
  password = rstudioapi::askForPassword("Database Password")
)

wd <- 'C:/R/onet_to_postgres/src/'

files <- dir(wd)

files <- files[files != 'Read Me.txt']


readAndCopyFile <- function(file) {
  x <- read_xlsx(paste0(wd, file)) %>% clean_names()
  tablename <- str_replace_all(file, c('(.xlsx)'='','[:punct:]'='', '[:blank:]'=''))
  copy_to(con, x, tablename, temporary=FALSE)
  cat(tablename, 'is now a table on PostgreSQL')
  return(tablename)
}

success <- map_chr(files, readAndCopyFile)



