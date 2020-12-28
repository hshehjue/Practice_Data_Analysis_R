# rank the factors impacting air-bnb price from least to highest:
# 1. room_type
# 2. reviews
# 3. overall_satisfaction 
# 4. accommodates
# 5. bedrooms

bnb <- read.csv("airbnb.csv", header = TRUE)

# check the data types, transform categorical variables to a factor data type
str(bnb)
bnb$room_type <- as.factor(bnb$room_type)

# In order to compare the effects of the independent variables on the dependent variable, I'll have a look at the coefficients of the predictors. The coefficients tell us not only the directions of their relationships but how much prices are changed given a unit change of each predictor.
# I'm standardizing each non-categorical independent variable to prevent the overestimation resulting from the variables' different scales.

regression_model <- lm(price~room_type+scale(reviews) + scale(overall_satisfaction) + scale(accommodates) + scale(bedrooms), data = bnb)

summary(regression_model)   # call the summary of the fitted multi-linear regression model

cor(bnb[, c(2, 3, 4, 5, 6)])   # the independent variables aren't correlated significantly


# <Summary>
# 1) p-value of F-test < 0.05: the overall regression model is significant
# 2) each predictor's p-value of t-test < 0.05 (excepting "reviews"): each of the determinants is significant
# 3) the R-squared is too low to demonstrate the enough explanatory power of the regression line. However, as the model is built with the factors reflecting consummers' behavioral tendency in real world, I acknowledge the difficulty in explaining variations of the limited data.
# 4) For the case of room_type, choosing an entire home/apt increases the mean prices by $253.5 approximately. Selecting a private room and shared room decrease the mean prices by $82.3 and $124.7 respectively COMPARED TO choosing an entire home. 


# <Results> 
# According to my observation, I have drawn the fact that the dummy variables of the room_type have the highest coefficients (253.5(=Intercept)/ 171.1(=253.5-82.3)/ 128.8(=253.5-124.7)) out of all the predictors. Plus, the "reviews" does not have a significant relationship with "price." As a result, in descending order, the importance of the factors can be ranked as: 
# (1) reviews (2) accommodates (3) bedrooms (4) overall_satisfaction (5) room_type