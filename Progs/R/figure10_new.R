# Note: this script creates ridgeplots for Figure 10: Probability Value at Risk after Hurricanes

# Step 1: load "pricediff_sandy2_reshape.csv" (similar data structure to "pricediff_combo.csv")
# Step 2. calculate empirical CDF
# Step 3. plot the ridgeplot with shaded area for VaR effect, automatically incorporating the empirical CDF values

rm(list=ls())

library(haven)
#install.packages("ggridges")
library(ggridges)
library(ggplot2)
library(dplyr)
library(viridis)  # Example color palette library
library(ggtext)


# setwd("./Analysis/Results/Figures")
# setwd("/Users/ted/Dropbox/Apps/Overleaf/Mangrove_econ_paper/Econ_paper_writeup/Figures")



######################graph of Sandy######################

# Step 1: load "pricediff_sandy2_reshape.csv" (similar data structure to "pricediff_combo.csv")

# df <- read.csv("~/Dropbox/PhD/Research/coastal/Zillow/ztrax_FL/FL_data/salesprice_b_a_plot.csv", header=TRUE, sep=",")

# df_mang <- read.csv("~/Dropbox/PhD/Research/coastal/Zillow/ztrax_FL/FL_data/salesprice_b_a_mang.csv", header=TRUE, sep=",")
# df_mang <- read.csv("~/Dropbox/PhD/Research/coastal/Zillow/ztrax_FL/FL_data/pricediff_sandy2_b_reshape.csv", header=TRUE, sep=",")

# df_mang <- read.csv("~/Dropbox/PhD/Research/coastal/Zillow/ztrax_FL/FL_data/pricediff_sandy2_reshape.csv", header=TRUE, sep=",")

df_mang <- read.csv("../../Data/pricediff_sandy2_b_update_newbenchmark.csv", header=TRUE, sep=",")
#salesprice_b_a_plot <- read_dta("Dropbox/PhD/Research/coastal/Zillow/ztrax_FL/FL_data/salesprice_b_a_plot.dta")

# variables_to_filter <- c("pricediff_ivan_noajust", "pricediff_sandy_noajust", "pricediff_sandy2_noajust", "pricediff_irma_noajust",
#                          "pricediff_irma2_noajust", "pricediff_irma3_noajust")
# df_filtered <- df %>%
#   filter_at(vars(all_of(variables_to_filter)), all_vars(. <= 200))


##filter out values greater than 200
# df_filtered <- df %>% filter(pricediff_sandy2_noajust <= 200)
# df_mang_filtered <- df_mang %>% filter(pricediff_sandy2_mang <= 200)
df_mang_filtered <- df_mang %>% filter(pricediff_calib <= 200)
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
#for example, 'df_value_1y' calculate the CDF for the condition of "Sandy-Charlotte" and "No" mangrove
cdf_value_7n <- calculate_cdf_for_condition(df_mang_filtered, "Pinellas", "No", -25)
print(cdf_value_7n)

cdf_value_6n <- calculate_cdf_for_condition(df_mang_filtered, "Miami", "No", -25)
print(cdf_value_6n)

cdf_value_5n <- calculate_cdf_for_condition(df_mang_filtered, "Manatee", "No", -25)
print(cdf_value_5n)

cdf_value_4n <- calculate_cdf_for_condition(df_mang_filtered, "Lee", "No", -25)
print(cdf_value_4n)

cdf_value_3n <- calculate_cdf_for_condition(df_mang_filtered, "Hillsborough", "No", -25)
print(cdf_value_3n)

cdf_value_2n <- calculate_cdf_for_condition(df_mang_filtered, "Collier", "No", -25)
print(cdf_value_2n)

cdf_value_1n <- calculate_cdf_for_condition(df_mang_filtered, "Charlotte", "No", -25)
print(cdf_value_1n)


# Step 3. plot the ridgeplot with shaded area for VaR effect, automatically incorporating the empirical CDF values

###no hilighted areas
# ggplot(df_filtered, aes(x = pricediff_sandy2_noajust, y = as.factor(fips))) + geom_density_ridges(na.rm = TRUE)

# ggplot(df_mang_filtered, aes(x = pricediff_calib, y = fips_name, fill=mangrove)) + geom_density_ridges(na.rm = TRUE)


