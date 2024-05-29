-- Data Cleaning 

select *
from layoffs;

-- 1. Remove duplicates
-- 2. Standardize data
-- 3. Null values or blank values
-- 4. Remove any columns

create table layoffs_staging
Like layoffs;

select *
from layoffs_staging
where company = 'Wildlife Studios';

insert layoffs_staging
select *
from layoffs;

select *, 
row_number() over 
(partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num 
from layoffs_staging;

with duplicate_cte as
(
select *, 
row_number() over 
(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2;

Delete
from layoffs_staging2
where row_num > 1;

insert into layoffs_staging2
select *, 
row_number() over 
(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs_staging;

-- Standardizing data

select distinct company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
order by 1;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

select distinct country
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

select `date`
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
modify column `date` DATE;

select *
from layoffs_staging2
where industry is null or industry = '-';

update layoffs_staging2
set industry = 'Travel'
where company = 'Airbnb';

select company, industry
from layoffs_staging2
where company = 'Carvana';

update layoffs_staging2
set industry = 'Transportation'
where company = 'Carvana';

select company, industry
from layoffs_staging2
where company like 'Juul';

update layoffs_staging2
set industry = 'Consumer'
where company = 'Juul';

update layoffs_staging2
set industry = '-'
where industry is null;

update layoffs_staging2
set total_laid_off = '-'
where total_laid_off is null;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
order by 1;

ALTER TABLE layoffs_staging2
drop column row_num;