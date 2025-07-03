############################################################
#
# Konvertieren von SAP-Daten im CSV-Format zu SDS
#
#
# Arnoldsweiler-Daten als Testdaten
#
# 
#
############################################################


# To-Do
# - Kernmerkmale ergänzen (dafür Test-Daten erweitern)


# Probleme
# - Rohmaterial
# - Mod_Reihe
# - Mod-Art

require(here)

# Data --------------------------------------------------------------------


#data <- read.csv(here("data-raw/SAP_CSV/RA_85_dig_Anhang_126_Formblatt_01_Silex.csv"), sep=";",dec = ",", encoding="latin1")
#data <- read.csv(here("data-raw/SAP_CSV/RA_85_dig_Anhang_124_Formblatt_01_Kern.csv"), sep=";",dec = ",", encoding="latin1")
data <- LW8



head(data)
str(data)

data.export.name <- "AE_lithics_SDS-format.csv"


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

names(data)[names(data) == "Oberfl_art_Spaltfl"] <- "FB1_18" 

names(data)[names(data) == "Strukturen_Material"] <- "FB1_19" 

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
names(data)[names(data) == "Schlagflrest_Art"] <- "FB2_42"
names(data)[names(data) == "Schlagflrest_Schlagaugen"] <- "FB2_52"

# Problem mit SDS Merkmal, look_up akzeptiert nur Eingabe von "0","98", "99"
names(data)[names(data) == "Negat_Bulbusnegat_Dorsal"] <- "FB2_54"
# Problem mit SDS Merkmal, look_up akzeptiert nur Eingabe von "0", "96", "97", "98", "99"
names(data)[names(data) == "Negat_Dorsal"] <- "FB2_55"


names(data)[names(data) == "Dorsalflpräp"] <- "FB2_56"
names(data)[names(data) == "Präpgrat_Verlauf"] <- "FB2_57"
names(data)[names(data) == "Distal_Zustand"] <- "FB2_53"
names(data)[names(data) == "Rinde_natSprungfl"] <- "FB1_23"
names(data)[names(data) == "Dorsalflneg_Abbaur"] <- "FB2_58"
names(data)[names(data) == "igerm1"] <- "IGerM" 

names(data)[names(data) == "KernNeg_Ab_Bulbus"] <- "FB2_63" 
names(data)[names(data) == "KernNeg_Ab"] <- "FB2_64"
names(data)[names(data) == "KernNeg_Kl_Bulbus"] <- "FB2_65" 
names(data)[names(data) == "KernNeg_Kl"] <- "FB2_66"

names(data)[names(data) == "Narben_Lage"] <- "FB2_68"
names(data)[names(data) == "Narben_Orient"] <- "FB2_69"
names(data)[names(data) == "Kern_Schlagfl"] <- "FB2_70"

names(data)[names(data) == "Kern_Abbaufl"] <- "FB2_72"
names(data)[names(data) == "Kern_Abbauricht"] <- "FB2_73"

names(data)[names(data) == "Kern_SchlagflLänge"] <- "FB2_74"
names(data)[names(data) == "Kern_SchlagflBreite"] <- "FB2_75"

names(data)[names(data) == "Klopfspur_Lage"] <- "FB2_67"

# Convert all Factors to Characte Variables
data[sapply(data, is.factor)] <- lapply(data[sapply(data, is.factor)], as.character)

# Delete empty spaces from Variables
data$FBG_1 <- gsub(" ", "", data$FBG_1)
data$FBG_3 <- gsub(" ", "", data$FBG_3)
data$FBG_4 <- gsub(" ", "", data$FBG_4)
data$FBG_5 <- gsub(" ", "", data$FBG_5)
data$FBG_6 <- gsub(" ", "", data$FBG_6)
data$FB1_17 <- gsub(" ", "", data$FB1_17)

# Delete additional columns
if (is.null(data$name)==FALSE) {
  data$name <- NULL}


# SAP 9 - Strukturen im Material  -----------------------------------------------------


#  Umkodieren
data$FB1_19[data$FB1_19%in%c(1)] <- 11
data$FB1_19[data$FB1_19%in%c(2)] <- 12
data$FB1_19[data$FB1_19%in%c(3)] <- 13
data$FB1_19[data$FB1_19%in%c(4)] <- 14
data$FB1_19[data$FB1_19%in%c(5)] <- 15
data$FB1_19[data$FB1_19%in%c(6)] <- 16
data$FB1_19[data$FB1_19%in%c(7)] <- 17
data$FB1_19[data$FB1_19%in%c(8)] <- 18

# SAP 14 - Therm_Zeit -----------------------------------------------------


#  Umkodieren, "NA" zu "7"
data$FB1_25[data$FB1_25%in%c("",NA)] <- 7




# SAP ? - Rohmaterial -----------------------------------------------------

#  zwei Spalten zu einer zusammenführen:
data <- cbind(data, FB1_16 = paste(sprintf("%02d", as.integer(data$Rohmat1)),sprintf("%02d", as.integer(data$Rohmat2)), sep=""))
data$FB1_16 <- gsub("NA", "", data$FB1_16)