# Set the desired color palette
# my_palette <- c("gray80", "#8A9A5B")

# Create the plot with the specified color palette
# ggplot(df_mang_filtered, aes(x = pricediff_calib, y = fips_name, fill = mangrove)) +
#   geom_density_ridges(na.rm = TRUE) +
#   scale_fill_manual(values = my_palette)



######################graph of Ivan######################
df_mang_ivan <- read.csv("../../Data/pricediff_ivan_update_newbenchmark.csv", header=TRUE, sep=",")

df_mang_filtered_ivan <- df_mang_ivan %>% filter(pricediff_calib <= 200)

# Modify county names to add * for selected counties
df_mang_filtered_ivan <- df_mang_filtered_ivan %>%
  mutate(fips_name = ifelse(fips_name %in% c("Miami", "Hillsborough", "Collier"), paste0(fips_name, "*"), fips_name))


df_mang_filtered_ivan$fips_name <- factor(df_mang_filtered_ivan$fips_name, 
                                          levels = rev(sort(unique(df_mang_filtered_ivan$fips_name))))

# Calculate the CDF for the specified conditions
cdf_value_7n_ivan <- calculate_cdf_for_condition(df_mang_filtered_ivan, "Pinellas", "No", -25)
print(cdf_value_7n_ivan)

cdf_value_6n_ivan <- calculate_cdf_for_condition(df_mang_filtered_ivan, "Miami*", "No", -25)
print(cdf_value_6n_ivan)

cdf_value_5n_ivan <- calculate_cdf_for_condition(df_mang_filtered_ivan, "Manatee", "No", -25)
print(cdf_value_5n_ivan)

cdf_value_4n_ivan <- calculate_cdf_for_condition(df_mang_filtered_ivan, "Lee", "No", -25)
print(cdf_value_4n_ivan)

cdf_value_3n_ivan <- calculate_cdf_for_condition(df_mang_filtered_ivan, "Hillsborough*", "No", -25)
print(cdf_value_3n_ivan)

cdf_value_2n_ivan <- calculate_cdf_for_condition(df_mang_filtered_ivan, "Collier*", "No", -25)
print(cdf_value_2n_ivan)

cdf_value_1n_ivan <- calculate_cdf_for_condition(df_mang_filtered_ivan, "Charlotte", "No", -25)
print(cdf_value_1n_ivan)


# Set the desired color palette
# my_palette <- c("#D3D3D3", "#8A9A5B")  # Replace with your preferred color palette function and number of colors

# Create the plot with the specified color palette
# ggplot(df_mang_filtered, aes(x = pricediff_calib, y = fips_name, fill = mangrove)) +
#   geom_density_ridges(na.rm = TRUE) +
#   scale_fill_manual(values = my_palette)


###Highlight losses above 50
gg_ivan <- ggplot(df_mang_filtered_ivan, aes(x = pricediff_calib, y = fips_name)) +
  stat_density_ridges(
    geom = "density_ridges_gradient",
    na.rm = TRUE,
    quantile_lines = TRUE,
    quantiles = 2,
    vline_linetype = "dashed",  # <-- dashed median line
    ) +
  theme_ridges()

# Build ggplot and extract data
d_ivan <- ggplot_build(gg_ivan)$data[[1]]

