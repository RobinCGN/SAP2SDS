############################################################
#
# Evaluation of data transformation
#
#
# 
#
############################################################


require(dplyr) # summarize

# Rename columns
data.re <- rename(data, lanr = FBG_1,
                  lanr = FBG_1,                                  
                  befundnr = FBG_3,                              
                  posnr = FBG_4,                                
                  artefaktnr = FBG_5,                            
                  formblattnr = FBG_6,                           
                  farbe = FB1_17,                               
                  spalt_flaechen = FB1_18,                       
                  strukturen_material = FB1_19,                  
                  rinde = FB1_20,                               
                  sprung_flaechen = FB1_21,                      
                  abrollung = FB1_22,                            
                  therm_art = FB1_24,                           
                  therm_zeit = FB1_25,                           
                  erhaltung_gf = FB1_26,                         
                  LÃ.nge = LÃ.nge,                              
                  breite = FB1_28,                               
                  dicke = FB1_29,                                
                  gewicht = FB1_30,                             
                  erhaltung_mod = FB1_32,                        
                  gf_1 = FB1_33,                                 
                  erhaltung_gf_schlagrichtung = FB2_35,         
                  verlauf_schlagrichtung = FB2_38,               
                  Schlagflrest_LÃ.nge = Schlagflrest_LÃ.nge,     
                  schlagflaechenrest_breite = FB2_46,           
                  schlagflaechenrest_erhaltung = FB2_44,         
                  schlagflaechenrest_art = FB2_42,               
                  schlagmerkmal_schlagaugen = FB2_52,           
                  menge_rinde = FB1_23,                          
                  anzahl_negative_mit_bulbus = FB2_54,           
                  anzahl_negative_ohne_bulbus = FB2_55,         
                  distalende_zustand = FB2_53,                  
                  abbaurichtung_dorsalflaechennegative = FB2_58, 
                  index_geraete_modifikation = IGerM,            
                  rohmaterial = FB1_16,                         
                  schlagflaechenrest_form = FB2_43,              
                  schlagmerkmal_kegel = FB2_49,                  
                  schlagmerkmal_schlagnarbe = FB2_51,           
                  mod_art_dechsel_beil = FB2_59,                 
                  mod_reihenfolge_dechsel_beil = FB2_60)


# Filter only Lithic artefacts (SAP style)
#data.re <- subset(data.re, Rohmat1%in%Rohmat_Silex$Wert);
data.re <- subset(data.re, index_geraete_modifikation != 25 & index_geraete_modifikation != 26);
#data.re <- subset(data.re, gf_1 != " " & gf_1 != "Besondere Geraetekategorie");


# Spalte mit "unmod/mod" hinzufuegen (Gerät oder kein Gerät)
igerm_unmod <- c("Unmodifzierter Abschlag", "Unmodifzierte Klinge",  "Unmodifzierter Kern", "Unmodifzierter Kerntruemmer", "Unmodifziertes Geroell", "Artifzieller Truemmer","999","Natuerlicher Truemmer")
mod_unmod <- rep(NA,(nrow(data.re)))
if(is.null(data.re$mod_unmod)){data.re <- cbind(data.re, mod_unmod, stringsAsFactors=FALSE)}
data.re$mod_unmod[data.re$index_geraete_modifikation %in% igerm_unmod] <- c("unmod")
data.re$mod_unmod[!data.re$index_geraete_modifikation %in% igerm_unmod] <- c("mod")  


# Gesamtzahl
t0 <- data.frame("Gesamt" = c("Gesamtsumme"), "N" = nrow(data.re))
t0

# Rohmaterialanteile
t1 <- data.re %>%
  group_by(levlab(data.re$rohmaterial)) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1))
t1

# Rohmaterialanteile mit zugeordneten Übergangsfeldern:

if(is.null(data.re$rohmaterial_ord)){data.re <- cbind(data.re, rohmaterial_ord = data.re$rohmaterial, stringsAsFactors=FALSE)}
# 0605 zu 05 (Zim 1988, Langenbrink 1996) 'Schotter-Rijck zu Rijk, auch in AE
data.re$rohmaterial_ord[data.re$rohmaterial_ord=="0605"] <- c("05")
# 0603 zu 03 (Zim 1988, Langenbrink 1996) ' Schotter-Rullen gibt es in Arnoldsweiler nicht!
data.re$rohmaterial_ord[data.re$rohmaterial_ord=="0603"] <- c("03")
# 0503 zu 03 (Zim 1988, Langenbrink 1996) ' Rijckholt-Rullen gibt es in Arnoldsweiler nicht!
data.re$rohmaterial_ord[data.re$rohmaterial_ord=="0503"] <- c("03")

