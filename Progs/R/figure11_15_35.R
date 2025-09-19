# Note: this script calculates the delta pVaR at 15% and 35% loss threshold 
# Step 1. import preprocessed data (e.g., pricediff_ivan_reshape.csv)
# Step 2. calculate empirical CDF for each county and mangrove condition
# Step 3. plot the ridgeplot with shaded area for VaR effect, automatically incorporating the empirical CDF values

rm(list=ls())

library(haven)
#install.packages("ggridges")
library(ggridges)
library(ggplot2)
library(dplyr)
library(viridis)  # Example color palette library


setwd("./Analysis/Results/Spreadsheets")


######graph 1: Hurricane Ivan Price Dispersion Ridgeplot

df_mang <- read.csv("../../Data/pricediff_ivan_update_newbenchmark.csv", header=TRUE, sep=",")

df_mang_filtered <- df_mang %>% filter(pricediff_calib <= 200 & pricediff_calib >= -100)

# Modify county names to add * for selected counties
df_mang_filtered <- df_mang_filtered %>%
  mutate(fips_name = ifelse(fips_name %in% c("Miami", "Hillsborough", "Collier"), paste0(fips_name, "*"), fips_name))

# Order the county names in reverse alphabetical order  
df_mang_filtered$fips_name <- factor(df_mang_filtered$fips_name,
                                     levels = rev(sort(unique(df_mang_filtered$fips_name))))



# Step 2. calculate empirical CDF
#define a function to caclulate empirical CDF
  #ecdf is a built-in function in R
calculate_cdf_for_condition <- function(data, fips_name_condition, mangrove_condition, threshold) {
  # Filter the data based on the specified conditions
  filtered_data <- data[data$fips_name == fips_name_condition & data$mangrove == mangrove_condition, ]
  # Calculate the CDF for the filtered data
  cdf <- ecdf(filtered_data$pricediff_calib)
  # Calculate and return the CDF value at the specified threshold
  return(cdf(threshold))
}



# Calculate the CDF for the specified conditions
  #for example, 'df_value_1y' calculate the CDF for the condition of "Pinellas" and "Yes" (mangrove within 2km)'
  # ----------------- First set: threshold -15 -----------------

cdf_value_7y <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "Yes", -15)
# print(cdf_value_1y)
cdf_value_7n <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "No", -15)
print(cdf_value_7y - cdf_value_7n)

cdf_value_6y <- calculate_cdf_for_condition(df_mang_filtered, "Miami*", "Yes", -15)
cdf_value_6n <- calculate_cdf_for_condition(df_mang_filtered, "Miami*", "No", -15)
print(cdf_value_6y - cdf_value_6n)

cdf_value_5y <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "Yes", -15)
cdf_value_5n <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "No", -15)
print(cdf_value_5y - cdf_value_5n)

cdf_value_4y <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "Yes", -15)
cdf_value_4n <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "No", -15)
print(cdf_value_4y - cdf_value_4n)

cdf_value_3y <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "Yes", -15)
cdf_value_3n <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "No", -15)
print(cdf_value_3y - cdf_value_3n)

cdf_value_2y <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "Yes", -15)
cdf_value_2n <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "No", -15)
print(cdf_value_2y - cdf_value_2n)


cdf_value_1y <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "Yes", -15)
cdf_value_1n <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "No", -15)
print(cdf_value_1y - cdf_value_1n)


cdf_results_ivan_15 <- data.frame(
  County = c("Pinellas", "Miami*", "Manatee", "Lee", 
             "Hillsborough*", "Collier*", "Charlotte"),
  CDF_Value = c(
    cdf_value_7y - cdf_value_7n,
    cdf_value_6y - cdf_value_6n,
    cdf_value_5y - cdf_value_5n,
    cdf_value_4y - cdf_value_4n,
    cdf_value_3y - cdf_value_3n,
    cdf_value_2y - cdf_value_2n,
    cdf_value_1y - cdf_value_1n
  )
)

# ----------------- Second set: threshold -35 -----------------

cdf_value_7y <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "Yes", -35)
# print(cdf_value_1y)
cdf_value_7n <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "No", -35)
print(cdf_value_7y - cdf_value_7n)

cdf_value_6y <- calculate_cdf_for_condition(df_mang_filtered, "Miami*", "Yes", -35)
cdf_value_6n <- calculate_cdf_for_condition(df_mang_filtered, "Miami*", "No", -35)
print(cdf_value_6y - cdf_value_6n)

