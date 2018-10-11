-- Не стал городить свой велосипед для функции-аггрегатора медианы, так как вроде есть предложения для стандарта от сообщества
-- Взял отсюда https://wiki.postgresql.org/wiki/Aggregate_Median 

CREATE OR REPLACE FUNCTION _final_median(NUMERIC[])
   RETURNS NUMERIC AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;
 
CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

-----------------------
CREATE OR REPLACE FUNCTION get_suitable_categories(sum INTEGER)
    RETURNS TABLE(
        title TEXT,
        median INTEGER,
        ammount BIGINT -- Я так и не понял почему он тут при компиляции ругался на обычный инт и просит биг
    ) AS 
$$
    SELECT category.title, 
        ABS(cast(median(costs.value) as INTEGER) - sum) as category_median, 
        COUNT(costs) as cost_count
    FROM costs
    JOIN category
        ON costs.category_id = category.id
    GROUP BY category.title
    ORDER BY category_median ASC, cost_count DESC;
$$
LANGUAGE 'sql' IMMUTABLE;