# alte Spalten löschen
data$Rohmat1 <- NULL
data$Rohmat2 <- NULL



# SAP 14 - Therm_Zeit -----------------------------------------------------

#  Umkodieren, "NA" zu "7"
data$FB1_25[data$FB1_25%in%c("",NA)] <- 7


# SAP 20 - Erhaltung d. modifz. Stücks  -----------------------------------

#  Umkodieren, "NA" zu "5"
data$FB1_32[data$FB1_32%in%c("",NA)] <- 5


# SAP 33 - Grundform  -----------------------------------------------------

# Umkodieren, "3" zu "5"
data$FB1_33[data$FB1_33==3] <- 5
data$FB1_33[data$FB1_33==4] <- 3
data$FB1_33[data$FB1_33==5] <- 3
data$FB1_33[data$FB1_33==6] <- 4
data$FB1_33[data$FB1_33==8] <- 5
data$FB1_33[data$FB1_33==9] <- 5
data$FB1_33[data$FB1_33==7] <- 9

# SAP 38 - Verlauf Schlagrichtung  -----------------------------------------------------

# Umkodieren
if (is.null(data$FB2_38)==FALSE) {
data$FB2_38[data$FB2_38==7] <- 0}

# SAP 38 - SFR Form  -----------------------------------------------------

# abgeleitet aus SAP 38 - SFR ART
# muss im Skript vor SFR ART stehen

if (is.null(data$FB2_42)==FALSE) {

# leeren Vektor anfügen und mit Infos füllen
data <- cbind(data, FB2_43 = rep(c(999),nrow(data)))

# wo Art des SFR = gratfrömig, Form = "Linear/gratförmig"
data$FB2_43[data$FB2_42==6] <- 3

# wo Art des SFR = punktförmig, Form = "punktförmig"
data$FB2_43[data$FB2_42==7] <- 2
}

# SAP 38 - SFR Art  -----------------------------------------------------

# Umkodieren
if (is.null(data$FB2_42)==FALSE) {
 data$FB2_42[data$FB2_42==1] <- 3
 data$FB2_42[data$FB2_42==2] <- 1
 data$FB2_42[data$FB2_42==3] <- 4
 data$FB2_42[data$FB2_42==4] <- 5
 data$FB2_42[data$FB2_42==5] <- 9
 data$FB2_42[data$FB2_42==6] <- 999
 data$FB2_42[data$FB2_42==7] <- 999
 data$FB2_42[data$FB2_42==8] <- 7
}


# SAP 28 - Schlagaugen auf dem Schlagflächenrest  -------------------------

# Umkodieren
if (is.null(data$FB2_52)==FALSE) {
  data$FB2_52[data$FB2_52==0] <- 1
  data$FB2_52[data$FB2_52==1] <- 4
  data$FB2_52[data$FB2_52==2] <- 0
  data$FB2_52[data$FB2_52==3] <- 9
}


# SAP 29 - Menge der Rinde/nat. Flächen auf Dorsalseite und Schlagflächenrest  -------------------------

#*** ACHTUNG: "mehr als 1/3" wird hier als "Bis 2/3" Rinde behandelt
# und nicht aufgeteilt zwischen "bis 2/3" und "über 2/3".
# Merkmal ist nur im Sinne von p/a auswertbar


# Umkodieren
if (is.null(data$FB1_23)==FALSE) {
data$FB1_23[data$FB1_23==0] <- 1
data$FB1_23[data$FB1_23==2] <- 2
data$FB1_23[data$FB1_23==3] <- 4
data$FB1_23[data$FB1_23==4] <- 9
}

# SAP 30 - Negative auf Dorsalseite und dem SFR > 2cm mit Bulbusnegativ  --

# Umkodieren
#data$FB2_54[is.na(data$FB2_54)] <- 98
# Funktioniert nicht lookup_everthing erzeugt 479 NAs


# SAP 36 - Zustand des Distalendes  -----------------------

# Umwandeln in character
if (is.null(data$FB2_53)==FALSE) {

# Umkodieren
data$FB2_53[data$FB2_53=="2"] <- "5" # Ausgebogen
data$FB2_53[data$FB2_53=="3"] <- "7" # Eingebogen
data$FB2_53[data$FB2_53=="4"] <- "9" # Keine Aussage

# 1:Many-Problem: "Flach auslaufend" zu "Spitz zulaufend (dünn)"
data$FB2_53[data$FB2_53=="1"] <- "3" # Flach auslaufend -> Spitz zulaufend (dünn)
}

# SAP 36 - Abbaurichtung der Dorsalflächennegative  -----------------------

# Umkodieren
if (is.null(data$FB2_58)==FALSE) {
data$FB2_58[data$FB2_58==8] <- 9
}

# SAP 35 Schlagmerkmale auf Ventralseite ----------------------------------

# Die Schlagmerkmale Lippe und Bulbus werden bei SAP nicht erfasst.

