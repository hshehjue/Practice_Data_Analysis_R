# Create a bar plot of the top 7 countries in new corona cases

library(tidyr)
library(dplyr)
library(ggplot2)

# load the covid19 csv file  
covid <- read.csv("covid19.csv", header = TRUE)

# give tbl_df class to the covid data file 
covid <- tbl_df(covid)
glimpse(covid)   # go through the data set

df1 <- covid %>%
  select(location, value) %>%   # select the two requisite columns
  group_by(country = location) %>%   # group out by locations
  summarise(new_cases = sum(value)) %>%   # sum up the values by locations 
  arrange(desc(new_cases)) %>%   # arrange the data in descending order 
  top_n(7, new_cases)   # pick the top 7 countries that have the biggest number of new_cases

print(df1)  

install.packages("ggthemes") # install the package "ggthemes" if not already been installed
library(ggthemes) 
library(scales)
show_col(calc_pal()(7))   # find out what colors I should use

# match each color to the corresponding country
colors <- c("India"="#ffd320", "US"="#314004", "Brazil"="#004586", 
            "Russia"="#83caff", "Colombia"="#ff420e", "Peru"="#7e0021", "Mexico"="#579d1c")


ggplot(data = df1, aes(x = reorder(country, -new_cases), y = new_cases, fill = country)) + 
  geom_col(color = "black", size = 2) +
  scale_fill_manual(values=colors) +   # assign the pre-determined colors to each bar
  labs(x = "Countries", y = "New cases/Day", fill = "location")   # label each axis and legend
