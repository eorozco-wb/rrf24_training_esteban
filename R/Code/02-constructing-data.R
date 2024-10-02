# Reproducible Research Fundamentals 
# 02. Data construction
# RRF - 2024 - Construction

# Preliminary - Load Data ----
# Load household-level data (HH)
hh_data <- read_dta(file.path(data_path, "Intermediate/TZA_CCT_HH.dta"))

# Load HH-member data
mem_data <- read_dta(file.path(data_path, "Intermediate/TZA_CCT_HH_mem.dta"))

# Load secondary data
secondary_data <- read_dta(file.path(data_path, "Intermediate/TZA_amenity_tidy.dta"))

# Exercise 1: Plan construction outputs ----
# Plan the following outputs:
# 1. Area in acres. - hh
# 2. Household consumption (food and nonfood) in USD. -hh
# 3. Any HH member sick. - member
# 4. Any HH member can read or write.
# 5. Average sick days.
# 6. Total treatment cost in USD.
# 7. Total medical facilities. - secondary amenities

# Exercise 2: Standardize conversion values ----
# Define standardized conversion values:
# 1. Conversion factor for acres.
# 2. USD conversion factor.

hec_to_acr <- 2.47
usd <- .00037

# Data construction: Household (HH) ----
# Instructions:
# 1. Convert farming area to acres where necessary.
# 2. Convert household consumption for food and nonfood into USD.
 # area in acres 

hh_data <- hh_data %>% 
    mutate(area_acre = case_when (
        ar_unit ==1  ~ ar_farm,
        ar_unit == 2 ~ar_farm * hec_to_acr
    )) %>% 
    mutate(area_acre = replace_na(area_acre,0)) %>% 
    set_variable_labels(area_acre= "Area farmed in acres")


# Exercise 3: Handle outliers ----
# you can use custom Winsorization function to handle outliers.
winsor_function <- function(dataset, var, min = 0.00, max = 0.95) {
    var_sym <- sym(var)
    
    percentiles <- quantile(
        dataset %>% pull(!!var_sym), probs = c(min, max), na.rm = TRUE
    )
    
    min_percentile <- percentiles[1]
    max_percentile <- percentiles[2]
    
    dataset %>%
        mutate(
            !!paste0(var, "_w") := case_when(
                is.na(!!var_sym) ~ NA_real_,
                !!var_sym <= min_percentile ~ percentiles[1],
                !!var_sym >= max_percentile ~ percentiles[2],
                TRUE ~ !!var_sym
            )
        )
}

# Tips: Apply the Winsorization function to the relevant variables.
# Create a list of variables that require Winsorization and apply the function to each.
win_vars <- c("area_acre","food_cons","nonfood_cons")

for (var in win_vars) {
    hh_data <- winsor_function(hh_data, var)
}

# Exercise 4.1: Create indicators at household level ----
# Instructions:
# Collapse HH-member level data to HH level.
# Plan to create the following indicators:
# 1. Any member was sick.
# 2. Any member can read/write.
# 3. Average sick days.
# 4. Total treatment cost in USD.

mem_data_collapsed <- mem_data %>% 
    group_by(hhid) %>% 
    summarise(
        sick =max(sick, na.rm=TRUE),
        read =max(read, na.rm=TRUE),
        days_sick = if_else(all(is.na(days_sick)), NA_real_, mean(days_sick, na.rm= TRUE)),
        treat_cost_usd = if_else (all(is.na(treat_cost)), NA_real_, sum(treat_cost, na.rm=TRUE))*usd)


# Exercise 4.2: Data construction: Secondary data ----
# Instructions:
# Calculate the total number of medical facilities by summing relevant columns.
# Apply appropriate labels to the new variables created.

secondary_data <- secondary_data %>% 
    mutate(tot_med_facil = rowSums(select(.,n_hospital,n_clinic),
                                   na.rm=FALSE))

# Exercise 5: Merge HH and HH-member data ----
# Instructions:
# Merge the household-level data with the HH-member level indicators.
# After merging, ensure the treatment status is included in the final dataset.

# Exercise 6: Save final dataset ----
# Instructions:
# Only keep the variables you will use for analysis.
# Save the final dataset for further analysis.
# Save both the HH dataset and the secondary data.

# Tip: Ensure all variables are correctly labeled 