cdf_value_5y <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "Yes", -35)
cdf_value_5n <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "No", -35)
print(cdf_value_5y - cdf_value_5n)

cdf_value_4y <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "Yes", -35)
cdf_value_4n <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "No", -35)
print(cdf_value_4y - cdf_value_4n)

cdf_value_3y <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "Yes", -35)
cdf_value_3n <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "No", -35)
print(cdf_value_3y - cdf_value_3n)

cdf_value_2y <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "Yes", -35)
cdf_value_2n <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "No", -35)
print(cdf_value_2y - cdf_value_2n)


cdf_value_1y <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "Yes", -35)
cdf_value_1n <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "No", -35)
print(cdf_value_1y - cdf_value_1n)



cdf_results_ivan_35 <- data.frame(
  County = c("Pinellas", "Miami*", "Manatee", "Lee", 
             "Hillsborough*", "Collier*", "Charlotte"),
  CDF_Value = c(
    cdf_value_7y - cdf_value_7n,
    cdf_value_6y - cdf_value_6n,
    cdf_value_5y - cdf_value_5n,
    cdf_value_4y - cdf_value_4n,
    cdf_value_3y - cdf_value_3n,
    cdf_value_2y - cdf_value_2n,
    cdf_value_1y - cdf_value_1n
  )
)

# ----------------- Write both to the same Excel -----------------
write.xlsx(
  list(
    "Ivan pvar Results 15%" = cdf_results_ivan_15,
    "Ivan pvar Results 35%" = cdf_results_ivan_35
  ),
  file = "pvar_results_ivan.xlsx",
  overwrite = TRUE
)





######graph 2: Hurricane Sandy Price Dispersion Ridgeplot
rm(list=ls())

df_mang <- read.csv("../../Data/pricediff_sandy2_b_update_newbenchmark.csv", header=TRUE, sep=",")


##filter out values greater than 200
df_mang_filtered <- df_mang %>% filter(pricediff_calib <= 200 & pricediff_calib >= -100)

df_mang_filtered$fips_name <- factor(df_mang_filtered$fips_name, 
                                     levels = rev(sort(unique(df_mang_filtered$fips_name))))


# Step 2. calculate empirical CDF
#define a function to caclulate empirical CDF
  #ecdf is a built-in function in R
calculate_cdf_for_condition <- function(data, fips_name_condition, mangrove_condition, threshold) {
  # Filter the data based on the specified conditions
  filtered_data <- data[data$fips_name == fips_name_condition & data$mangrove == mangrove_condition, ]
  # Calculate the CDF for the filtered data
  cdf <- ecdf(filtered_data$pricediff_calib)
  # Calculate and return the CDF value at the specified threshold
  return(cdf(threshold))
}

  # ----------------- First set: threshold -15 -----------------

# Calculate the CDF for the specified conditions
  #for example, 'df_value_1y' calculate the CDF for the condition of "Pinellas" and "Yes" (mangrove within 2km)
cdf_value_7y <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "Yes", -15)
print(cdf_value_7y)
cdf_value_7n <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "No", -15)
print(cdf_value_7n)
print(cdf_value_7y - cdf_value_7n)

cdf_value_6y <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "Yes", -15)
print(cdf_value_6y)

cdf_value_6n <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "No", -15)
print(cdf_value_6n)
print(cdf_value_6y - cdf_value_6n)

cdf_value_5y <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "Yes", -15)
cdf_value_5n <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "No", -15)
print(cdf_value_5y - cdf_value_5n)

cdf_value_4y <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "Yes", -15)
cdf_value_4n <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "No", -15)
print(cdf_value_4y - cdf_value_4n)

cdf_value_3y <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough", "Yes", -15)
cdf_value_3n <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough", "No", -15)
print(cdf_value_3y - cdf_value_3n)

cdf_value_2y <- calculate_cdf_for_condition(df_mang_filtered, "Collier", "Yes", -15)
cdf_value_2n <- calculate_cdf_for_condition(df_mang_filtered, "Collier", "No", -15)
print(cdf_value_2y - cdf_value_2n)

cdf_value_1y <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "Yes", -15)
print(cdf_value_1y)
cdf_value_1n <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "No", -15)
print(cdf_value_1n)
print(cdf_value_1y - cdf_value_1n)


