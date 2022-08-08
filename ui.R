#ui.R

library(shiny)
library(shinydashboard)
library(shinythemes)
library(bslib)
library(plotly)
library(DT)
library(dplyr)


fluidPage(
  
  tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Yusei+Magic&display=swap');
      body {
        background-color: black;
        color: white;
      }
      h2 {
        font-family: 'Yusei Magic', sans-serif;
      }

      .box-body {
      border-top-left-radius: 0;
      border-top-right-radius: 0;
      border-bottom-right-radius: 0;
      border-bottom-left-radius: 0;
      padding: 0;
      background-color: black;
      }

      label{
        color: white;
      }

        .row {
      margin-right: -15px;
      margin-left: -15px;
      background-color: black;
      }
      }

      #subbox > .box-header > .box-tools .btn {
                  background: #fd0000;
                    color: #ffffff;
      }
      .box {
        position: relative;
        border-radius: 3px;
        background: black;
        border-top: 0;
        margin-bottom: 0;
        width: 100%;
      }
      .info-box {
      display: block;
      min-height: 90px;
      background: black;
      width: 100%;
      box-shadow: 0 1px 1px rgba(0,0,0,.1);
      border-radius: 2px;
      margin-bottom: 15px;
      }

      .content {
        min-height: 250px;
        padding: 15px;
        margin-right: auto;
        margin-left: auto;
        padding-left: 15px;
        padding-right: 15px;
        background-color: black;
        }

        table.dataTable thead .sorting, table.dataTable thead .sorting_asc, table.dataTable thead .sorting_desc, table.dataTable thead .sorting_asc_disabled, table.dataTable thead .sorting_desc_disabled {
      cursor: pointer;
      *cursor: hand;
      background-repeat: no-repeat;
      background-position: center right;
      color: white;
      }
      .content-wrapper, .right-side {
      min-height: 100%;
      background-color: black;
      z-index: 800;
      }



      .irs--shiny .irs-grid {
          height: 27px;
          color: white;
      }


      .irs--shiny .irs-min, .irs--shiny .irs-max {
          top: 0;
          padding: 1px 3px;
          text-shadow: none;
          background-color: rgba(0, 0, 0, 0.1);
          border-radius: 3px;
          font-size: 10px;
          line-height: 1.333;
          color: white;
      }

        .dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter, .dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_processing, .dataTables_wrapper .dataTables_paginate {
      color: white;
      }
      .shiny-input-container {
        color: #474747;
      }")

  ),
  

  dashboardPage(
    skin="black",
    dashboardHeader(

      title = "World Happiness Analysis"
    ),
    dashboardSidebar(sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("house")),
      menuItem("Country", tabName = "country", icon = icon("globe")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Data", tabName = "data", icon = icon("table"))
    )),
    dashboardBody(
      tabItems(

        tabItem(
          tabName="home",
          h1("World Happiness Analysis"),
          h2("Context"),
          p("The World Happiness Report is a landmark survey of the state of global happiness. The first report was published in 2012, the second in 2013, the third in 2015, and the fourth in the 2016 Update. The World Happiness 2017, which ranks 155 countries by their happiness levels, was released at the United Nations at an event celebrating International Day of Happiness on March 20th. The report continues to gain global recognition as governments, organizations and civil society increasingly use happiness indicators to inform their policy-making decisions. Leading experts across fields – economics, psychology, survey analysis, national statistics, health, public policy and more – describe how measurements of well-being can be used effectively to assess the progress of nations. The reports review the state of happiness in the world today and show how the new science of happiness explains personal and national variations in happiness."),



          h2("Content"),
          p("The happiness scores and rankings use data from the Gallup World Poll. The scores are based on answers to the main life evaluation question asked in the poll. This question, known as the Cantril ladder, asks respondents to think of a ladder with the best possible life for them being a 10 and the worst possible life being a 0 and to rate their own current lives on that scale. The scores are from nationally representative samples for the years 2013-2016 and use the Gallup weights to make the estimates representative. The columns following the happiness score estimate the extent to which each of six factors – economic production, social support, life expectancy, freedom, absence of corruption, and generosity – contribute to making life evaluations higher in each country than they are in Dystopia, a hypothetical country that has values equal to the world’s lowest national averages for each of the six factors. They have no impact on the total score reported for each country, but they do explain why some countries rank higher than others."),



          h2("Data Explanation"),
          p("1. Country : Country Name"),
          p("2. Region : The region of the country"),
          p("3. Happiness Rank : Country's ranking based on their happiness score"),
          p("4. Happiness Score : 1-10 scale of happiness"),
          p("5. Standard Error : Standard deviation of the happiness score"),
          p("6. Economy (GDP per Capita) : How much GDP correlates to happiness score"),
          p("7. Family : How much family correlates to happiness score"),
          p("8. Health (Life Expectancy) : How much life expectancy correlates to happiness score"),
          p("9. Freedom : How much freedom correlates to happiness score"),
          p("10. Trust (Government Corruption) : How much government corruption correlates to happiness score"),
          p("11. Generosity : How much generosity correlates to happiness score"),
          p("12. Dystopia Residual : How much residual dystopia (Happiness score compared to the most unhappy country imaginable) correlates to happiness score"),



          a(href='https://www.kaggle.com/datasets/unsdsn/world-happiness', "Link to data")
        ),
        tabItem(

          tabName="country",
          fluidRow(
            infoBox(
              color = "teal",
              width=3,
              "HAPPIEST COUNTRY",
              happiness %>%
                arrange(desc(Ladder_Score)) %>%
                top_n(1, Ladder_Score) %>%
                select(Country),
              icon=icon("face-smile")
            ),
            infoBox(
              color="yellow",
              width=3,
              "UNHAPPIEST COUNTRY",
              happiness %>%
                arrange(Ladder_Score) %>%
                top_n(1, desc(Ladder_Score)) %>%
                select(Country),
              icon=icon("face-frown")
            ),
            box(

              width=6,

              selectInput(
                inputId = "input_col",
                label = "Choose Which Category to be Compared",
                choices = col.names3[!col.names3 %in% c("Ladder Score", "Ladder Score in Dystopia")]
              )




            ),
          ),

          fluidRow(
            box(
              width=6,
              plotlyOutput(outputId = "barPlot")

            ),


            box(
              width=6,
              plotlyOutput(outputId = "scatterPlot")


            )

          ),

          fluidRow(
            box(
              width=12,
              plotlyOutput(outputId="corrPlot")
            )

          )

        ),

        tabItem(
          fluidRow(
            box(
              width=12,
              sliderInput(inputId="width",
                          label="Map Width: ",
                          min = 300,
                          max=1500,
                          value = 700,
                          step = 10)
            )

          ),

          tabName="map",
          fluidRow(
            box(
              width=12,
              plotlyOutput(outputId="map")
            )
          )



        ),




        tabItem(
          tabName="data",
          DT::dataTableOutput(outputId = "table")
        )




      )

    )
  )


)


