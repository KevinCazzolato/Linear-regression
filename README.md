# Exam Project: Statistical Models

## Overview
This repository contains the exam project titled **Statistical Models**, focusing on analyzing and modeling data from the "Tips" dataset using various statistical techniques. The goal of the project is to explore the relationship between the tipping behavior and other variables available in the dataset, applying linear regression models and evaluating their efficiency.

The project is implemented using R, and it involves exploratory data analysis, modeling, and evaluating different statistical models with normalization techniques. The final model is selected based on its statistical performance.

## Dataset
The dataset used in this project is the **"Tips"** dataset, which contains information about customer bills, tips, and other related characteristics. The dataset includes the following variables:

- **total_bill**: Total bill for the observation.
- **tip**: The tip amount (target of the analysis).
- **sex**: Gender of the customer.
- **smoker**: Whether the customer is a smoker.
- **day**: Day of the week.
- **time**: Meal time (Lunch or Dinner).
- **size**: Number of people at the table.

The dataset consists of 244 observations, with both numerical and categorical variables that are transformed as needed for analysis.

## Project Steps

1. **Data Preprocessing**
   - Import the dataset and understand its structure using functions such as `head()` and `str()`.
   - Transform categorical variables to factors for easier analysis.
   - Handle missing values (if any) and ensure data consistency.

2. **Exploratory Data Analysis (EDA)**
   - Perform exploratory analysis using the `ggpairs` function to visualize relationships between variables.
   - Identify which variables might have a significant impact on the response variable **tip**.
   - Examine distributions and correlations to determine potential features for the model.

3. **Model Creation**
   - Use linear regression models to predict the **tip** variable.
   - Apply a stepwise algorithm using the AIC criterion to select the best model.
   - Compare multiple models with different combinations of variables and interactions.

4. **Model Evaluation**
   - Evaluate models using AIC, BIC, and cross-validation (k-fold).
   - Conduct residual analysis to check for assumptions such as linearity, normality, and homoscedasticity.
   - Normalize data using Z-score, Min-Max, and logarithmic transformations to improve model performance.
   - Select the best model based on statistical criteria and error metrics.

5. **Results and Conclusions**
   - Identify the most effective model for predicting the **tip** variable.
   - Discuss the impact of different variables and transformations on model performance.
   - Provide visualizations and summaries to demonstrate findings.

## Project Files
- **main.tex**: The LaTeX source code for the report, containing a detailed description of the analysis, methods, and results.
- **images/**: Folder containing the plots and graphs generated during the analysis.
- **R Scripts**: R scripts used for data preprocessing, EDA, modeling, and evaluation.
- **README.md**: This file, providing an overview of the project and usage information.

## Requirements
- **R**: The project uses R for data analysis and modeling. The following libraries are required:
  - `GGally`
  - `MASS`
  - `ggplot2`

- **LaTeX**: To generate the final report in PDF format.

## Running the Project
1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/your-username/exam-project-statistical-models.git
   ```

2. Open the R scripts to preprocess the data, conduct EDA, and train the models. Ensure all required R packages are installed.

3. Compile the **main.tex** file using your preferred LaTeX editor to generate the PDF report.

## Results Summary
The analysis concluded that the logarithmic normalization provided the most effective model for predicting tips. The final model showed improved assumptions of normality, homoscedasticity, and linearity, resulting in a more accurate representation of tipping behavior.

