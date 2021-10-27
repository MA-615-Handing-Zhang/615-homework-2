# install.packages("rlang")
library(rlang)
library(ggplot2)


# I make a function using ggplot to reflect the relationship between income, life expectancy and years.
vis_function <- function(tidy_data, xcol, ycol){
  ggplot(data = tidy_data, aes(x = {{xcol}}, y = {{ycol}})) +
    geom_point(size=0.01)+ #Kosuke Added points with samll size in the graph 
  geom_smooth(se = F)
}

# We try the function to graph a curve with x being life and y being income.
# vis_function(tidy_data = life_vs_income_tidy, xcol = life, y = income)
# vis_function(tidy_data = life_vs_income_tidy, xcol = year, y = life)
# vis_function(tidy_data = life_vs_income_tidy, xcol = year, y = income)















