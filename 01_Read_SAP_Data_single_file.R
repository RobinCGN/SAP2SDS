#*****************************************************
# SAP-DATEIEN EINLESEN 
#
# SAP-Dateien (txt-Dateien) einzeln einlesen ohne Loop
#*****************************************************

require(here)
require(plyr)

## R-Script "MERKMALSLISTE EINLESEN" aufrufen:
load(here::here("source/SAP attribute data/SAP_attributes.RData"))


# String mit den Dateinamen erstellen

#datei <- file.choose()
datei <- here::here("data-raw/SAP/LW8.txt")
#datei <- c("L:/00_Peters/Projekte, Publikationen/Projekte/2025_SDS/data-raw/SAP/LW8.txt")


# bei namen ".txt" abtrennen:
namen   <-   unlist(strsplit(as.character(basename(datei)), split = ".txt", fixed=TRUE))





#Tabelle mit MetaInfos (Spaltename, -breite, 
#Skalenniveau, etc) einlesen

meta <- meta_steine

# leere Data.frames erstellen
alle <- data.frame(NULL)
silex <- data.frame(NULL)
fels <- data.frame(NULL)

# einzelne dateien einlesen:
x <- NULL
i <- 1


## vektoren erstellen für jede Datei mit Dateinamen (nur Merkmale und Werte)
assign(namen[1], NULL)
assign(paste(namen[1], "_silex", sep=""),NULL);
assign(paste(namen[1], "_fels", sep=""),NULL)


#
#
# Datei einlesen und x(i) bennen (nur Merkmale)

  assign(paste ("x", i, sep=""), NULL);
  #
  #
  # Testen ob spezielle meta-Datei vorhanden ist:
  nam <- namen[i]
  metafile <- c(paste(nam, "_meta.csv", sep=""))
  cat(namen[i], sep="\n")
  if (file.exists(metafile)) {
    x <- NULL
    cat("Meta-Datei vorhanden, Daten werden eingelesen...", sep="\n")
    meta_spez <- read.csv(metafile, header=TRUE, sep=";")
    meta_spez$niveau <- as.character(meta_spez$niveau)
    x <- read.fwf(datei, dec=".", width = meta_spez$breite, colClasses=meta_spez$niveau);
    # Spaltennamen festlegen
    spez_name <- subset(meta_spez$name, meta_spez$niveau!="NULL")
    dimnames(x)[[2]] <- spez_name;
    assign(namen[i], x);
  } else {
    cat("Daten werden eingelesen...", sep="\n")
  x <- read.fwf(datei, dec=".", width = meta$breite, colClasses=meta$niveau);
  # Spaltennamen festlegen
  dimnames(x)[[2]] <- meta$name;
  assign(namen[i], x);
  }
  #
  # Prüfen, ob es ein R-Skript gibt, dass nach dem weiterverarbeiten ausgeführt werden soll:
  #
  R_nachher <- c(paste(nam, "_R.R", sep=""))
  if (file.exists(R_nachher)) {
    cat("R-Skript vorhanden, Skript wird ausgef?hrt...", sep="\n")
    ## R-Script ausf?hren:
    source(R_nachher);
  } else {}
  
  
  # An allen Dateien durchführen:

  # Spalte mit "Dateinamen" hinzufügen
  if("name" %in% colnames(x))
  {
    cat("Spalte mit Dateinamen bereits vorhanden\n")
  } else {
  x <- cbind(x, name=c(rep(namen[i], nrow(x))));
  }


# KERNE --------------------------------------------------------  
  
  # Kerne einlesen
  kern <- read.fwf(datei, dec=".", width = meta_kern$breite, colClasses=meta_kern$niveau, col.names = meta_kern$name)
  # GRUNDFORMEN (Kerne, Tr?mmer, etc.) ausw?hlen:
  kern <- subset(kern, Grundform == 3 | Grundform == 9 | Grundform == 8)
  # Kern-Grundformen aus "x" löschen
  x <- subset(x, !x$Grundform%in%c(3,8,9))
  x <- plyr::rbind.fill(x, kern)
  
  
  ## Leerzeichen löschen bei Rohmat:
  gsub(" ","0", x$Rohmat1, fixed=TRUE) -> x$Rohmat1;
  gsub(" ","", x$Rohmat2, fixed=TRUE) -> x$Rohmat2;
  x$Rohmat1 <- factor(x$Rohmat1);
  x$Rohmat2 <- factor(x$Rohmat2);
  
  
  ## Bei den Stellen Leerzeichen durch Nullen ersetzen
  gsub(" ","0", x$Stelle, fixed=T) -> x$Stelle;
  x$Stelle <- factor(x$Stelle);
  
  # Leerzeichen löschen bei IGerM:
  #gsub(" ","", x$igerm1, fixed=TRUE) -> x$igerm1;
  #x$igerm1 <- factor(x$igerm1);
  
  # Alle Dateien in eine großen Tabelle (data frame) schreiben
  alle <- plyr::rbind.fill(alle, x);
  assign(namen[i], x);
 
  # Silices abtrennen (z.B. lw8_silex, lw8_fels)
  #und zwei Vektoren mit fundplatz?bergreifend allen silices und allen felsgesteinen
  # Quarzite und Kieselschiefer werden hier als Felsgesteine gez?hlt (anders als bei Zimmermann 1988)
  
  y <- subset(x, Rohmat1%in%Rohmat_Silex$Wert);
  assign(paste(namen[i],"_silex", sep=""), y);
  silex <- plyr::rbind.fill(silex, y);
  y <- subset(x, ! Rohmat1%in%Rohmat_Silex$Wert);
  fels <- plyr::rbind.fill(fels, y);
  assign(paste(namen[i],"_fels", sep=""), y);

  # Silexartefakte abtrennen (z.B lw8_silex_art)
  z <- subset(x, Rohmat1%in%Rohmat_Silex$Wert);
  z <- subset(z, igerm1 != "25" & igerm1 != "26");
  z <- subset(z, Grundform != " " & Grundform != "0");
  assign(paste(namen[i],"_silex_art", sep=""), z);




# Einen data.frame nur mit den Silexartefakten
silex_art <- subset(silex, igerm1 != "25" & igerm1 != "26")
silex_art <- subset(silex_art, Grundform != " " & Grundform != "0")




# AUFRÄUUMEN
rm (R_nachher, i, metafile, nam, x, y, z, datei, x1)




print("Following Files have been read:")
print(namen)
print("Following Files have been created:")
print(paste(sort(rep(namen,4)),c("","_silex","_silex_art","_fels"),sep=""))