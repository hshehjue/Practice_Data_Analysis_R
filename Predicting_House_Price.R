# Predicting housing prices 

#--------------------------------------------
# <Final Decisions>
# only 6 predictors out of the given 18 predictors have turned out to be the significant determinants for housing prices. 
# 1) room_num, 2) age, 3) teachers, 4) poor_prop, 5) airport, 6) n_hos_beds
# Therefore, I would recommend that Zilow management takes the six factors into      account in predicting as precise housing prices as possible.
#--------------------------------------------

# procedures 

# load the dataset 
house <- read.csv("house_price.csv", header = TRUE)
str(house)

# change categorical variables to factor data
house$airport <- as.factor(house$airport)
house$waterbody <- as.factor(house$waterbody)
house$bus_ter <- as.factor(house$bus_ter)
str(house)

# detect columns that have missing values 
detect <- function(col) {   
  if (sum(is.na(house[col]) > 0)) {
    print(paste("column with null: ", names(house)[col]))
  } else if (length(house[which(house[col] == " "), col]) > 0) {
    print(paste("column without data: ", names(house)[col]))
  } 
}

for (col in 1:ncol(house)) {
  detect(col)
}


sum(is.na(house$n_hos_beds))  # check how many null values the column has 
house <- house[complete.cases(house[, "n_hos_beds"]), ] # delete the rows with null 
row.names(house) <- NULL # reorder the indexes of the reduced rows


# use box plots to check outliers & shapes of distributions of the continuous variables
par(mfrow = c(2,3))
for (i in 2:7) {
  boxplot(house[, i], ylab = names(house[i]), frame = FALSE, xaxt = "n")
}

par(mfrow = c(2,3))
for (i in c(8,9,10,11,12,14)) {      # avoid factor variables
  boxplot(house[, i], ylab = names(house[i]), frame = FALSE, xaxt = "n")
}

par(mfrow = c(2,2))
for (i in c(15,17,19)) {            # avoid factor variables
  boxplot(house[, i], ylab = names(house[i]), frame = FALSE, xaxt = "n")
}


# many variables are extremely skewed 
# by using the log function, make their distributions relatively normal 

# for the data skewed to the right
house[, c(2,4,7,8,9,10,11,12)] <- log10(house[, c(2,4,7,8,9,10,11,12)]) 
# for the data skewed to the left
house$age <- log10(max(house$age + 1) - house$age)  


# check if the skewness issue has been fixed (taking "crime_rate" as an example)
# make the binwidth 
breaks <- pretty(range(house$crime_rate), n = nclass.FD(house$crime_rate), min.n=1)
bwidth <- breaks[2] - breaks[1]     

# plot histogram by using ggplot to check the distribution of crime_rate variable
library(ggplot2)
ggplot(house, aes(x = crime_rate, color="gray")) + 
  geom_histogram(binwidth = bwidth, color = "gray") +
  xlab("crime_rate")


# find the indexes of the two outliers deceted from the boxplot
which(house$n_hot_rooms %in% boxplot(house$n_hot_rooms)$out)

# drop the rows with the outliers from the data frame
house <- house[-c(3, 417), ]
row.names(house) <- NULL   # reorder rows 

# check the free-outlier n_hot_rooms via boxplot
ggplot(house, aes(y = n_hot_rooms, color = "red")) +
  geom_boxplot() 

# delete the variable unnecessary for a prediction model 
length(house[which(house$bus_ter == "YES"), "bus_ter"]) == nrow(house) 
house <- house[, -c(18)] # drop the column because every data is "YES"

# fit a multiple linear regression model with the resulting data frame
result_1 <- lm(price~., data = house)
summary(result_1)
str(house)
# diagnose multicollinearity by going through the correlations among variables
cor(house[, c(1,2,3,4,5,6,7,8,9,10,11,12,14,15,17,18)])

# dist1, dist2, dist3, dist4 are highly correlated to one another
# air_qual & parks are correlated to each other (drop "parks" which is less       correlated to "price")
house <- house[, -c(7,8,9,10,18)]


# fit a regression model again with the remaining variables
result_2 <- lm(price~., data = house)
summary(result_2)

# remove variables whose p-values of t-test are bigger than 0.05
house <- house[, -c(2,3,11,12,13,14,15)]
result_3 <-result_3 <- lm(price~., data = house)
summary(result_3)

# remove air_qual and fitting the final model
house <- house[, -c(2)]
price_prediction <- lm(price~., data = house)
summary(price_prediction)

# diagnose the models' normality, linearity, outliers
plot(price_prediction) 

# <Summary>
# (1) the model is slightly non-linear but overall looks fine
# (2) adj R-squared: high enough for the regression line's explanatory power
# (3) F-test > 0.05: the overall model is significant
# (4) t-test > 0.05: each variable is significant
# Final Regression Function: 
# Estimated price = -26.94 + 2.67(room_num) + 0.04(age) + 16.93(teschers)                           - 10.27(poor_prop) + 1.36(airport) + 0.02(n_hos_beds) 

# calculate fitted values and make a data frame with the outcomes
fitted_df <- cbind(data.frame("fitted" = fitted(price_prediction)), house)
print(fitted_df)