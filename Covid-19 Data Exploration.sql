
/*
	1. Pre-analysis of CovidDeaths dataset: Quick checking of the consistency of numbers within the dataset
		a. Does the max of total_cases (cumulative) equal to the sum of new_cases? 
		b. Does the max of total_deaths (cumulative) equal to the sum of new_deaths?
		c. Are the aggregated values per continent in the dataset consistent with the total sum of values per continent?
		d. Are the aggregated values for the entire world in the dataset consistent with the total sum of values for all countries?	
*/


-- max of total_cases/deaths vs. sum of new_cases/deaths
-- aggregated values for location 'world' vs. sum of values for all countries

SELECT location, 
	MAX(total_cases) AS max_total_cases, 
	SUM(new_cases) AS sum_new_cases, 
	MAX(total_cases) - SUM(new_cases) AS diff_cases,
	MAX(CAST(total_deaths AS int)) AS max_total_deaths, 
	SUM(CAST(new_deaths AS int)) AS sum_new_deaths,
	MAX(CAST(total_deaths AS int)) - SUM(CAST(new_deaths AS int)) AS diff_deaths
FROM PortfolioProject..CovidDeaths
WHERE location = 'World'
GROUP BY location

SELECT 'All Countries' AS location,
	SUM(new_cases) AS sum_new_cases, 
	SUM(CAST(new_deaths AS int)) AS sum_new_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL


-- by continent to check variance in values

SELECT DISTINCT location, 
	SUM(new_cases) OVER (PARTITION BY location) AS sum_new_cases, 
	SUM(new_cases) OVER () AS global_cases,
	SUM(CAST(new_deaths AS int)) OVER (PARTITION BY location) AS sum_new_deaths, 
	SUM(CAST(new_deaths AS int)) OVER () AS global_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND location <> 'World'
ORDER BY location


-- checking countries with inconsistency between max of total_cases/deaths vs. sum of new_cases/deaths

SELECT location, 
	MAX(total_cases) AS max_total_case, 
	SUM(new_cases) AS sum_new_cases, 
	MAX(total_cases) - SUM(new_cases) AS diff_cases,
	MAX(CAST(total_deaths AS int)) AS max_total_death, 
	SUM(CAST(new_deaths AS int)) AS sum_new_death, 
	MAX(CAST(total_deaths AS int)) - SUM(CAST(new_deaths AS int)) AS diff_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX(total_cases) - SUM(new_cases) <> 0 
	OR MAX(CAST(total_deaths AS int)) - SUM(CAST(new_deaths AS int)) <> 0
ORDER BY diff_cases DESC

/*	
	Pre-analysis Results: 
		a. Due to inconsistencies between the max of total_cases/deaths and sum of new_cases/deaths, I decided to use only the new_cases/deaths values in the entire analysis. 
		b. I also opt not to use the rows with aggregated values per continent and for the entire world due to inconsistencies. 



	2. Analysis of CovidDeaths dataset: 
		2.1 By Country
			a. Total cases vs. Population
			b. Total cases vs. Total deaths
			c. Countries with highest infection rate
			d. Countries with highest death count
		2.2 By Continent
			a. Countries with highest infection rate
			b. Countries with highest death count
		2.3 Global
			a. Grand total of cases vs. Grand total of deaths
*/


-- 2.1	ANALYSIS: BY COUNTRY


-- Total cases vs. Population
-- Shows the percentage of population infected with COVID-19 per date, per country

SELECT 
	location, 
	date, 
	population, 
	new_cases,
	SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) AS cumulative_sum_cases,
	SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date)/population * 100 AS cumulative_percentage_cases
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2


-- Total cases vs. Total deaths
-- Shows the likelihood of dying when infected with COVID-19 per date, per country

SELECT 
	location, 
	date, 
	new_cases,
	SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) AS cumulative_sum_cases,
	new_deaths,
	SUM(CAST(new_deaths AS int)) OVER (PARTITION BY location ORDER BY location, date) AS cumulative_sum_deaths,
	SUM(CAST(new_deaths AS int)) OVER (PARTITION BY location ORDER BY location, date) / SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) * 100 AS percentage_death
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2


-- Countries with the highest infection rate relative to their population

SELECT 
	continent,
	location, 
	population, 
	SUM(new_cases) AS total_sum_cases, 
	SUM(new_cases)/population *100 AS infection_rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, location, population
ORDER BY infection_rate DESC


-- Countries with the highest death count
-- Also showing respective death_rate
	
SELECT 
	continent,
	location, 
	SUM(CAST(new_deaths AS int)) AS total_death_count,
	SUM(CAST(new_deaths AS int))/SUM(new_cases) * 100 AS death_rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, location
ORDER BY total_death_count DESC


-- 2.2	ANALYSIS: BY CONTINENT


-- Continents with the highest infection rate relative to their population

SELECT 
	continent,
	SUM(population) AS total_population, 
	SUM(new_cases) AS total_sum_cases, 
	SUM(new_cases)/SUM(population) *100 AS infection_rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY infection_rate DESC


-- Continents with the highest death count 
-- Also showing respective death percentage relative to their population
	
SELECT 
	continent,
	SUM(population) AS total_population,
	SUM(CAST(new_deaths AS int)) AS total_death_count,
	SUM(CAST(new_deaths AS int))/SUM(population) * 100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC


-- 2.3	ANALYSIS: GLOBAL


-- Global numbers: sum_cases, sum_deaths, death_percentage 
-- Shows the overall count of cases, count of deaths, and the likelihood of dying when infected with COVID-19 for the entire world

SELECT 
	SUM(new_cases) AS sum_cases, 
	SUM(CAST(new_deaths AS int)) AS sum_deaths, 
	SUM(CAST(new_deaths AS int))/SUM(new_cases) * 100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL


-- By date, global numbers: total_cases, total_deaths, death_percentage

SELECT 
	date, 
	SUM(new_cases) AS total_cases, 
	SUM(CAST(new_deaths AS int)) AS total_deaths, 
	ROUND((SUM(CAST(new_deaths AS int))/SUM(new_cases))*100,2) AS death_percentage
FROM PortfolioProject..CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date



/*
	3.	Analysis of CovidVaccinations dataset: 
*/


-- Total population vs. Vaccinations

SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_count_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1, 2,3


-- Total population vs. Vaccinations 
-- Showing percentage of people vaccinated relative to population

	--- Using CTE

With PopvsVac (continent, location, date, population, new_vaccinations, cumulative_count_vaccinated) 
AS (
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_count_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
) 

SELECT 
	*, 
	cumulative_count_vaccinated/population * 100 AS percent_vaccinated
FROM PopvsVac
ORDER BY 1,2,3


	--- Using Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255),
date datetime,
population float, 
new_vaccinations float,
cumulative_count_vaccinated float
)

INSERT INTO #PercentPopulationVaccinated 
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_count_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT 
	*, 
	cumulative_count_vaccinated/population *100 AS percent_vaccinated
FROM #PercentPopulationVaccinated
ORDER BY 1,2,3



-- Creating views for visualizations 

CREATE VIEW PercentPopulationVaccinated AS 
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_count_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated



