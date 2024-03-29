# Load required libraries
library(dplyr)
library(tidyr)
library(stringr)

# Step 1: Read in the CSV
input_data <- read.csv("/Users/harley/Documents/Github/Trinchera_summary/2023/cleanedMerged_Forestry23_030524_2.csv")

#### TREE STATISTICS ####

# Step 2: Basal area per acre (in)
basal_area <- input_data %>%
  filter(alive_or_dead == "living", !is.na(dbh_cm_tree)) %>%
  group_by(new_plot_key) %>%
  summarise(basal_area_per_acre_in = round(sum(0.005454 * (dbh_cm_tree/2.54)^2) * 5, 2))

# Step 3: Average DBH (in)
average_dbh <- input_data %>%
  filter(alive_or_dead == "living", !is.na(dbh_cm_tree)) %>%
  group_by(new_plot_key) %>%
  summarise(average_dbh_in = round(mean(dbh_cm_tree) / 2.54, 2))

# Step 4: Average height (ft)
average_height <- input_data %>%
  filter(alive_or_dead == "living", !is.na(total_height_m_tree)) %>%
  group_by(new_plot_key) %>%
  summarise(average_height_ft = round(mean(total_height_m_tree) * 3.28084, 2))

# Step 5: Dominant tree species
dominant_tree_species <- input_data %>%
  filter(alive_or_dead == "living", size_class == "tree", !is.na(tree_species)) %>%
  group_by(new_plot_key) %>%
  summarise(dominant_tree_species = {
    species_counts <- table(tree_species)
    max_count <- max(species_counts)
    most_common_species <- names(species_counts)[species_counts == max_count]
    percent_frequency <- max_count / length(tree_species) * 100
    species_name <- switch(most_common_species[1],
                           "ABCO" = "White fir",
                           "ABLA" = "Subalpine fir",
                           "ACGL" = "Rocky Mountain maple",
                           "JUSC" = "Rocky Mountain juniper",
                           "PIED" = "Colorado pinyon",
                           "PIEN" = "Engelmann spruce",
                           "PIFL" = "Limber pine",
                           "PIPO" = "Ponderosa pine",
                           "POTR" = "Aspen",
                           "PSME" = "Douglas fir")
    if (percent_frequency <= 50) {
      second_most_common_species <- names(sort(table(tree_species), decreasing = TRUE))[2]
      second_max_count <- table(tree_species)[second_most_common_species]
      second_percent_frequency <- second_max_count / length(tree_species) * 100
      second_species_name <- switch(second_most_common_species,
                                    "ABCO" = "White fir",
                                    "ABLA" = "Subalpine fir",
                                    "ACGL" = "Rocky Mountain maple",
                                    "JUSC" = "Rocky Mountain juniper",
                                    "PIED" = "Colorado pinyon",
                                    "PIEN" = "Engelmann spruce",
                                    "PIFL" = "Limber pine",
                                    "PIPO" = "Ponderosa pine",
                                    "POTR" = "Aspen",
                                    "PSME" = "Douglas fir")
      percent_frequency <- format(round(percent_frequency, 2), nsmall = 2)
      second_percent_frequency <- format(round(second_percent_frequency, 2), nsmall = 2)
      paste(species_name, " (", percent_frequency, "%), ", 
            second_species_name, " (", second_percent_frequency, "%)", sep = "")
    } else {
      percent_frequency <- format(round(percent_frequency, 2), nsmall = 2)
      paste(species_name, " (", percent_frequency, "%)", sep = "")
    }
  })

#### REGENERATION STATISTICS ####

# Step 6: Regeneration presence (Y/N)
regeneration_presence <- input_data %>%
  filter(alive_or_dead == "living", !is.na(size_class)) %>%
  group_by(new_plot_key) %>%
  summarise(regeneration_presence = ifelse(any(size_class == "sapling" | size_class == "seedling"), "Regeneration present", "Regeneration absent"))

# Step 7: Seedlings per acre
seedlings_per_acre <- input_data %>%
  filter(size_class == "seedling", !is.na(number_of_seedlings)) %>%
  group_by(new_plot_key) %>%
  summarise(seedlings_per_acre = sum(number_of_seedlings, na.rm = TRUE) * 50) %>%
  right_join(distinct(select(input_data, new_plot_key)), by = "new_plot_key") %>%
  mutate(seedlings_per_acre = if_else(is.na(seedlings_per_acre), 0, seedlings_per_acre))

