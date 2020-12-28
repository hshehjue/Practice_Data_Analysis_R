# Practice for RColorBrewer creating a geom_tile plot

install.packages("ggiraph")
install.packages("ggiraph")
library(ggiraph)
library(ggiraphExtra)
library(tidyr)
library(dplyr)
library(ggplot2)

# briefly discern the struction of the data set
glimpse(taco)

# RColorBrewer library provides sequential color palette 
library(RColorBrewer)
display.brewer.all()  # display what colors are available in the library 
cols <- brewer.pal(9, 'Greens')  # "Greens" is the most similar colors to the expected output


ggplot(data = taco, aes(x=AgeGroup, Filling, fill=Rating)) + 
  geom_tile(color = "white") + # geom_tile makes a heat map with the input data
  scale_fill_gradientn(colors=cols) +  # put the selected colors on the map
  facet_wrap(~ShellType) +  # vertically divide by ShellType 
  theme_bw() # apply theme_bw to the ggplot