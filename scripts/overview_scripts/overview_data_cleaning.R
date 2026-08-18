# ------------------------------------- Loading Packages and Data ------------------------------------------

# Loading Libraries
library(lubridate)
library(janitor)
library(zoo)
library(tidyverse)
library(googlesheets4)

newest_date <- "2026-08-17"

# Defining Links
pd_sizes_link = paste0("data/overview_data/", newest_date,"/lee_1960_2025.csv")
agency_locations_link = "data/misconduct_data/2024-02-27/data_agency-reference-list.csv"
pd_references_link = "data/overview_data/35158-0001-Data.rda"
spreadsheet_link <- "https://docs.google.com/spreadsheets/d/1KnkWu6mtFy8c0RJjLwXJN2ozbpWtGc-_cHFV-7IbESo/edit?gid=0#gid=0"

# Reading in data
pd_sizes <- read_csv(here::here(pd_sizes_link))
agency_locations <- read_csv(here::here(agency_locations_link))

# Loading in data
load(here::here(pd_references_link))

pd_references <- da35158.0001

# ------------------------------------- Cleaning Data Process ----------------------------------------------

# Renaming variables in the pd references
pd_references <- pd_references %>%
  select(ORI9, NAME) %>%
  rename(ori = ORI9,
         agency_full_name = NAME)


# Defining the type of agency
agency_locations <- agency_locations %>%
  filter(!(agency_slug %in% c("de-soto-so", "new-orleans-so"))) %>%
  mutate(
    agency_type = case_when(
    str_detect(tolower(agency_name), "university|college|campus") ~ "University or Campus Police",
    str_detect(tolower(agency_name), "marshal") ~ "Marshal's Office",
    str_detect(tolower(agency_name), "constable") ~ "Constable's Office",
    str_detect(tolower(agency_name), "sheriff") ~ "Sheriff's Office",
    str_detect(tolower(agency_name), "department|police department") ~ "Police Department",
    TRUE ~ "Other Law Enforcement Agency"
  ))

# Connecting department references with police department sizes
la_pd_sizes <- pd_sizes %>% 
  filter(state_abbr == "LA") %>%
  left_join(pd_references, by = "ori") %>%
  mutate(agency_name = str_trim(str_to_title(agency_full_name)),
         agency_name = ifelse(is.na(agency_name), pub_agency_name, agency_name),
         agency_name = str_replace(agency_name, "Dept|Dept.|Pd", "Police Department"),
         agency_name = str_remove(agency_name, "\\.$"))

# Filtering data for just 2025
la_pd_sizes_2025 <- la_pd_sizes %>%
  filter(data_year == "2025")

# ------------------------------------- Data Analysis Process ----------------------------------------------

# Mapping police departments
agency_map <- agency_locations %>%
  select(agency_name, agency_type, location)


# Distribution of agency types
agency_distribution <- agency_locations %>%
  count(agency_type)

# Number of sheriff offices
n_so <- agency_distribution %>%
  filter(agency_type == "Sheriff's Office") %>%
  pull(n)


# Number of officers over time
officers_over_time <- la_pd_sizes %>%
  pivot_wider(names_from = data_year, values_from = officer_ct) %>%
  select(-c("ori", "pub_agency_unit", "state_abbr",
            "division_name", "region_name", "county_name", 
            "agency_type_name", "population_group_desc", 
            "population", "male_officer_ct", "male_cilvilian_ct",
            "male_total_ct", "female_officer_ct", "female_cilvilian_ct",
            "female_total_ct", "civilian_ct",
            "total_pe_ct", "pe_ct_per_1000", "agency_full_name",
            "pub_agency_name")) %>%
  group_by(agency_name) %>%
  fill(2:67, .direction = 'updown') %>%
  distinct(agency_name, .keep_all = TRUE) %>%
  select(67:2) %>%
  arrange(agency_name)

