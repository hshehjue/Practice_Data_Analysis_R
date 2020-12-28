# server.R
    library(shiny) # Install the necessary package

shinyServer(function(input, output) { # Here we set the server side of our code
    # On the server side we set the expressions and functions
    # that will process the inputs into desired outputs
    
    output$plot <- renderPlot({ 
        
        # Simply accessing input$goButton here makes this reactive
        # object take a dependency on it. That means when
        # input$goButton changes, this code will re-execute.
        input$goButton
        
        isolate({ # Use isolate() to avoid dependency on input$num
            
            # If the user decides to change the color (input$changecolor == TRUE),
            # and he picks a color before hitting apply changes,
            # we plot 1/x with the selected color 
            # If the user decides to change the color (input$changecolor == TRUE),
            # but doesn't pick a color before hitting apply changes,
            # nothing is plotted
            if(input$changecolor == TRUE) {
                if (input$num %in% c(1:50)) { # plot the graph as long as the entered number ranges from 1 to 50
                    plot((1 / 1:input$num), col = input$color)} # We plot from 1 and the passed number
                else {
                    break
                    }
                }
            
            # Otherwise we just plot with the default black color
            else {
                if (input$num %in% c(1:50)) {
                    plot(1 / 1:input$num)
                    } # We plot from 1 and the passed number 
                else {
                    break
                    }
                
            }
            
        })
        
    })
    
})
