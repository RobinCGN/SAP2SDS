############################################################
#
# Test SAP to SDS converted data by using "lookup" function
# 
# from the SDSdecode R package
# 
#
# 
#
############################################################


# Datei sysdata.rda laden und R-Skript "sdsdecode" ausführen:
load(here::here("source/sysdata.rda"))
source(here::here("sdsdecode_edit.R"))


# Update SDSdecode Resources ----------------------------------------------

# Problem mit SDS Merkmal, look_up akzeptiert nur Eingabe von "0","98", "99"
attr_hash$anzahl_negative_mit_bulbus
names(data)[names(data) == "Negat_Bulbusnegat_Dorsal"] <- "FB2_54"
# Problem mit SDS Merkmal, look_up akzeptiert nur Eingabe von "0", "96", "97", "98", "99"
attr_hash$anzahl_negative_ohne_bulbus
names(data)[names(data) == "Negat_Dorsal"] <- "FB2_55"

# weitere Rohmaterialien hinzufügen
hash:::.set( attr_hash$rohmaterial, c("0506"), c("Rijckholt-Schotter") )
attr_hash$rohmaterial

# "Lookup" kann mit mehreren Modifikationseinträgen nicht umgehen

# "Loopkup" kennt keine IGerM 2
variables[37,]



# Test von sdsdecode ------------------------------------------------------

# Gesamtdatensatz
data.deco <- lookup_everything(data)

head(data.deco)

str(data.deco)

View(data.deco)
