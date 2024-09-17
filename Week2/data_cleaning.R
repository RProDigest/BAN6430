################################################################################
# Name: Mubanga Nsofu                                                          #
# Institution: Nexford University (NXU)                                        #
# Date : 9th September 2024                                                    #
# Course: BAN 6430 (Data Modeling & Mining)                                    #                  
# Program: Master of Science Data Analytics (MSDA)                             #
# Lecturer: Professor Rajan Thapaliya                                          #
# Assignment: 2 (Identifying Inconsistencies and Cleaning Dataset)             #
################################################################################



# 1.0 INSTALL THE NECESSARY PACKAGES----

if (!require(pacman)) {
  install.packages("pacman") # Check if package manager is installed 
}

# Use pacman to manage the installation and loading of tidyverse & openxlsx

pacman::p_load(tidyverse, # Meta package for common data science tasks
               openxlsx, # Export  dataframe to excel
               DataExplorer, # For Exploratory Data Analysis (EDA)
               here, # Creates paths relative to the top level directory
               patchwork, # Combining plots
               janitor, #Data cleaning
               mice,# Multivariate Imputation via Chained Equations for Missing Data
               VIM, # Visualization of Missing Data
               ggstatsplot, # Advanced statistical plots
               ggsci, # color palettes
               magrittr # advanced pipe functions
               
)


# 2.0 LOAD THE DATASET (adjust the file path if necessary)--------------


file_path<- here("dataset","dataset.txt") #Use here to build a relative path where 
# your dataset lives

# Load the dataset and handle error if file not found

df <- tryCatch({
  read_csv(file_path, col_names = TRUE) # Attempt to read the dataset
}, error = function(e) {
  stop("Error: The dataset could not be loaded. Please check the file path or file format.")
})



# 3.0 EXPLORE THE DATASET USING DataExplorer and mice PACKAGES----------------

# Explore missing values visually

# Use DataExplorer

df %>%
  DataExplorer::plot_missing() -> a

df %>%
  DataExplorer::plot_intro() -> b # Quickly plot introduction

b + a

ggsave("combined.svg")

df %>% 
  create_report()

# 4.0 FIXING DATA ISSUES----------------

# 4.1. Handling missing values in various ways

# For numerical variables, we have opted for a Random Forest approach that uses
# an ensemble model
# For categorical variables, we opt for polytomous logistic regression


# Convert the Advertising agency to a factor so that we can impute using polytomous 
# logistic regression . This is a method used for imputing missing values for
# categorical variables

df$AdvertisingAgency %<>% as.factor()

# convert the date to a numeric so that we can impute using random forest

df$DatePurchased %<>% as.factor()

# Convert products to a factor so that we can impute using polytomous 
# logistic regression . This is a method used for imputing missing values for
# categorical variables


df$Product %<>% as.factor()


# We then can use the mice package to impute the mssing values

df %>%
  mice(
    seed = 2024,
    method = c("", "", "rf", "polyreg", "rf", "rf", "rf", "polyreg"),
    maxit = 20
  ) -> df_imputed


df_imputed %>% 
  complete(1)-> df_combined_data # Combines the five datasets into one

# Covert the date column from a numeric back to a date object


df_combined_data$DatePurchased %<>% as.Date()


# Deal with missing customer names

df_combined_data <- df_combined_data %>%
  mutate(custName = ifelse(is.na(custName), "Unknown Customer", custName))

df_combined_data 


# Clean column names using Janitor package

df_combined_data %>% 
  janitor::clean_names()-> df_combined_data


# 4.5 Removing duplicate records if any

# we can use dplyr to check

df_combined_data <- df_combined_data %>% dplyr::distinct()

# 5.5 Arrange transactions by date

df_combined_data <-  df_combined_data %>% arrange(date_purchased)



# 5.0 ANALYZING THE DATASET POST FIXING DATA QUALITY ISSUES -------------

# Compare distributions before and after imputation


df %>% 
  mutate(scenario = "Before Imputation") %>% 
  janitor::clean_names()-> df


df$advertising_agency %<>% as.factor()
df$product %<>% as.factor()
df$date_purchased %<>% as.Date()

df_combined_data %>% 
  mutate(scenario = "After Imputation") -> df_combined_data


df %>% 
  bind_rows(df_combined_data)-> merged_dataset

merged_dataset %>% 
  ggbetweenstats(
    x = scenario,
    y = age,
    title = "Distribution of Age | After Imputation versus Before Imputation ",
    package = "ggsci",
    palette = "default_ucscgb"
  )


# Plot the distribution of Product before and after imputation

merged_dataset %>% 
  ggplot(aes(product, fill = scenario))+
  geom_bar()+
  facet_wrap(~ scenario)+
  theme_minimal()+
  scale_fill_manual(values = c("midnightblue","gray"))

  
# Plot the distribution of price before and after imputation

merged_dataset %>% 
  ggbetweenstats(
    x = scenario,
    y = price,
    title = "Distribution of Price | After Imputation versus Before Imputation ",
    package = "ggsci",
    palette = "default_ucscgb"
  )


# Plot the distribution of rating before and after imputation

merged_dataset %>% 
  ggbetweenstats(
    x = scenario,
    y = rating_of_product,
    title = "Distribution of Rating of Product | After Imputation versus Before Imputation ",
    package = "ggsci",
    palette = "default_ucscgb"
  )



# Plot the distribution of advertising agency before and after imputation

merged_dataset %>% 
  ggplot(aes(advertising_agency, fill = scenario))+
  geom_bar()+
  facet_wrap(~ scenario)+
  theme_minimal()+
  scale_fill_manual(values = c("midnightblue","gray"))



# 6.0 SAVING THE CLEANED DATA TO AN EXCEL FILE ------

openxlsx::write.xlsx(df_combined_data, here("output","cleaned_dataset.xlsx"))