# Mapping average number of officers per agency
average_agency_map <- la_pd_sizes_2025 %>% 
  separate_rows(county_name, sep = ", ") %>%
  group_by(county_name) %>%
  summarize(pct_per_county = mean(total_pe_ct)) %>%
  arrange(-pct_per_county) %>%
  mutate(county_name = county_name %>% str_to_title(),
         county_name = str_replace(county_name, "St ", "St. "),
         pct_per_county = paste0(round(pct_per_county,2), " Officers per Reporting Department")
         ) %>%
  filter(county_name != "Unmapped County")

top_5_parishes <- la_pd_sizes_2025 %>% 
  separate_rows(county_name, sep = ", ") %>%
  group_by(county_name) %>%
  summarize(pct_per_county = mean(total_pe_ct)) %>%
  filter(county_name != "Unmapped County") %>%
  arrange(-pct_per_county) %>%
  filter(str_to_title(county_name) != "Unmapped County") %>%
  arrange(-pct_per_county) %>%
  mutate(county_name = county_name %>% str_to_title(),
         county_name = str_replace(county_name, "St ", "St. "),
         pct_per_county = paste0(round(pct_per_county,2))
  ) %>%
  head(5)
  

# Increase in officers per law enforcement agency
ave_increase <- la_pd_sizes %>%
  filter(data_year %in% c("1960", "2025")) %>%
  group_by(data_year) %>%
  summarize(ave_officers = mean(total_pe_ct, na.rm = TRUE)) %>%
  pivot_wider(names_from = data_year, values_from = ave_officers, names_prefix = "yr_") %>%
  mutate(
    increase = yr_2025 - yr_1960,
    pct_increase = (yr_2025 - yr_1960) / yr_1960 * 100
  ) %>%
  pull(
    pct_increase
  ) %>%
  round(2)
  

# Plotting the average number of offers per 100,000 residents 
officers_per_residents <- la_pd_sizes %>%
  group_by(data_year) %>%
  summarize(ave_per_hundredthousand = 100 * median(as.numeric(pe_ct_per_1000), na.rm = TRUE)) %>%
  filter(ave_per_hundredthousand != 0)

# Number of agencies in 2025
n_agencies_2025 = length(unique(la_pd_sizes_2025$agency_name))

# Number of officers in 2025
n_officers_2025 = sum(la_pd_sizes_2025$total_pe_ct)

# Number of agencies throughout time
n_agencies = length(unique(la_pd_sizes$agency_name))

# Number of police departments
n_pd <- agency_distribution %>%
  filter(agency_type == "Police Department") %>%
  pull(n)


facts <- data.frame(
  variables = c(
    "Number of Police Departments",
    "Number of Sheriff's Offices",
    "Number of Agencies (All Years)",
    "Number of Agencies in 2025",
    "Number of Officers in 2025",
    "Average Increase"
  ),
  
  
  values = c(
    n_pd,
    n_so,
    n_agencies,
    n_agencies_2025,
    n_officers_2025,
    ave_increase
  )
)
  

# Defining sheets for the spreadsheet
# Defining sheets for the spreadsheet
sheets <- c(
  "Agency Map",
  "Agency Type Distribution",
  "Officers Over Time",
  "Average Officers per County",
  "Average Increase 1960 vs 2025",
  "Officers per 100k Residents",
  "Top 5 Parishes",
  "Facts"
)

# Defining sheet values
data_frames = list(
  agency_map,
  agency_distribution,
  officers_over_time,
  average_agency_map,
  average_increase,
  officers_per_residents,
  top_5_parishes,
  facts
)


# Adding the new sheets to the spreadsheet
for (i in seq_along(sheets)) {
  sheet_name <- sheets[i]
  data_frame <- data_frames[[i]]
  
  # Append the data frame to the sheet using the provided URL
  write_sheet(data_frame, ss = spreadsheet_link, sheet = sheet_name)
}
