-- ============================================
-- Demographic Analysis: Mexico & Nuevo León
-- ============================================
-- This script extracts and aggregates population data
-- used for demographic analysis and visualization.


-- --------------------------------------------
-- 1. Explore dataset
-- --------------------------------------------
select *
from pobproy_inddemo t 
limit (10)

-- --------------------------------------------
-- 2. Validate year range
-- --------------------------------------------
SELECT 
MIN("ANO"::int) AS primer_anio,
MAX("ANO"::int) AS ultimo_anio
FROM pobproy_inddemo;

-- --------------------------------------------
-- 3. Standardize column names
-- --------------------------------------------
ALTER TABLE pobproy_inddemo
RENAME COLUMN "ANO" TO ano;

-- --------------------------------------------
-- 4. Total population by year (Mexico)
-- --------------------------------------------
SELECT
ano::int AS anio,
SUM(DISTINCT "POB_MIT_ENT"::numeric) AS poblacion_total
FROM pobproy_inddemo
GROUP BY ano
ORDER BY ano;

-- --------------------------------------------
-- 5. Population growth rate
-- --------------------------------------------
SELECT
ano,
poblacion_total,
(poblacion_total - LAG(poblacion_total) OVER (ORDER BY ano))
/ LAG(poblacion_total) OVER (ORDER BY ano) * 100 AS crecimiento
FROM (
    SELECT
    ano,
    SUM(DISTINCT "POB_MIT_ENT"::numeric) AS poblacion_total
    FROM pobproy_inddemo
    GROUP BY ano
) t
ORDER BY ano;

-- --------------------------------------------
-- 6. Total population (Nuevo León)
-- --------------------------------------------
SELECT
ano,
MAX("POB_MIT_ENT"::numeric) AS poblacion_nl
FROM pobproy_inddemo
WHERE "CLAVE_ENT" = '19'
GROUP BY ano
ORDER BY ano;

-- --------------------------------------------
-- 7. Population growth rate (Nuevo León)
-- --------------------------------------------
SELECT
ano,
poblacion_nl,
(poblacion_nl - LAG(poblacion_nl) OVER (ORDER BY ano))
/ LAG(poblacion_nl) OVER (ORDER BY ano) * 100 AS crecimiento
FROM (
    SELECT
    ano,
    MAX("POB_MIT_ENT"::numeric) AS poblacion_nl
    FROM pobproy_inddemo
    WHERE "CLAVE_ENT" = '19'
    GROUP BY ano
) t
ORDER BY ano;