cdf_results_sandy_15 <- data.frame(
  County = c("Pinellas", "Miami", "Manatee", "Lee", 
             "Hillsborough", "Collier", "Charlotte"),
  CDF_Value = c(
    cdf_value_7y - cdf_value_7n,
    cdf_value_6y - cdf_value_6n,
    cdf_value_5y - cdf_value_5n,
    cdf_value_4y - cdf_value_4n,
    cdf_value_3y - cdf_value_3n,
    cdf_value_2y - cdf_value_2n,
    cdf_value_1y - cdf_value_1n
  )
)


# ----------------- Second set: threshold -35 -----------------

cdf_value_7y <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "Yes", -35)
print(cdf_value_7y)
cdf_value_7n <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "No", -35)
print(cdf_value_7n)
print(cdf_value_7y - cdf_value_7n)

cdf_value_6y <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "Yes", -35)
print(cdf_value_6y)

cdf_value_6n <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "No", -35)
print(cdf_value_6n)
print(cdf_value_6y - cdf_value_6n)

cdf_value_5y <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "Yes", -35)
cdf_value_5n <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "No", -35)
print(cdf_value_5y - cdf_value_5n)

cdf_value_4y <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "Yes", -35)
cdf_value_4n <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "No", -35)
print(cdf_value_4y - cdf_value_4n)

cdf_value_3y <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough", "Yes", -35)
cdf_value_3n <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough", "No", -35)
print(cdf_value_3y - cdf_value_3n)

cdf_value_2y <- calculate_cdf_for_condition(df_mang_filtered, "Collier", "Yes", -35)
cdf_value_2n <- calculate_cdf_for_condition(df_mang_filtered, "Collier", "No", -35)
print(cdf_value_2y - cdf_value_2n)

cdf_value_1y <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "Yes", -35)
print(cdf_value_1y)
cdf_value_1n <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "No", -35)
print(cdf_value_1n)
print(cdf_value_1y - cdf_value_1n)


cdf_results_sandy_35 <- data.frame(
  County = c("Pinellas", "Miami", "Manatee", "Lee", 
             "Hillsborough", "Collier", "Charlotte"),
  CDF_Value = c(
    cdf_value_7y - cdf_value_7n,
    cdf_value_6y - cdf_value_6n,
    cdf_value_5y - cdf_value_5n,
    cdf_value_4y - cdf_value_4n,
    cdf_value_3y - cdf_value_3n,
    cdf_value_2y - cdf_value_2n,
    cdf_value_1y - cdf_value_1n
  )
)

# ----------------- Write both to the same Excel -----------------
write.xlsx(
  list(
    "Sandy pvar Results 15%" = cdf_results_sandy_15,
    "Sandy pvar Results 35%" = cdf_results_sandy_35
  ),
  file = "pvar_results_sandy.xlsx",
  overwrite = TRUE
)






######graph 3: Hurricane Irma Price Dispersion Ridgeplot

rm(list=ls())

df_mang <- read.csv("../../Data/pricediff_irma2_update_newbenchmark.csv", header=TRUE, sep=",")

##filter out values greater than 200
df_mang_filtered <- df_mang %>% filter(pricediff_calib <= 200 & pricediff_calib >= -100)

# Modify county names to add * for selected counties
df_mang_filtered <- df_mang_filtered %>%
  mutate(fips_name = ifelse(fips_name %in% c("Charlotte", "Lee","Hillsborough", "Collier"), paste0(fips_name, "*"), fips_name))

# Order the county names in reverse alphabetical order  
df_mang_filtered$fips_name <- factor(df_mang_filtered$fips_name,
                                     levels = rev(sort(unique(df_mang_filtered$fips_name))))


# Step 2. calculate empirical CDF
#define a function to caclulate empirical CDF
  #ecdf is a built-in function in R
calculate_cdf_for_condition <- function(data, fips_name_condition, mangrove_condition, threshold) {
  # Filter the data based on the specified conditions
  filtered_data <- data[data$fips_name == fips_name_condition & data$mangrove == mangrove_condition, ]
  # Calculate the CDF for the filtered data
  cdf <- ecdf(filtered_data$pricediff_calib)
  # Calculate and return the CDF value at the specified threshold
  return(cdf(threshold))
}

  # ----------------- First set: threshold -15 -----------------

