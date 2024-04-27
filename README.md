# COVID-19 Data Exploration


## Project Overview
This project aims to provide a comprehensive analysis of a COVID-19 dataset. To understand the progression of the COVID-19 virus’ infection and deaths, I wrote a series of SQL commands including joins, various functions (conversion, aggregate, window functions), CTE, temporary tables, and views.  Also, a dashboard is created as the final output of the project.

## Data Sources
The dataset is sourced from [Our World in Data](https://ourworldindata.org/covid-deaths), and the version of the dataset utilized for this project is the May 2021 version which is available in this repository and can also be found [here](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidDeaths.xlsx). 
- CovidDeaths.xlxs
- CovidVaccinations.xlxs

## Tools
- SQL Server – Pre-Analysis, Data Analysis
- Tableau – Dashboard 

## Data Cleaning/Preparation
Before doing the actual analysis, I performed a quick checking of the consistency of numbers within the dataset. Due to some inconsistencies found as detailed in the SQL code file, I decided to use only the values from columns new_cases and new_deaths for the entire analysis. 

## Exploratory Data Analysis
The analysis explores the following areas: 
- By Country
  -	Total cases vs. Population – showing the percentage of population infected with COVID-19
  -	Total cases vs. Total deaths – showing the likelihood of death when infected with COVID-19
  -	Countries with highest infection rate
  -	Countries with highest death count
- By Continent
  -	Rank of continents based on the highest count of cases
  -	Rank of continents based on the highest death count
- Global
  - Grand total of cases vs. Grand total of deaths – showing the total number of cases and deaths reported and the percentage of death globally 

## Results/Findings
- Andorra has the highest infection rate or the percentage of population infected with COVID-19.
- United States has the highest count of cases and deaths compared to other countries, and ranked ninth place on the countries with highest infection rate.  
- Europe has the highest count of cases and deaths compared to other continents. 
- Worldwide, there have been 3.18 million reported deaths out of 150.57 million COVID-19 cases, resulting in a death rate of 2.11%.


## Visualization
Below is the screenshot of the dashboard created for this project which can be accessed and downloaded downloaded [here](https://public.tableau.com/app/profile/charmaine.santiago/viz/COVID-19CasesDeathTracker/ByContinentDashboard).

![image](https://github.com/CharmaineSantiago/covid19-data-exploration/assets/158445656/e1ef14cd-acf7-4b82-b15b-36b6e226bc85)

![image](https://github.com/CharmaineSantiago/covid19-data-exploration/assets/158445656/3c1f8463-3778-4588-ae3e-42a2db35388a)


## Limitations
This project is limited to January 23, 2020 to April 30, 2021 data on COVID-19 and focuses only on the number of cases and deaths reported. 


