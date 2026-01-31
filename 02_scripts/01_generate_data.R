


# -------------------------------
# Synthetic Corn Yield Generator
# Units: bushels per acre (bu/ac)
# -------------------------------

set.seed(123)

library(dplyr)

# Experimental design
sites   <- paste0("Site", 1:6)
years   <- 2022:2025
hybrids <- paste0("H", 1:10)
fung    <- c("None", "Fungicide_A", "Fungicide_B")
reps    <- 1:4

design <- expand.grid(
  site = sites,
  year = years,
  hybrid = hybrids,
  fungicide = fung,
  rep = reps
)

# Baseline yield (bu/ac)
grand_mean <- 185  

# Random effects
hybrid_eff <- rnorm(length(hybrids), 0, 6)
names(hybrid_eff) <- hybrids

fung_eff <- c(
  None = 0,
  Fungicide_A = 6,
  Fungicide_B = 4
)

site_eff <- rnorm(length(sites), 0, 10)
names(site_eff) <- sites

year_eff <- rnorm(length(years), 0, 5)
names(year_eff) <- years

# Generate yield
data <- design %>%
  rowwise() %>%
  mutate(
    yield_bu_ac =
      grand_mean +
      hybrid_eff[hybrid] +
      fung_eff[fungicide] +
      site_eff[site] +
      year_eff[as.character(year)] +
      rnorm(1, 0, 12)
  ) %>%
  ungroup()

# Keep yields realistic
data$yield_bu_ac <- pmax(data$yield_bu_ac, 60)

# Preview
head(data)
summary(data$yield_bu_ac)

# Save
write.csv(data, "corn_fungicide_trial_yield_bu_ac.csv", row.names = FALSE)

yield ~ hybrid * product + (1 | site/year/block)
yield ~ hybrid * product + (1 | site) + (1 | year) + (1 | site:year)

hybrid | product


field_trial_performance/
  data/
  raw/
  processed/
  scripts/
  01_generate_data.R
02_clean.R
03_model.R
04_plots.R
outputs/
  tables/
  figures/
  README.md







Linear mixed model

Hybrid BLUPs

Fungicide response estimates

Interaction checks

Visualization

Simple recommendation logic



