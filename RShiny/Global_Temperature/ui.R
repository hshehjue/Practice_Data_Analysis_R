# Global Average Temperature Since 1850 - 2020

# UI
library(shiny)

# Start writing a UI page with fluidPage() function
shinyUI(fluidPage(
    # Write a title in a title panel
    titlePanel(title = "Global Average Temperatures Since 1850 - 2020"),
    # make a sidebar layout for input and output graphics
    sidebarLayout(   
        sidebarPanel(    # in a sidebar panel, put widgets for input values
            # make a dropdown menu bar for the selection of regions 
            selectInput("select", "View changes by global or regions:", 
                        choices = c("Global", 
                                    "Northern Hemisphere", 
                                    "Southern Hemisphere", 
                                    "Tropics"), 
                        selected = "Global"),  # Global is the default option 
            
            # by setting two values in a value(), make a range slider for a range of year
            sliderInput("range", "Year", 
                        min = 1850, max = 2020, 
                        value = c(1850, 2020))
        ),
        # make a main panel on which output appears 
        mainPanel(
            tabsetPanel(   # tabsetPanel makes multiple pages for different types of output 
                tabPanel("Plot", plotOutput("myplot")),  # first tab for a plot
                tabPanel("Summary", verbatimTextOutput("mysummary")), # second tab for a summary
                tabPanel("Table", tableOutput("mytable")) # third tab for a table
            ))
    )
    
))