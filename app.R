library(shiny)
library(shinydashboard)
library(markdown)
library(googleVis)
library(ggplot2)
library(rCharts)
library(DT)


# Simple header -----------------------------------------------------------

header <- dashboardHeader(title="CO2 Prestatieladder")

# No sidebar --------------------------------------------------------------

sidebar <- ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Prestaties", tabName = "Prestaties", icon = icon("tree-deciduous", lib = "glyphicon")),
      menuItem("Planning", tabName = "Planning", icon = icon("calendar", lib = "glyphicon")),
      menuItem("Analyse", tabName = "Analyse", icon = icon("stats", lib = "glyphicon")),
      menuItem("Data", tabName = "Data", icon = icon("list-alt", lib = "glyphicon"))
    )
  )

# Compose dashboard body --------------------------------------------------

body <- dashboardBody(
  
  tabItems(
    # First tab content
    # Boxes need to be put in a row (or column)
    tabItem(tabName = "Prestaties",
            h2("Prestaties"),
            fluidRow(
              tabBox(
                width = 12,
                title = "",
                id = "tabset2", height = "250px",
                tabPanel("Q4 2014",
                         h3("Witek ten Hove, June, 07 2015"),
                         box(width = 12,
                             h4("Tekst"),
                             includeHTML("Venko op niveau 3 van de CO2-prestatieladder _ Venko - Venko prestatieladder worden heeft binnen ambitie.html"))            
                ),
                tabPanel("Q1 2015"
                         
                )
              ) # End of tabBox
            ) # End of fluidRow
            ),
    
    # Second tab content
    tabItem(tabName = "Planning",
            box(width = 12, h4("Planning"),
                includeMarkdown("txt11.md")
                ),
            box(width = 12,
                img(src='Energiemanagementprogramma.jpg', align = "right")
            )
            
    ),
    # Third tab content
    tabItem(tabName = "Analyse",
            h2("Analyse"),
            fluidRow(
              tabBox(
                width = 12,
                title = "",
                id = "tabset2", height = "250px",
                tabPanel("Kaart",
                         h2(""),
                         tags$iframe(
                           width="600",
                           height="450",
                           seamless="seamless",
                           src="http://www.allmoocs.nl/wordpress/wp-content/uploads/2015/06/venkomap3.html"
                         )
                ),
                tabPanel("Lijst"
                        
                )
              ) # End of tabBox
            ) # End of fluidRow
            ),
    
    # Fourth tab content
    tabItem(tabName = "Data",
            h2("Data"),
            fluidRow(
              
              column(2,
                     checkboxGroupInput('Per', 
                                        label = h3('Periode'), 
                                        choices = list('Q4 14' = 'Q4 14', 
                                                       'Q1 15' = 'Q1 15',
                                                       'Q2 15' = 'Q2 15',
                                                       'Q3 15' = 'Q3 15'),
                                        selected = c('Q4 14', 'Q1 15', 'Q2 15', 'Q3 15')),
                     
                     checkboxGroupInput('Scp', 
                                        label = h3('Scope'), 
                                        choices = list('Scope 1' = '1', 
                                                       'Scope 2' = '2',
                                                       'Scope 3' = '3'),
                                        selected = c('1', '2', '3'))
                     ),
              
              column(10,
                     DT::dataTableOutput('tableData')
                     
              )
            )
           )
    )
  )


# Setup Shiny app UI components -------------------------------------------

ui <- dashboardPage(header, sidebar, body, skin = "yellow")

# Setup Shiny app back-end components -------------------------------------

server <- function(input, output) {
  
  source("data.R")
  
  Per <- reactive({as.vector(input$Per)})
  
  Scp <- reactive({input$Scp})
  
  output$tableData <- DT::renderDataTable({
    
    subset(dataTbl, Periode %in% Per() & Scope %in% Scp())
    }
    
  )

}

# Render Shiny app --------------------------------------------------------

shinyApp(ui, server)