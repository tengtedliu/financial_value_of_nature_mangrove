library(here)
library(dplyr)
library(ggplot2)

###############################[Run Functions]##################################

df_mangrove_transects <- read.csv(here("R/mangroves/data","mangrove_transect_intersect_all.csv")) %>%
  dplyr::select(c(-OID_, -x_transect_terminus, -y_transect_terminus))

df_mangrove_transects %>% colnames()

df_processed <- df_mangrove_transects %>% 
  mutate(dist_start = sqrt((x_house - x_start)^2 + (y_house - y_start)^2),
         dist_end = sqrt((x_house - x_end)^2 + (y_house - y_end)^2),
         min_dist = pmin(dist_start, dist_end)) %>%
  group_by(house_id) %>%
  filter(min_dist == min(min_dist)) %>%
  ungroup()

df_processed %>% dplyr::select(c(house_id, mangrove_width_meters)) %>%
  write.csv(here("R/mangroves/data","mangrove_refresh_0808_clean_processed.csv"))

summary(df_processed$mangrove_width_meters)
hist(df_processed$mangrove_width_meters)

df_processed_log <- df_processed %>% mutate(mangrove_width_log=log(mangrove_width_meters))

ab <- log(df_processed$mangrove_width)

df_processed %>% nrow()
# Filter the data
df_filtered <- df_processed %>%
  filter(mangrove_width < 1000)
df_log_filtered <- log(df_processed)
# Plot histogram with ggplot2
df_processed_log %>%
  # filter(mangrove_width < 500)%>%
  ggplot( aes(x = mangrove_width_log)) +
  geom_histogram(fill = "blue", color = "black") +  # Adjust binwidth as needed
  labs(x = "Mangrove Width (m)", y = "Count") +
  theme_minimal()
