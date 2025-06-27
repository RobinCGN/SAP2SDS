############################################################
#
#
# Einlesen Arnoldsweiler-Daten als CSV
#
# 
#
############################################################

# Datei sysdata.rda laden und R-Skript "sdsdecode" ausführen:
load("L:/00_Peters/Projekte, Publikationen/Projekte/2025_SDS/SDSanalysis_R-Package/R/sysdata.rda")
source("L:/00_Peters/Projekte, Publikationen/Projekte/2025_SDS/sdsdecode_edit.R")

data <- read.csv("L:/00_Peters/Projekte, Publikationen/Projekte/2025_SDS/SAP_Arnoldsweiler_Lithics_CSV/RA_85_dig_Anhang_126_Formblatt_01_Silex.csv", sep=";",dec = ",", encoding="latin1")

head(data)
str(data)


# Variabel-Namen umbennen -------------------------------------------------

names(data)[names(data) == "Siedlungsnr"] <- "FBG_1"
names(data)[names(data) == "Stelle"] <- "FBG_3"
names(data)[names(data) == "Positionsnr"] <- "FBG_4"
names(data)[names(data) == "Individualnr"] <- "FBG_5"
names(data)[names(data) == "Formblattnr"] <- "FBG_6"

# Rohmaterial?
#names(data)[names(data) == "Rohmat1"] <- "FB1_16" 

# Rohmaterialfarbe?
names(data)[names(data) == "Rohmat_Farbe"] <- "FB1_17" 

names(data)[names(data) == "Rinde"] <- "FB1_20"
names(data)[names(data) == "Nat_Fl"] <- "FB1_21"
names(data)[names(data) == "Nat_Fl_Abroll"] <- "FB1_22"

names(data)[names(data) == "Therm_Art"] <- "FB1_24"
names(data)[names(data) == "Therm_Zeit"] <- "FB1_25"

names(data)[names(data) == "Erhaltung_Rechteck"] <- "FB1_26"
names(data)[names(data) == "Länge"] <- "FB1_27"
names(data)[names(data) == "Breite"] <- "FB1_28"
names(data)[names(data) == "Dicke"] <- "FB1_29"
names(data)[names(data) == "Gewicht"] <- "FB1_30"

names(data)[names(data) == "Mod_Erhaltung"] <- "FB1_32"

names(data)[names(data) == "Grundform"] <- "FB1_33"
names(data)[names(data) == "Erhaltung_Schlagr"] <- "FB2_35"
names(data)[names(data) == "Schlagr_Verlauf"] <- "FB2_38"
names(data)[names(data) == "Schlagflrest_Länge"] <- "FB2_45"
names(data)[names(data) == "Schlagflrest_Breite"] <- "FB2_46"
names(data)[names(data) == "Schlagflrest_Erhaltung"] <- "FB2_44"
names(data)[names(data) == "Schlagflrest_Schlagaugen"] <- "FB2_52"
#names(data)[names(data) == "Negat_Bulbusnegat_Dorsal"] <- "FB2_54"
#names(data)[names(data) == "Negat_Dorsal"] <- "FB2_55"
names(data)[names(data) == "Präpgrat_Verlauf"] <- "FB2_57"
names(data)[names(data) == "Dorsalflneg_Abbaur"] <- "FB2_58"
names(data)[names(data) == "Mod_Art_1"] <- "FB2_59"      
names(data)[names(data) == "igerm1"] <- "IGerM" 


# SAP ? - Rohmaterial -----------------------------------------------------

#  zwei Spalten zu einer zusammenführen:
#paste(sprintf("%02d", data$Rohmat1),sprintf("%02d", data$Rohmat2), sep="")
#data <- cbind(data, FB1_16 = sprintf("%02d", data$Rohmat1))
data <- cbind(data, FB1_16 = paste(sprintf("%02d", data$Rohmat1),sprintf("%02d", data$Rohmat2), sep=""))
data$FB1_16 <- gsub("NA", "", data$FB1_16)

# variable_values editieren
#variable_values[variable_values$variable_id=="FB1_16",]
#variable_values <- rbind(variable_values, c("FB1_16","16",1,"0506","normal","Rijckholt-Schotter","","","",""))

hash:::.set( attr_hash$rohmaterial, c("0506"), c("Rijckholt-Schotter") )
attr_hash$rohmaterial


# SAP 14 - Therm_Zeit -----------------------------------------------------

#  Umkodieren, "NA" zu "7"
data$FB1_25[data$FB1_25%in%c("",NA)] <- 7


# SAP 20 - Erhaltung d. modifz. Stücks  -----------------------------------

#  Umkodieren, "NA" zu "5"
data$FB1_32[data$FB1_32%in%c("",NA)] <- 5


# SAP 33 - Grundform  -----------------------------------------------------

# Umkodieren, "3" zu "5"
data$FB1_33[data$FB2_33==3] <- 5
data$FB1_33[data$FB2_33==4] <- 3
data$FB1_33[data$FB2_33==5] <- 3
data$FB1_33[data$FB2_33==6] <- 4
data$FB1_33[data$FB2_33==8] <- 5
data$FB1_33[data$FB2_33==9] <- 5
data$FB1_33[data$FB2_33==7] <- 9


# SAP 28 - Schlagaugen auf dem Schlagflächenrest  -------------------------

# Umkodieren
data$FB2_52[data$FB2_52==0] <- 1
data$FB2_52[data$FB2_52==1] <- 4
data$FB2_52[data$FB2_52==2] <- 0
data$FB2_52[data$FB2_52==3] <- 9


# SAP 30 - Negative auf Dorsalseite und dem SFR > 2cm mit Bulbusnegativ  --

# Umkodieren
#data$FB2_54[is.na(data$FB2_54)] <- 98
# Funktioniert nicht lookup_everthing erzeugt 479 NAs


# SAP 36 - Abbaurichtung der Dorsalflächennegative  -----------------------

# Umkodieren
data$FB2_58[data$FB2_52==8] <- 9




# Test von sdsdecode ------------------------------------------------------

# Gesamtdatensatz
data.deco <- lookup_everything(data)

str(data.deco)

head(data.deco)




# Export ------------------------------------------------------------------

#write.csv


