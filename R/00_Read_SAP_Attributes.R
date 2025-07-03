#*****************************************************************************
#
# MERKMALSLISTEN EINLESEN
#
# Ließt einen Ordner mit allen csv-Dateien mit der einzelnen Merkmale des 
# Formblatts 1 (nach Zimmermann 1988) ein.
# Also z.B. das Merkmal Rohmaterial-Farbe.
#
# Die Merkmalslisten sind nach folgenden Schema aufgebaut:
#
# ID; Merkmalsname; Code/Wert
#
# z.B.:
#
# ID;Therm_Art;Wert
# 1;Keine thermische Einwirkung vorhanden;0
# 2;Farbänderungen;1
# 3;Risse;2
#
#*****************************************************************************

require(here)

options(encoding = "latin1")
#
# Festlegen das sich die Merkmalsdatien in folgendem Ordner befinden:
#
ordner <- c(here::here ("source/SAP attribute data"))
setwd(ordner)
#
# String mit den Dateinamen erstellen
#
dateien <- as.character(list.files(pattern="*.csv", path=ordner, full.names=TRUE))
# dateien ist eine Liste mit allen dateien und deren Pfad in diesem Ordner
#
#
# einzelne dateien einlesen:
n = (length(dateien))
x <- NULL
spaltennam <- NULL
#
#
# Dateien in Loop (for...) einlesen und x(i) bennen (nur Merkmale)
for (i in 1:n)
{ 
  assign(paste ("x", i, sep=""), NULL);
  x <- read.csv2(dateien[i], header=TRUE, sep=";", colClasses=c("NULL", "character","NULL"),encoding = "utf8");
  assign(paste ("x", i, sep="."), x);
  # Merkmalsbezeichnungen (Rohmat, Rohmat_Farbe, etc.) in einen Vektorschreiben
  spaltennam <- c(spaltennam,colnames(x[1]));
}
#

# vektoren erstellen für jede Datei mit Dateinamen. Also z.B. Vektor Rohmat, Vektor Rohmat_Farbe, etc.
for (i in 1:n)
{assign(spaltennam[i], NULL)}

# Dateien einlesen und in die einzelnen Vektoren (Rohmat, Rohmat_Farbe) schreiben:
for (i in 1:n){
  # Weil die Dateien unterschiedlich viele Spalten haben wird es hier kompliziert:
  # Spalten einlesen, Niveau festlegen, und soviele Spalten wie da sind als "character" festlegen (mit count.fields etc.)
  x <- read.table(dateien[i], header=TRUE, sep=";", colClasses=c("NULL", "character",rep("character", count.fields(textConnection(readLines(dateien[i], n=1)), sep=";")-2)),encoding = "utf8");
  assign(spaltennam[i], x);
}
#
#
## ERGäNZUNGEN:
#
# DataFrame mit nur den Silex-Rohmaterialien:
Rohmat_Silex <- subset(Rohmat, Kategorie=="Silex")

# DataFrame mit nur den Silex-Rohmaterialien:
Rohmat_SandRötel <- subset(Rohmat, Kategorie=="Sandstein" | Kategorie=="Rötel")

# DataFrame mit nur den Silex-Rohmaterialien:
Rohmat_Fels <- subset(Rohmat, Kategorie!="Silex")

# Rohmat zu Rohmat1:
Rohmat1 <- Rohmat
colnames(Rohmat1)[1] <- c("Rohmat1")

# Rohmat zu Rohmat2:
Rohmat2 <- Rohmat
colnames(Rohmat2)[1] <- c("Rohmat2")


# IGerM zu igerm1:
igerm1 <- IGerM
colnames(igerm1)[1] <- c("igerm1")

#
# AUFRÄUMEN:
#
# alle Objekte die mit d (kleinen "x") anfangen entfernen:
rm(list=ls(pattern="^x"))
#
# i, n, ordner, namen, entfernen:
rm(i, n, ordner,spaltennam, dateien)
#
#
#
# Merkmalslisten auflisten:
ls()


# Meta-Daten einlesen
meta_steine <- read.csv("Meta_Steine.csv", header=TRUE, sep=";", encoding = "ut8")
meta_kern <- read.csv("Meta_Kern.csv", header=TRUE, sep=";", encoding = "ut8")
meta_beil <- read.csv("Meta_Beil.csv", header=TRUE, sep=";", encoding = "ut8")
meta_sandstein <- read.csv("Meta_Sandstein.csv", header=TRUE, sep=";", encoding = "ut8")
meta_steine$niveau <- as.character(meta_steine$niveau)
meta_kern$niveau <- as.character(meta_kern$niveau)
meta_beil$niveau <- as.character(meta_beil$niveau)
meta_sandstein$niveau <- as.character(meta_sandstein$niveau)



# LEVLAB-FUNKTION:
#
#  Funktion, die einem Faktor levels und labels hinzufügt:
levlab <- function(x) {
  nam <- c(deparse(substitute(x)))
  # "data$" aus den Namen l?schen
  kurznam <- unlist(strsplit(nam, "$", fixed=T))[2]
  # levels aufrufen
  wert <- eval(parse( text=paste(kurznam, "$", "Wert", sep = "")), env=.GlobalEnv)
  # labels aufrufen
  beschrift <- eval(parse( text=paste(kurznam, "$", kurznam, sep = "")), env=.GlobalEnv)
  # daraus einen factor machen
  x <- factor(x, levels=wert, labels = beschrift)
}
#table(levlab(data$Nat_Fl))
#


# Save data to RData-File
save.image(file="SAP_attributes.RData") 

