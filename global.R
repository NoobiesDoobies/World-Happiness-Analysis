# --------- LOAD LIBRARIES
options(scipen = 99) # me-non-aktifkan scientific notation
library(tidyverse) # koleksi beberapa package R
library(dplyr) # grammar of data manipulation
library(readr) # membaca data

library(ggplot2) # plot statis
library(plotly) # plot interaktif
library(glue) # setting tooltip
library(scales) # mengatur skala pada plot
library(DescTools)

# dashboarding
library(shiny)
library(shinydashboard)
library(DT) # datatable
library(reshape)
library(fresh)


happiness <- read.csv("world-happiness-report-2021.csv")


col.names <- c("Country", "Region", "Ladder_Score",
               "Standard_Error",
               "Upperwhisker", "Lowerwhisker", "Log_GDP",
               "Social_Support", "Healthy_Life_Expectancy",
               "Freedom_to_Make_Life_Choices", "Generosity",
               "Perception_of_Corruption",
               "Ladder_Score_in_Dystopia", "Explained_by_Log_GDP",
               "Explained_by_Social_Support",
               "Explained_by_Healthy_Life_Expectancy",
               "Explained_by_Freedom_to_Make Life_Choices",
               "Explained_by_Generosity",
               "Explained_by_Perception_of_Corruption",
               "Dystopia_Residuall")


names(happiness) <- col.names

happiness_sorted <- happiness %>%
  arrange(desc(Ladder_Score)) %>%
  mutate(label = glue("Country: {Country}
                      Happiness Score:  {round(Ladder_Score, 2)}"))

colors <- c("#ffd89b", "#19547b")
color <- "rgba(0, 0, 0, 1)"

theme_black<- function (base_size = 16, base_family = ""){
  theme_minimal() %+replace%
    theme(
      line = element_line(colour = "white", size = 0.5, linetype = 1,
                          lineend = "butt"),
      rect = element_rect(fill = "white",
                          colour = "white", size = 0.5, linetype = 1),
      text = element_text(family = base_family,
                          face = "plain", colour = "white", size = base_size,
                          angle = 0, lineheight = 0.9, hjust = 0, vjust = 0),
      plot.background = element_rect(col="black", fill = 'black'),
      plot.title = element_text(size = rel(1.2)),
      panel.border = element_rect(fill = NA, colour = NA),
      panel.grid.major = element_line(colour = "grey20"),
      panel.grid.minor = element_line(colour = NA),
      strip.background = element_rect(fill = "grey30", colour = "grey30"),
      axis.text.x = element_text(family=base_family, colour="white"),
      axis.text.y = element_text(family=base_family, colour="white", hjust=0.95, vjust=0.5),
      title = element_text(family=base_family, colour="white", size=10, hjust=0.5),
      panel.background=element_rect(colour="black")

    )
}






happiness2 <- happiness
col.names2 <- c("Country", "Region", "Ladder Score",
                "Standard Error",
                "Upperwhisker", "Lowerwhisker", "Log GDP",
                "Social Support", "Healthy Life Expectancy",
                "Freedom to Make Life Choices", "Generosity",
                "Perception of Corruption",
                "Ladder Score in Dystopia", "Explained by Log GDP",
                "Explained by Social Support",
                "Explained by Healthy Life Expectancy",
                "Explained by Freedom to Make Life Choices",
                "Explained by Generosity",
                "Explained by Perception of Corruption",
                "Dystopia Residuall")
names(happiness2) <- col.names2

col.names3 <- c("Ladder Score",
                "Log GDP",
                "Social Support", "Healthy Life Expectancy",
                "Freedom to Make Life Choices", "Generosity",
                "Perception of Corruption",
                "Ladder Score in Dystopia", "Explained by Log GDP",
                "Explained by Social Support",
                "Explained by Healthy Life Expectancy",
                "Explained by Freedom to Make Life Choices",
                "Explained by Generosity",
                "Explained by Perception of Corruption",
                "Dystopia Residuall")

happiness_numeric <- happiness2 %>%
  select_if(is.numeric) %>%
  select(-c("Standard Error", Upperwhisker, Lowerwhisker))


happiness_corr <- data.frame(cor(happiness_numeric))
names(happiness_corr) <- col.names3
happiness_corr$id <- row.names(happiness_corr)
happiness_corr <- melt(happiness_corr, id.vars="id")

happiness_corr <- happiness_corr %>%
  filter(variable=="Ladder Score") %>%
  replace(is.na(.), 0) %>%
  filter(id!="Ladder Score")


happiness$Country <- replace(happiness$Country, happiness$Country == "United States", "USA")
happiness$Country <- replace(happiness$Country, happiness$Country == "Congo (Brazzaville)", "Democratic Republic of the Congo")

world_map <- maps::map("world", ".", exact = FALSE, plot = FALSE, fill = TRUE) %>% fortify()

world_map <- merge(world_map, happiness, by.x="region", by.y="Country")

world_map <- world_map[order(world_map$group, world_map$order),]

world_map <- world_map %>%
  mutate(label = glue("Country: {region}
                      Happiness Score:  {round(Ladder_Score, 2)}"))


