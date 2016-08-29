#install.packages("RPostgreSQL")
#install.packages("jsonlite")

library(RPostgreSQL)
library(jsonlite)


pw <- {
  "masterkey"
}

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, dbname = "pc_test1",
                 host = "localhost", port = 5433,
                 user = "postgres", password = pw)
dbExistsTable(con, "points")


rows <- dbGetQuery(con, "SELECT id, PC_AsText(pt) as pt from points")

rows$points = c("")

for (i in 1:dim(rows)[1]) {
 rows$points[i] = list(fromJSON(rows$pt[i])$pt)
}

rows$points[[1]][1]
rows$points[[1]][2]


# Usando PC_Get
rows <- dbGetQuery(con, "SELECT id, PC_Get(pt, 'X') as x, PC_Get(pt, 'Y') as y, PC_Get(pt, 'Z') as z, PC_Get(pt, 'Intensity') as intensity from points")

