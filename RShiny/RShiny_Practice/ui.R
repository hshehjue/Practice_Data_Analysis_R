#ui.R
library(shiny) # Install the necessary package

shinyUI(fluidPage( # Here we define the UI
    
    titlePanel(title = "Group name: Lubridate"), # Here we set the application title
    
    sidebarLayout( # Here we set the sidebar layout
        
        sidebarPanel( # Here we set the sidebar panel
            
            # Here we ask the user for numeric input
            # The default value is 30, the minimum value is 1, and the maximum is 50
            numericInput("num", label = "Insert a number:", value = 30),
            
            # Here we let the user decide whether he wants to change colors or not
            # The default starting plot doesn't have change color selected
            # The default color is black (selected = 1)
            checkboxInput("changecolor", label = "Change color", value = FALSE),
            
            # Here we give the user the option to pick a color out of 3 options
            # if he selects to change colors
            # He can choose between red, blue and green
            # The default color is black (selected = 1)
            radioButtons("color", label = "Pick a color:",
                         choices = list("red" = 2, "blue" = 4, "green" = 3),
                         selected = 1),
            
            # Here we set an action button so the plot won't change unless
            # we hit "Apply changes"
            actionButton("goButton", "Apply changes")
        ),
        
        mainPanel(plotOutput("plot")) # Here we set main panel, the output is a plot of 1/x
        # the plot is defined on the server side
        
    )
    
))