if (is.null(data$Schlagm_Ventral)==FALSE) {

# leeren Vektoren anfügen für Kegel (FB2_49) und Narbe (FB2_51)
data <- cbind(data, FB2_49 = rep(c(999),nrow(data)))
data <- cbind(data, FB2_51 = rep(c(999),nrow(data)))


# Kegel
data$FB2_49[data$Schlagm_Ventral%in%c(2,4,6)] <- 4 # Kegel vorhanden
data$FB2_49[data$Schlagm_Ventral%in%c(1,3)] <- 0 # kein Kegel
data$FB2_49[data$Schlagm_Ventral%in%c(0)] <- 1 # Proximal nicht erhalten  

# Narbe
data$FB2_51[data$Schlagm_Ventral%in%c(3,4,5)] <- 4 # Narbe vorhanden
data$FB2_51[data$Schlagm_Ventral%in%c(1,2)] <- 0 # keine Narbe
data$FB2_51[data$Schlagm_Ventral%in%c(0)] <- 1 # Proximal nicht erhalten  

# Altes Merkmal "Schlam_Ventral" lösch
data$Schlagm_Ventral <- NULL

}

# SAP 43 Lage von Klopfspuren ----------------------------------
#
#if (is.null(data$Schlagm_Ventral)==FALSE) {
#data$FB2_67[data$FB2_67%in%c(3,4,5)] <- 4 # Narbe vorhanden
#names(data)[names(data) == "Klopfspur_Lage"] <- "FB2_67"
#}


# SAP ? - Modifikationsarten zusammenführen  -----------------------------------------------------

# führen Nullen ergänzen
data$Mod_Art_1 <- sprintf("%02d", as.integer(data$Mod_Art_1))
data$Mod_Art_2 <- sprintf("%02d", as.integer(data$Mod_Art_2))
data$Mod_Art_3 <- sprintf("%02d", as.integer(data$Mod_Art_3))
data$Mod_Art_4 <- sprintf("%02d", as.integer(data$Mod_Art_4))
data$Mod_Art_5 <- sprintf("%02d", as.integer(data$Mod_Art_5))
data$Mod_Art_6 <- sprintf("%02d", as.integer(data$Mod_Art_6))

#  Spalten zu einer zusammenführen:
data <- cbind(data, FB2_59 = paste(data$Mod_Art_1, data$Mod_Art_2, data$Mod_Art_3, data$Mod_Art_4, data$Mod_Art_5, data$Mod_Art_6,sep=""))
data$FB2_59 <- gsub("NA", "", data$FB2_59)
data$FB2_59 <- gsub(" ", "", data$FB2_59)
data$FB2_59 <- gsub(" ", "", data$FB2_59)

# alte Spalten entfernen
data$Mod_Art_1 <- NULL
data$Mod_Art_2 <- NULL
data$Mod_Art_3 <- NULL
data$Mod_Art_4 <- NULL
data$Mod_Art_5 <- NULL
data$Mod_Art_6 <- NULL




# SAP ? - Modifikations-Reihenfolge  -----------------------------------------------------

#  zwei Spalten zu einer zusammenführen:
data <- cbind(data, Mod_Reihe = paste(data$Mod_Reihe_1, data$Mod_Reihe_2, data$Mod_Reihe_3, sep=""))
data$Mod_Reihe <- gsub("NA", "", data$Mod_Reihe)
data$Mod_Reihe <- gsub(" ", "", data$Mod_Reihe)
data$Mod_Reihe <- gsub(" ", "", data$Mod_Reihe)

data$Mod_Reihe_1 <- NULL
data$Mod_Reihe_2 <- NULL
data$Mod_Reihe_3 <- NULL

table(data$Mod_Reihe)

data$Mod_Reihe[data$Mod_Reihe==""] <- "0"

names(data)[names(data) == "Mod_Reihe"] <- "FB2_60" 


# SAP - IGerM  -----------------------------------------------------

data$IGerM <- gsub(" ", "", data$IGerM)
data$IGerM

#data$igerm2 <- gsub(" ", "", data$igerm2)

# Export ------------------------------------------------------------------

#spalten_reihe <- c("FBG_1", "FBG_3",  "FBG_4",  "FBG_5",  "FBG_6", "FB1_16", "FB1_17", "FB1_18", "FB1_19", "FB1_20", "FB1_21", "FB1_22", "FB1_23", "FB1_24", "FB1_25", "FB1_26", "FB1_27", "FB1_28", "FB1_29", "FB1_30", "FB1_32", "FB1_33", "FB2_35",
#                   "FB2_38", "FB2_42", "FB2_43", "FB2_44", "FB2_45", "FB2_46", "FB2_49", "FB2_51", "FB2_52", "FB2_53", "FB2_54", "FB2_55", "FB2_56", "FB2_57", "FB2_58", "FB2_59", "FB2_60", "IGerM")
#data <- data[,spalten_reihe]

str(data)

cat("Writing SAS data to file\n")
write.csv(data, here::here("output",data.export.name),row.names = F)

