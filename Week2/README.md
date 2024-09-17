
# Data Cleaning and Imputation Script

- Author: Mubanga Nsofu
- Course: BAN6420, Assignment One
- Email: mnsofu@learner.nexford.org
- Learner ID: 149050
- Institution: Nexford University
- Lecturer: Prof. Rajan Thapaliya 
- Date: 7th September 2024
- Task: Identifying Inconsistencies and Cleaning Dataset

Overview

This R script is designed to:

- Identify inconsistencies in a dataset (missing values, duplicates, etc.).
- Clean the dataset by handling missing values through imputation.
- Analyze and visualize data quality issues before and after cleaning.
- Save the cleaned dataset in an Excel file for further analysis.






Requirements:

The script uses several R packages for data processing, imputation, and visualization. Please ensure the following packages are installed and loaded via the pacman package manager:

- tidyverse: For general data science tasks (data manipulation, visualization).
- openxlsx: To export the cleaned dataset to Excel format.
- DataExplorer: For Exploratory Data Analysis (EDA).
- here: For constructing file paths relative to the project’s top-level directory.
- patchwork: To combine multiple plots into one.
- janitor: To clean column names and handle data cleaning.
- mice: For multivariate imputation of missing data.
- VIM: For visualizing missing data.
- ggstatsplot: For advanced statistical plots.
- ggsci: For aesthetic color palettes.

The script assumes your dataset is in a folder named dataset, with a file named dataset.txt. Adjust the path accordingly if needed.
## Install and load necessary packages

1. The script checks for the pacman package manager and uses it to load all necessary libraries for data manipulation, visualization, and cleaning.

``` r
if (!require(pacman)) {
  install.packages("pacman") # Check if package manager is installed 
}
```

``` r
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
               ggsci # color palettes
               
)

```


2. Load the dataset:

The dataset is loaded using read_csv(). The tryCatch() function ensures that if the file is missing or incorrectly formatted, an error message will be displayed.


3. Explore the Dataset:
Missing Values: The script visually identifies missing values in the dataset using DataExplorer::plot_missing() and VIM::matrixplot().
Generate Report: An introductory report of the dataset is created using DataExplorer::create_report().

4. Handling Data Issues:
Imputation: Missing values for numerical variables are imputed using the Random Forest method, while categorical variables are handled using polytomous logistic regression via the mice package.
Missing Names: Missing customer names are replaced with "Unknown Customer".
Duplicate Removal: Duplicate records are identified and removed using dplyr::distinct().
Date Correction: The DatePurchased field is converted back to the correct date format after imputation.
5. Post-Imputation Analysis:
Distribution Comparison: The script compares the distribution of age, price, rating_of_product, and advertising_agency before and after imputation. These are visualized using ggbetweenstats() from the ggstatsplot package and ggplot2.
6. Export the Cleaned Dataset:
The cleaned dataset is saved as an Excel file (cleaned_dataset.xlsx) in the output folder using the openxlsx::write.xlsx() function.


## How to Run:

1. Ensure all required packages are installed and loaded. You can do this by running the script from the top, which will check and install missing packages.

2. Place your dataset file (dataset.txt) in the dataset folder relative to your project’s root directory.

3. Run the script. It will:
- Load and explore the dataset.
- Handle missing values, duplicates, and inconsistencies.
- Analyze and visualize the data before and after cleaning.
- Save the cleaned dataset to an Excel file in the output folder.

## Troubleshooting

For any queries with regards to troubleshooting, please contact the author via email at mnsofu@learner.nexford.org.
## Contact Author

- [@RProDigest](https://www.github.com/RProDigest)
- [@RProDigest](https://www.twitter.com/RProDigest)

