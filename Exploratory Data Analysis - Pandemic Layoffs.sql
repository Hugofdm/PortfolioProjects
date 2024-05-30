-- Exploratory Data Analysis

select *
from layoffs_staging2;

select *
from layoffs_staging2
where country = 'Brazil' and percentage_laid_off >= 0.1
order by funds_raised_millions desc;

select company, sum(total_laid_off) as smlo
from layoffs_staging2
group by company
order by smlo desc;

select industry, sum(total_laid_off) 
from layoffs_staging2
group by industry
order by 2 desc;

select year(`date`), sum(total_laid_off) 
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select substring(`date`, 1,7) as month, sum(total_laid_off) 
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by month
order by 1 asc;

with rolling_total as 
(
select substring(`date`, 1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off, sum(total_off) over (order by `month`) as rolling_total
from rolling_total;

select company, `date`, country, sum(total_laid_off)
from layoffs_staging2
group by company, `date`, country
order by company asc;

select company, year(`date`), country, sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`), country
order by year(`date`) asc;

WITH company_year (company, years, country, total_laid_off) as 
(
select company, year(`date`), country, sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`), country
)
select *
from company_year;

WITH company_year (company, years, country, total_laid_off) as 
(
select company, year(`date`), country, sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`), country
)
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null;

WITH company_year (company, years, country, total_laid_off) as 
(
select company, year(`date`), country, sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`), country
), Company_Year_Rank as
(
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from Company_Year_Rank
where ranking <=5;