############################################################
#
# Evaluation of data transformation
#
#
# 
#
############################################################


require(dplyr) # summarize


data.deco


# Filter only Lithic artefacts (SAP style)
#data.deco <- subset(data.deco, Rohmat1%in%Rohmat_Silex$Wert);
data.deco <- subset(data.deco, index_geraete_modifikation != "Natuerlicher Truemmer" & index_geraete_modifikation != "Unmodifziertes Geroell");
#data.deco <- subset(data.deco, gf_1 != " " & gf_1 != "Besondere Geraetekategorie");


# Spalte mit "unmod/mod" hinzufuegen (Gerät oder kein Gerät)
igerm_unmod <- c("Unmodifzierter Abschlag", "Unmodifzierte Klinge",  "Unmodifzierter Kern", "Unmodifzierter Kerntruemmer", "Unmodifziertes Geroell", "Artifzieller Truemmer","999","Natuerlicher Truemmer")
mod_unmod <- rep(NA,(nrow(data.deco)))
if(is.null(data.deco$mod_unmod)){data.deco <- cbind(data.deco, mod_unmod, stringsAsFactors=FALSE)}
data.deco$mod_unmod[data.deco$index_geraete_modifikation %in% igerm_unmod] <- c("unmod")
data.deco$mod_unmod[!data.deco$index_geraete_modifikation %in% igerm_unmod] <- c("mod")  


# Gesamtzahl
t0 <- data.frame("Gesamt" = c("Gesamtsumme"), "N" = nrow(data.deco))
t0

# Rohmaterialanteile
t1 <- data.deco %>%
  group_by(rohmaterial) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1))
t1

# Rohmaterialanteile mit zugeordneten Übergangsfeldern:

if(is.null(data.deco$rohmaterial_ord)){data.deco <- cbind(data.deco, rohmaterial_ord = data.deco$rohmaterial, stringsAsFactors=FALSE)}
# 0605 zu 05 (Zim 1988, Langenbrink 1996) 'Schotter-Rijck zu Rijk, auch in AE
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord=="0605"] <- c("05")
# 0603 zu 03 (Zim 1988, Langenbrink 1996) ' Schotter-Rullen gibt es in Arnoldsweiler nicht!
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord=="0603"] <- c("03")
# 0503 zu 03 (Zim 1988, Langenbrink 1996) ' Rijckholt-Rullen gibt es in Arnoldsweiler nicht!
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord=="0503"] <- c("03")

data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("01","0103","0105","0106","0109")] <- c("Hellgrauer 'belgischer' Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("02","0205","0206")] <- c("Vetschau-Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("03","0305","0306")] <- c("Rullen-Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("04")] <- c("Lousberg-Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("05", "0501", "0502", "Rijckholt-Schotter")] <- c("Rijckholt-Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("06")] <- c("Schotter-Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("07")] <- c("Obourg-Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("08", "0806")] <- c("Valkenburg-Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("10", "1002")] <- c("Singulaerer Feuerstein")
data.deco$rohmaterial_ord[data.deco$rohmaterial_ord%in%c("11")] <- c("Unbestimmbarer Feuerstein")

t2 <- data.deco %>%
  group_by(rohmaterial_ord) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1))
t2


# Stat. Maße der Gewichte

t3 <- data.deco[data.deco$gewicht!=999,] %>%
  summarise(Gew_Anzahl = n(), Gew_Min = min(gewicht,na.rm = T), Gew_Max = max(gewicht,na.rm = T), Gew_Mittel = round(mean(gewicht,na.rm = T),1), Gew_Median = median(gewicht,na.rm = T))
t3



# Grundform mod/unmod
t4 <- data.deco [data.deco$rohmaterial!=11,] %>% # unbestimmare Rohmat. ausschließen
  group_by(factor(data.deco$gf_1, levels=c("Abschlag","Klinge/Klingenbruchstueck","Kern","Truemmer","Geroell")), mod_unmod) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1), .groups = "drop_last")
t4


# Rinde (hier scheint ein Fehler in "lookup" vorzuliegen, "unbestimmbare Rinde" wird nicht richtig kodiert)
t5 <- data.deco %>%
  group_by(rinde) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1))
t5

# Grundform, mod/unmod und Rinde
rinde_pa <- rep(NA,(nrow(data.deco)))
if(is.null(data.deco$rinde_pa)){data.deco <- cbind(data.deco, rinde_pa, stringsAsFactors=FALSE)}
data.deco$rinde_pa[data.deco$rinde=="Keine Rinde"] <- "ohne_Rinde"

t6 <- data.deco %>%
  group_by(gf_1, mod_unmod, rinde_pa) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1), .groups = "drop_last")
t6



# Therm_Art
t7 <- data.deco %>%
  group_by(therm_art) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1))
t7

# Therm_Zeit
t8 <- data.deco %>%
  group_by(therm_zeit) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1))
t8

# Verbrannt ja/nein
feuer_pa <- rep("verbrannt",(nrow(data.deco)))
if(is.null(data.deco$feuer_pa)){data.deco <- cbind(data.deco, feuer_pa, stringsAsFactors=FALSE)}
data.deco$rinde_pa[data.deco$feuer_pa=="Keine thermische Einwirkung"] <- "unverbrannt"

t9 <- data.deco %>%
  group_by(gf_1, mod_unmod, feuer_pa) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1), .groups = "drop_last")
t9


# Kegel
t10 <- data.deco %>%
  group_by(gf_1, schlagmerkmal_kegel) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1), .groups = "drop_last")
t10


# Narben
t11 <- data.deco %>%
  group_by(gf_1, schlagmerkmal_schlagnarbe) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1), .groups = "drop_last")
t11


# Augen
t12 <- data.deco %>%
  group_by(gf_1, schlagmerkmal_schlagaugen) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco) * 100,1), .groups = "drop_last")
t12


# SFR-Art
t13 <- data.deco [data.deco$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),] %>%
  group_by(gf_1, schlagflaechenrest_art) %>%
  summarise(Anzahl = n(), 
            Proz = round(n() / nrow(data.deco[data.deco$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),]) * 100,1)
            , .groups = "drop_last")
t13

# SFR-Form
t14 <- data.deco [data.deco$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),] %>%
  group_by(gf_1, schlagflaechenrest_form) %>%
  summarise(Anzahl = n(),
            Proz = round(n() / nrow(data.deco[data.deco$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),]) * 100,1)
            , .groups = "drop_last")
t14


# IGerM
t15 <- data.deco[data.deco$mod_unmod=="mod",]  %>%
  group_by(index_geraete_modifikation) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.deco[data.deco$mod_unmod=="mod",]) * 100,1))
t15



export.file <- here::here("output/Data_Report.txt")
sink(export.file)
cat("Data Report\n\n")
tibble.liste <- list(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t13, t15)
for (i in 1:length(tibble.liste)) {   
  print(as.data.frame(tibble.liste[[i]]))
  cat("\n")
  cat("\n--------------------------------------------------------------------------")
  cat("\n\n")
}
as.data.frame(t1)
sink()

file.show(export.file)
