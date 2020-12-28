# Global Average Temperature Since 1850 - 2020

# Server
library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2) # for melt() function
temp <- read.csv("temperature.csv")  # load the data file that will be used for the task


shinyServer(
    function(input, output) { 
        # through reactive function, set up resulting values by processing user-input values
        temp_plot <- reactive({
            temp %>% 
                melt(id.vars = c("Year", "Region")) %>% # to plot the three lines on one graph, melt the data frame to combine the three cols into one col (upper, median, lower)
                filter(Year >= input$range[1] & Year <= input$range[2]) %>% # filter the range of year determined through the slider 
                filter(Region == input$select)}) # filter the regions selected by a user in the dropdown menu
        
        temp_summary <- reactive({ # doing the same work for the summary output
            temp %>%
                filter(Year >= input$range[1] & Year <= input$range[2]) %>%
                filter(Region == input$select)})
        
        
        # plot output
        output$myplot <- renderPlot({ # renderPlot displays graphs on the designated output position (myplot)
            # make a ggplot by inserting the temp_plot made above 
            ggplot(temp_plot(), aes(x = Year, y = value, colour = variable)) +
                geom_line(cex = 0.3) +
                ylab("Average temperature in celsius") +
                facet_grid(Region~.)
        })
        
        # summary output
        output$mysummary <- renderPrint({
            summary(temp_summary())  # generate a summary of the data set by input values
        })
        
        # table output
        output$mytable <- renderTable({
            temp_table <- temp_summary() # display part of the data frame filtered by users (same as the data for summary)
            temp_table
        })
        
    }
)