# Add geom_ribbon for shaded area
# Add geom_ribbon for shaded area
f1_50_ivan <- 
  gg_ivan +
  geom_ribbon(
    data = transform(subset(d_ivan, x <= -25), fips_name = group),
    aes(x, ymin = ymin, ymax = ymax, group = group),
    fill = "red",
    alpha = 0.8) +
  xlab("Price Change (%) After Hurricane Ivan") + ylab(" ") +
  theme(axis.title.x = element_text(hjust = 0.5),  # Center x-axis label
        axis.title.y = element_text(hjust = 0.5)) +  # Center y-axis label
  
  # Updated y-values to match reverse alphabetical order:
  
  # Pinellas (Previously at y = 6.9, now at 0.9)
  annotate("text", x = -165, y = 0.9, label = paste0("   ", round((cdf_value_7n_ivan) * 100, 0), "%"),
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Miami (Previously at y = 5.9, now at 1.9)
  annotate("text", x = -165, y = 1.9, label = paste0("   ", round((cdf_value_6n_ivan) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Manatee (Previously at y = 4.9, now at 2.9)
  annotate("text", x = -165, y = 2.9, label = paste0("   ", round((cdf_value_5n_ivan) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Lee (Previously at y = 3.9, now at 3.9)
  annotate("text", x = -165, y = 3.9, label = paste0("   ", round((cdf_value_4n_ivan) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size =
             4, color = "black") +
  # Hillsborough (Previously at y = 2.9, now at 4.9)
  annotate("text", x = -165, y = 4.9, label = paste0("   ", round((cdf_value_3n_ivan) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Collier (Previously at y = 1.9, now at 5.9)
  annotate("text", x = -165, y = 5.9, label = paste0("   ", round((cdf_value_2n_ivan) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Charlotte (Previously at y = 0.9, now at 6.9)
  annotate("text", x = -165, y = 6.9, label = paste0("   ", round((cdf_value_1n_ivan) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black")

# png("ivan_50.png")
png("ivan_25_v2.png")
plot(f1_50_ivan)
dev.off()





######################graph of Sandy######################

###Highlight losses above 50
gg <- ggplot(df_mang_filtered, aes(x = pricediff_calib, y = fips_name)) +
  stat_density_ridges(
    geom = "density_ridges_gradient",
    na.rm = TRUE,
    quantile_lines = TRUE,
    vline_linetype = "dashed",  # <-- dashed median line
    quantiles = 2) +
  theme_ridges()

# Build ggplot and extract data
d <- ggplot_build(gg)$data[[1]]

# Add geom_ribbon for shaded area
# Add geom_ribbon for shaded area
f1_50 <- 
  gg +
  geom_ribbon(
    data = transform(subset(d, x <= -25), fips_name = group),
    aes(x, ymin = ymin, ymax = ymax, group = group),
    fill = "red",
    alpha = 0.7) +
  xlab("Price Change (%) After Hurricane Sandy") + ylab(" ") +
  theme(axis.title.x = element_text(hjust = 0.5),  # Center x-axis label
        axis.title.y = element_text(hjust = 0.5)) +  # Center y-axis label
  
  # Updated y-values to match reverse alphabetical order:
  
  # Pinellas (Previously at y = 6.9, now at 0.9)
  annotate("text", x = -170, y = 0.9, label = paste0("   ", round((cdf_value_7n) * 100, 0), "%"),
           vjust = 1, hjust = 0, size = 4, color = "black") +
  annotate("text", x = -165, y = 1.9, label = paste0("   ", round((cdf_value_6n) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Manatee (Previously at y = 4.9, now at 2.9)
  annotate("text", x = -165, y = 2.9, label = paste0("   ", round((cdf_value_5n) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Lee (Previously at y = 3.9, now at 3.9)
  annotate("text", x = -165, y = 3.9, label = paste0("   ", round((cdf_value_4n) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Hillsborough (Previously at y = 2.9, now at 4.9)
  annotate("text", x = -165, y = 4.9, label = paste0("   ", round((cdf_value_3n) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Collier (Previously at y = 1.9, now at 5.9)
  annotate("text", x = -165, y = 5.9, label = paste0("   ", round((cdf_value_2n) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Charlotte (Previously at y = 0.9, now at 6.9)
  annotate("text", x = -165, y = 6.9, label = paste0("   ", round((cdf_value_1n) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black")


# png("sandy2_50.png")
png("sandy2_25_v2.png")

plot(f1_50)
dev.off()

  
  
  


######################graph of Irma######################
df_mang_irma <- read.csv("../../Data/pricediff_irma2_update_newbenchmark.csv", header=TRUE, sep=",")

df_mang_filtered_irma <- df_mang_irma %>% filter(pricediff_calib <= 200)

# Modify county names to add * for selected counties
df_mang_filtered_irma <- df_mang_filtered_irma %>%
  mutate(fips_name = ifelse(fips_name %in% c("Charlotte", "Lee","Hillsborough", "Collier"), paste0(fips_name, "*"), fips_name))


df_mang_filtered_irma$fips_name <- factor(df_mang_filtered_irma$fips_name, 
                                     levels = rev(sort(unique(df_mang_filtered_irma$fips_name))))

# Calculate the CDF for the specified conditions
cdf_value_7n_irma <- calculate_cdf_for_condition(df_mang_filtered_irma, "Pinellas", "No", -25)
print(cdf_value_7n_irma)

cdf_value_6n_irma <- calculate_cdf_for_condition(df_mang_filtered_irma, "Miami", "No", -25)
print(cdf_value_6n_irma)

cdf_value_5n_irma <- calculate_cdf_for_condition(df_mang_filtered_irma, "Manatee", "No", -25)
print(cdf_value_5n_irma)

cdf_value_4n_irma <- calculate_cdf_for_condition(df_mang_filtered_irma, "Lee*", "No", -25)
print(cdf_value_4n_irma)

cdf_value_3n_irma <- calculate_cdf_for_condition(df_mang_filtered_irma, "Hillsborough*", "No", -25)
print(cdf_value_3n_irma)

cdf_value_2n_irma <- calculate_cdf_for_condition(df_mang_filtered_irma, "Collier*", "No", -25)
print(cdf_value_2n_irma)

cdf_value_1n_irma <- calculate_cdf_for_condition(df_mang_filtered_irma, "Charlotte*", "No", -25)
print(cdf_value_1n_irma)


# Set the desired color palette
# my_palette <- c("#D3D3D3", "#8A9A5B")  # Replace with your preferred color palette function and number of colors

# Create the plot with the specified color palette
# ggplot(df_mang_filtered, aes(x = pricediff_calib, y = fips_name, fill = mangrove)) +
#   geom_density_ridges(na.rm = TRUE) +
#   scale_fill_manual(values = my_palette)


###Highlight losses above 50
gg_irma <- ggplot(df_mang_filtered_irma, aes(x = pricediff_calib, y = fips_name)) +
  stat_density_ridges(
    geom = "density_ridges_gradient",
    na.rm = TRUE,
    quantile_lines = TRUE,
    quantiles = 2,
    vline_linetype = "dashed"  # <-- dashed median line
  ) +
  theme_ridges()

# Build ggplot and extract data
d_irma <- ggplot_build(gg_irma)$data[[1]]

# Add geom_ribbon for shaded area
# Add geom_ribbon for shaded area
f1_50_irma <- 
  gg_irma +
  geom_ribbon(
    data = transform(subset(d_irma, x <= -25), fips_name = group),
    aes(x, ymin = ymin, ymax = ymax, group = group),
    fill = "red",
    alpha = 0.7) +
  xlab("Price Change (%) After Hurricane Irma") + ylab(" ") +
  theme(axis.title.x = element_text(hjust = 0.5),  # Center x-axis label
        axis.title.y = element_text(hjust = 0.5)) +  # Center y-axis label
  
  # Updated y-values to match reverse alphabetical order:
  
  # Pinellas (Previously at y = 6.9, now at 0.9)
  annotate("text", x = -165, y = 0.9, label = paste0("   ", round((cdf_value_7n_irma) * 100, 0), "%"),
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Miami (Previously at y = 5.9, now at 1.9)
  annotate("text", x = -165, y = 1.9, label = paste0("   ", round((cdf_value_6n_irma) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Manatee (Previously at y = 4.9, now at 2.9)
  annotate("text", x = -165, y = 2.9, label = paste0("   ", round((cdf_value_5n_irma) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Lee (Previously at y = 3.9, now at 3.9)
  annotate("text", x = -165, y = 3.9, label = paste0("   ", round((cdf_value_4n_irma) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size =
           4, color = "black") +
  # Hillsborough (Previously at y = 2.9, now at 4.9)
  annotate("text", x = -165, y = 4.9, label = paste0("   ", round((cdf_value_3n_irma) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Collier (Previously at y = 1.9, now at 5.9)
  annotate("text", x = -165, y = 5.9, label = paste0("   ", round((cdf_value_2n_irma) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") +
  # Charlotte (Previously at y = 0.9, now at 6.9)
  annotate("text", x = -165, y = 6.9, label = paste0("   ", round((cdf_value_1n_irma) * 100, 0), "%"), 
           vjust = 1, hjust = 0, size = 4, color = "black") 
  
# png("irma_50.png")
png("irma_25_v2.png")
plot(f1_50_irma)

dev.off()