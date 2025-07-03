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
load(here("source/sysdata.rda"))
source(here("sdsdecode_edit.R"))

df <- read.csv(here("data-raw/SDS/test_data.csv"))
#df <- read.csv(here("data-raw/SDS/Wolkenwehe_LA154/Bad_Oldesloe-Wolkenwehe_LA154_single.csv"))

head(df)
#View(df)
str(df)

df.deco <- lookup_everything(df)

str(df.deco)

head(df.deco)
#View(df.deco)