# Calculate the CDF for the specified conditions
  #for example, 'df_value_1y' calculate the CDF for the condition of "Pinellas" and "Yes" (mangrove within 2km)
cdf_value_7y <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "Yes", -15)
print(cdf_value_7y)
cdf_value_7n <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "No", -15)
print(cdf_value_7y - cdf_value_7n)


cdf_value_6y <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "Yes", -15)
# print(cdf_value_2y)

cdf_value_6n <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "No", -15)
# print(cdf_value_2n)
print(cdf_value_6y - cdf_value_6n)


cdf_value_5y <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "Yes", -15)
cdf_value_5n <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "No", -15)
print(cdf_value_5y - cdf_value_5n)

cdf_value_4y <- calculate_cdf_for_condition(df_mang_filtered, "Lee*", "Yes", -15)
cdf_value_4n <- calculate_cdf_for_condition(df_mang_filtered, "Lee*", "No", -15)
print(cdf_value_4y - cdf_value_4n)

cdf_value_3y <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "Yes", -15)
cdf_value_3n <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "No", -15)
print(cdf_value_3y - cdf_value_3n)

cdf_value_2y <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "Yes", -15)
cdf_value_2n <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "No", -15)
print(cdf_value_2y - cdf_value_2n)

cdf_value_1y <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte*", "Yes", -15)
cdf_value_1n <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte*", "No", -15)
print(cdf_value_1y - cdf_value_1n)




cdf_results_irma_15 <- data.frame(
  County = c("Pinellas", "Miami", "Manatee", "Lee*", 
             "Hillsborough*", "Collier*", "Charlotte*"),
  CDF_Value = c(
    cdf_value_7y - cdf_value_7n,
    cdf_value_6y - cdf_value_6n,
    cdf_value_5y - cdf_value_5n,
    cdf_value_4y - cdf_value_4n,
    cdf_value_3y - cdf_value_3n,
    cdf_value_2y - cdf_value_2n,
    cdf_value_1y - cdf_value_1n
  )
)



cdf_value_7y <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "Yes", -35)
print(cdf_value_7y)
cdf_value_7n <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "No", -35)
print(cdf_value_7y - cdf_value_7n)


cdf_value_6y <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "Yes", -35)
# print(cdf_value_2y)

cdf_value_6n <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "No", -35)
# print(cdf_value_2n)
print(cdf_value_6y - cdf_value_6n)


cdf_value_5y <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "Yes", -35)
cdf_value_5n <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "No", -35)
print(cdf_value_5y - cdf_value_5n)

cdf_value_4y <- calculate_cdf_for_condition(df_mang_filtered, "Lee*", "Yes", -35)
cdf_value_4n <- calculate_cdf_for_condition(df_mang_filtered, "Lee*", "No", -35)
print(cdf_value_4y - cdf_value_4n)

cdf_value_3y <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "Yes", -35)
cdf_value_3n <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough*", "No", -35)
print(cdf_value_3y - cdf_value_3n)

cdf_value_2y <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "Yes", -35)
cdf_value_2n <- calculate_cdf_for_condition(df_mang_filtered, "Collier*", "No", -35)
print(cdf_value_2y - cdf_value_2n)

cdf_value_1y <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte*", "Yes", -35)
cdf_value_1n <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte*", "No", -35)
print(cdf_value_1y - cdf_value_1n)

# ----------------- Second set: threshold -35 -----------------
cdf_results_irma_35 <- data.frame(
  County = c("Pinellas", "Miami", "Manatee", "Lee*", 
             "Hillsborough*", "Collier*", "Charlott*"),
  CDF_Value = c(
    cdf_value_7y - cdf_value_7n,
    cdf_value_6y - cdf_value_6n,
    cdf_value_5y - cdf_value_5n,
    cdf_value_4y - cdf_value_4n,
    cdf_value_3y - cdf_value_3n,
    cdf_value_2y - cdf_value_2n,
    cdf_value_1y - cdf_value_1n
  )
)

# ----------------- Write both to the same Excel -----------------
write.xlsx(
  list(
    "Ivan pvar Results 15%" = cdf_results_irma_15,
    "Ivan pvar Results 35%" = cdf_results_irma_35
  ),
  file = "pvar_results_irma.xlsx",
  overwrite = TRUE
)