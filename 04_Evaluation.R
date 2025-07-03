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


# Rohmaterialanteile
t1 <- data.deco %>%
  group_by(rohmaterial) %>%
  summarise(Anzahl = n(), Proz = n() / nrow(data.deco) * 100)
t1

# Rinde
t2 <- data.deco %>%
  group_by(rinde) %>%
  summarise(Anzahl = n(), Proz = n() / nrow(data.deco) * 100)
t2

# Menge Rinde
t3 <- data.deco %>%
  group_by(menge_rinde) %>%
  summarise(Anzahl = n(), Proz = n() / nrow(data.deco) * 100)
t3

# Therm_Art
t4 <- data.deco %>%
  group_by(therm_art) %>%
  summarise(Anzahl = n(), Proz = n() / nrow(data.deco) * 100)
t4

# Therm_Zeit
t5 <- data.deco %>%
  group_by(therm_zeit) %>%
  summarise(Anzahl = n(), Proz = n() / nrow(data.deco) * 100)
t5

# Grundform
t6 <- data.deco %>%
  group_by(gf_1) %>%
  summarise(Anzahl = n(), Proz = n() / nrow(data.deco) * 100)
t6


# IGerM
t7 <- data.deco %>%
  group_by(index_geraete_modifikation) %>%
  summarise(Anzahl = n(), Proz = n() / nrow(data.deco) * 100)
t7


sink(here("Data_Report.txt"))
cat("Data Report\n\n")
tibble.liste <- list(t1, t2, t3, t4, t5, t6, t7)
for (i in 1:length(tibble.liste)) {   
  print(as.data.frame(tibble.liste[[i]]))
  cat("\n")
  cat("\n--------------------------------------------------------------------------")
  cat("\n\n")
}
as.data.frame(t1)
sink()
