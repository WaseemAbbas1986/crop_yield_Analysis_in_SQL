create database crop;
use crop;
select * from yield; 

ALTER TABLE yield MODIFY COLUMN total_cost DECIMAL(20,2);

-- To update a table you have to change the sql mode to safe_update mode
SET SQL_SAFE_UPDATES = 0;

-- Insert total cost column
update yield
set total_cost =
`Seed $/ha` + 
     `$/ha Herbicide (Pre)` + 
     `$/ha Herbicide (incrop)` + 
     `$/ha Herbicide (post)` + 
     `Herbicide cost` + 
     `Fertilizer cost $` + 
     `Machinery cost (planting)` + 
     `Machinery cost (ferti app)` + 
     `Machinery cost (harvesting)` + 
     `Machinery use (herbicide app)` + 
     `Production cost $/ha`;


# Yield by Crop type
select `Current Crop`, round(avg(`Crop Yield kgha`),2)as avg_yield_kgs_per_ha,
min(`Crop Yield kgha`) as minimun_yield_kgs_per_ha,
max(`Crop Yield kgha`) as maximum_yield_kgs_per_ha
from yield
group by `Current Crop`
order by round(avg(`Crop Yield kgha`),2) desc;

-- Total Cost by Crop Type
select `Current Crop`, sum(total_cost)as Total_Cost,
round(sum(`Gross revenue $/ha`),2) as Gross_revenue,
round(sum(`Net revenue $/ha`),2) as Net_Revenue
from yield
group by `Current Crop`
order by sum(total_cost) desc;
-- Statical analysis by year
ALTER TABLE yield CHANGE `ï»¿Year` `Year` int;

select Year,`Current Crop`,
round(sum(`Crop Yield kgha`),2) as Total_yield_kgs,
sum(`total_cost`) as Total_Cost,
round(sum(`Net revenue $/ha`),2) as Total_Net_Revenue
from yield
group by Year,`Current Crop`;

-- Cost Analysis by Expense
SELECT `Current Crop`, round(AVG(`Fertilizer cost $`),2) AS avg_fertilizer_cost, 
round(AVG(`Herbicide cost`),2) AS avg_herbicide_cost, 
round(AVG(`machinery cost (planting)`),2) AS avg_planting_cost,
round(AVG(`machinery cost (ferti app)`),2) AS avg_ferti_app_cost,
round(AVG(`machinery cost (harvesting)`),2) AS avg_harvesting_cost
FROM yield
group by `Current Crop`;

-- Profitability Analysis by Crop Type
SELECT `Current Crop`,
round(AVG(`Net revenue $/ha`),2) AS avg_Net_Revenue,
round(AVG(`Production cost $/ha`),2) AS avg_Production_Cost 
FROM yield
group by `Current Crop`
order by round(AVG(`Net revenue $/ha`),2) desc;

-- Fertilizer Impact Analysis
select `Current Crop`,
round(avg(`Fertilizer Nitrogen kg/ha`),2) AS avg_Fertilizer,
round(avg(`Crop Yield kgha`),2) AS avg_yield,
round(avg(`Net revenue $/ha`),2) AS avg_net_revenue
from yield
group by `Current Crop`
order by round(avg(`Crop Yield kgha`),2) DESC;
-- Treatment Effectiveness Analysis
select `Treatment Number`,
round(avg(`Crop Yield kgha`),2) AS avg_yield,
round(avg(`Net revenue $/ha`),2) AS avg_net_revenue
from yield
group by `Treatment Number`
order by `Treatment Number` DESC;
-- Rotation Profitability Analysis
select `Crop Rotation`, round(avg(`Net revenue $/ha`),2) as avg_net_revenue
from yield
group by `Crop Rotation`
order by avg_net_revenue desc;

-- High-Cost vs. Low-Cost Crop Analysis
select `Current Crop`,
round(sum(`Production cost $/ha`),2) as production_Cost
from yield
group by `Current Crop`
order by round(sum(`Production cost $/ha`),2);

-- Revenue vs. Yield Correlation Analysis
select `Current Crop`,
round(sum(`Crop Yield kgha`),2) as Total_Yield,
round(sum(`Net revenue $/ha`),2) as Net_revenue
from yield
group by `Current Crop`
order by round(sum(`Net revenue $/ha`),2) desc;
