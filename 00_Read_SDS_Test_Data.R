############################################################
#
#
# Einlesen der Testdaten aus dem R-Paket "sdsanalysis"
#
# test_data.csv
#
############################################################

require(here)

# Datei sysdata.rda laden und R-Skript "sdsdecode" ausführen:
load(here("SDSanalysis_R-Package/R/sysdata.rda"))
source(here("sdsdecode_edit.R"))

df <- read.csv(here("SDSanalysis_R-Package/data-raw/test_data/test_data.csv"))
#df <- read.csv(here("data-raw/SDS/Wolkenwehe_LA154/Bad_Oldesloe-Wolkenwehe_LA154_single.csv"))

head(df)
#View(df)
str(df)

df.deco <- lookup_everything(df)

str(df.deco)

head(df.deco)
#View(df.deco)