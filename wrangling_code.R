

# Library the package we need for data wrangling.

library(tidyverse)
library(dplyr)

# read in the data.
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Also turn the data into tibbles right after reading them.
income_raw <- as_tibble(read.csv("https://raw.githubusercontent.com/MA-615-Handing-Zhang/615-homework-2/main/income.csv"))
str(income_raw)          

life_raw <- as_tibble(read.csv("https://raw.githubusercontent.com/MA-615-Handing-Zhang/615-homework-2/main/life.csv", header = T))
str(life_raw)

# Datasets Introduction:
# income: Gross domestic product per person adjusted for differences in purchasing power( in international dollars)
# life expectancy: The average number of years a new born child would live if current mortality patterns were to stay the same.
head(income_raw)
head(life_raw)


# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------


# The idea is that we want to clean the data and turn them into "tidy" form.
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# I want to turn income value: 12.3k(characters) into 12300(numeric)
# First I trun every column except the first column "country" into character columns so I can pivot them without causing concliction.
# I name the output income_cha, standing for income dataset with character columns.
income_cha <- income_raw %>% 
  select(starts_with("X")) %>%      # Subseting all columns with a year as its header.
  map(as.character) %>%             # map() applies a function to each element of a list and return a list
  as.tibble() %>%                   # We then turn this list into a tibble.
  mutate(country = income$country, .before  = X1799) # finally we add back the country column which we deleted in selection()

str(income_cha) # now we can see that every column of my new dataset is in character form.


# Now I proceed to pivoting the "wide" data into "long" dat, a tidy form where each row is an observation and each column is a variable.
income_cha_long <- income_cha %>% 
  pivot_longer(cols =  starts_with("X"),  # the years in our data (1st row) all start with X. These column names are actually data so we want to store them in one column named year.
               names_to  = "year",        # We turn these data into a column, assigning column name: year to it.
               values_to = "income",      # for each of the year of each country, the corresponding value of income is assigned to the right position in a column: income.
               names_prefix = "X")        # This helps me get rid of "X" in front of year value.


# Finally I turn the income back to numeric, as well as truning values like 10.2k into 10200.
income_cha_long$income <- as.numeric(sub("k", "e3", income_cha_long$income, fixed = T))
# I also turned the year values back into numeric.
income_cha_long$year <- as.numeric(income_cha_long$year)


# Finally we call this cleaned dataset incom_tidy.
income_tidy <- income_cha_long



# life dataset are all numeric from the beginning so I directly go to pivoting it to long data form and call it life_tidy.
life_tidy <- life_raw %>% 
  pivot_longer(cols =  starts_with("X"),  
               names_to  = "year", 
               values_to = "life", 
               names_prefix = "X")
life_tidy$year <- as.numeric(life_tidy$year)



life_tidy2 <- filter(life_tidy, year <= 2049)
# Now we subset the life expectancy dataset such that the year is from 1799 to 2049, matching the
# year scope of our income dataset.

# Now we join the two tidy datasets, keeping every row of each datasets by using inner_join
life_vs_income <- left_join(income_tidy, life_tidy2, by = "country")


# Since the key "country" is duplicated in both datasets we get all possible combinations.
# We only want to keep the ones where the year matches.
life_vs_income2 <- life_vs_income %>% 
  filter(year.x == year.y)

life_vs_income_tidy <- life_vs_income2[,-4]
life_vs_income_tidy <- rename(life_vs_income_tidy, year = year.x) # rename a column to make it look clean.

head(life_vs_income_tidy)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# We hereby have a aggregated dataset of income and life expectancy in tidy form.




  
  
  
  