data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("01","0103","0105","0106","0109")] <- c("Hellgrauer 'belgischer' Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("02","0205","0206")] <- c("Vetschau-Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("03","0305","0306")] <- c("Rullen-Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("04")] <- c("Lousberg-Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("05", "0501", "0502", "Rijckholt-Schotter")] <- c("Rijckholt-Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("06")] <- c("Schotter-Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("07")] <- c("Obourg-Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("08", "0806")] <- c("Valkenburg-Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("10", "1002")] <- c("Singulaerer Feuerstein")
data.re$rohmaterial_ord[data.re$rohmaterial_ord%in%c("11")] <- c("Unbestimmbarer Feuerstein")

t2 <- data.re %>%
  group_by(rohmaterial_ord) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1))
t2


# Stat. Maße der Gewichte

t3 <- data.re[data.re$gewicht!=999,] %>%
  summarise(Gew_Anzahl = n(), Gew_Min = min(gewicht), Gew_Max = max(gewicht), Gew_Mittel = round(mean(gewicht),1), Gew_Median = median(gewicht))
t3



# Grundform mod/unmod
t4 <- data.re [data.re$rohmaterial!=11,] %>% # unbestimmare Rohmat. ausschließen
  group_by(gf_1, mod_unmod) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1), .groups = "drop_last")
t4


# Rinde (hier scheint ein Fehler in "lookup" vorzuliegen, "unbestimmbare Rinde" wird nicht richtig kodiert)
t5 <- data.re %>%
  group_by(levlab(data.re$rinde)) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1))
t5

# Grundform, mod/unmod und Rinde
rinde_pa <- rep(NA,(nrow(data.re)))
if(is.null(data.re$rinde_pa)){data.re <- cbind(data.re, rinde_pa, stringsAsFactors=FALSE)}
data.re$rinde_pa[data.re$rinde=="Keine Rinde"] <- "ohne_Rinde"

t6 <- data.re %>%
  group_by(gf_1, mod_unmod, rinde_pa) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1), .groups = "drop_last")
t6



# Therm_Art
t7 <- data.re %>%
  group_by(levlab(data.re$therm_art)) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1))
t7

# Therm_Zeit
t8 <- data.re %>%
  group_by(levlab(therm_zeit)) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1))
t8

# Verbrannt ja/nein
feuer_pa <- rep("verbrannt",(nrow(data.re)))
if(is.null(data.re$feuer_pa)){data.re <- cbind(data.re, feuer_pa, stringsAsFactors=FALSE)}
data.re$rinde_pa[data.re$feuer_pa=="Keine thermische Einwirkung"] <- "unverbrannt"

t9 <- data.re %>%
  group_by(gf_1, mod_unmod, feuer_pa) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1), .groups = "drop_last")
t9


# Kegel
t10 <- data.re %>%
  group_by(gf_1, schlagmerkmal_kegel) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1), .groups = "drop_last")
t10


# Narben
t11 <- data.re %>%
  group_by(gf_1, schlagmerkmal_schlagnarbe) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1), .groups = "drop_last")
t11


# Augen
t12 <- data.re %>%
  group_by(gf_1, schlagmerkmal_schlagaugen) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re) * 100,1), .groups = "drop_last")
t12


# SFR-Art
t13 <- data.re [data.re$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),] %>%
  group_by(gf_1, schlagflaechenrest_art) %>%
  summarise(Anzahl = n(), 
            Proz = round(n() / nrow(data.re[data.re$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),]) * 100,1)
            , .groups = "drop_last")
t13

# SFR-Form
t14 <- data.re [data.re$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),] %>%
  group_by(gf_1, schlagflaechenrest_form) %>%
  summarise(Anzahl = n(),
            Proz = round(n() / nrow(data.re[data.re$gf_1%in%c("Abschlag","Klinge/Klingenbruchstueck"),]) * 100,1)
            , .groups = "drop_last")
t14


# IGerM
t15 <- data.re[data.re$mod_unmod=="mod",]  %>%
  group_by(index_geraete_modifikation) %>%
  summarise(Anzahl = n(), Proz = round(n() / nrow(data.re[data.re$mod_unmod=="mod",]) * 100,1))
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