#### DAMAGE STATISTICS ####

# Step 8: Insect presence (Y/N)
insect_damage_presence <- input_data %>%
  filter(!is.na(insect_presence)) %>%
  group_by(new_plot_key) %>%
  summarise(insect_damage_presence = ifelse(any(insect_presence == 1), "Insect damage present", "Insect damage absent"))

# Step 9: Browse presence (Y/N)
browse_damage_presence <- input_data %>%
  filter(!is.na(browse_presence)) %>%
  group_by(new_plot_key) %>%
  summarise(browse_damage_presence = ifelse(any(browse_presence == 1), "Browse present", "Browse absent"))

# Step 10: List of damage types
list_damage <- input_data %>%
  mutate(what_if_any_disease_damage_present = tolower(what_if_any_disease_damage_present)) %>%
  mutate(what_if_any_disease_damage_present = gsub("mechanicaldamamge", "mechanicaldamage", what_if_any_disease_damage_present)) %>%
  mutate(what_if_any_disease_damage_present = gsub("woodpeckers", "woodpecker", what_if_any_disease_damage_present)) %>%
  separate_rows(what_if_any_disease_damage_present, sep = ",") %>%
  mutate(what_if_any_disease_damage_present = trimws(what_if_any_disease_damage_present)) %>%
  mutate(what_if_any_disease_damage_present = case_when(
    what_if_any_disease_damage_present == "barkbeetle" ~ "bark beetle",
    what_if_any_disease_damage_present == "browse" ~ "browse",
    what_if_any_disease_damage_present == "canker" ~ "canker",
    what_if_any_disease_damage_present == "douglasfiradelgid" ~ "Douglas fir adelgid",
    what_if_any_disease_damage_present == "fungus" ~ "fungus",
    what_if_any_disease_damage_present == "mistletoe" ~ "mistletoe",
    what_if_any_disease_damage_present == "galls" ~ "galls",
    what_if_any_disease_damage_present == "gash" ~ "gash",
    what_if_any_disease_damage_present == "mechanicaldamage" ~ "mechanical damage",
    what_if_any_disease_damage_present == "sapsucker" ~ "sapsucker",
    what_if_any_disease_damage_present == "sprucebudworm" ~ "spruce budworm",
    what_if_any_disease_damage_present == "winddamage" ~ "wind damage",
    what_if_any_disease_damage_present == "woodpecker" ~ "woodpecker",
    what_if_any_disease_damage_present == "rot" ~ "rot",
    TRUE ~ NA_character_
  )) %>%
  distinct(new_plot_key, what_if_any_disease_damage_present) %>%
  group_by(new_plot_key) %>%
  summarise(list_damage = if_else(all(what_if_any_disease_damage_present %in% c("n", "none", NA)), "None", paste(sort(na.omit(what_if_any_disease_damage_present)), collapse = ", "))) %>%
  mutate(list_damage = str_to_sentence(list_damage, locale="en")) %>%
  mutate(list_damage = gsub("douglas", "Douglas", list_damage))

#Step 11: Dominant regeneration species


# Merge all outputs into one dataframe
output_statistics <- Reduce(function(x, y) merge(x, y, by = "new_plot_key", all = TRUE), 
                            list(basal_area, average_dbh, average_height, dominant_tree_species, 
                                 regeneration_presence, seedlings_per_acre,
                                 insect_damage_presence, browse_damage_presence, list_damage, number_of_saplings_and_seedlings))

# Write output to CSV
write.csv(output_statistics, file = "/Users/harley/Documents/output_statistics.csv", row.names = FALSE)



# Step 11: Adult live tree count
adult_live_tree_count <- input_data %>%
  filter(alive_or_dead == "living", size_class == "tree") %>%
  group_by(new_plot_key) %>%
  summarise(adult_live_tree_count = n())

write.csv(adult_live_tree_count, file = "/Users/harley/Documents/adult_live_tree_count.csv", row.names = FALSE)