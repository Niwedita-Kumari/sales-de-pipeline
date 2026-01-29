SELECT * FROM sales_train ORDER BY 3 DESC LIMIT 10; -- 1. Top 10 high value
SELECT 1, COUNT(*), SUM(3), AVG(3) FROM sales_train GROUP BY 1 ORDER BY SUM(3) DESC; -- 2. Group1 totals
SELECT 2, COUNT(*), SUM(3), AVG(3) FROM sales_train GROUP BY 2 ORDER BY SUM(3) DESC; -- 3. Group2 totals
SELECT COUNT(*) FROM sales_train; -- 4. Total rows
SELECT COUNT(DISTINCT 1) FROM sales_train; -- 5. Unique col1
SELECT COUNT(DISTINCT 2) FROM sales_train; -- 6. Unique col2
SELECT COUNT(*) FROM sales_train WHERE 1 IS NULL; -- 7. Null col1
SELECT COUNT(*) FROM sales_train WHERE 2 IS NULL; -- 8. Null col2
SELECT COUNT(*) FROM sales_train GROUP BY 1 HAVING COUNT(*) > 10; -- 9. Frequent col1
SELECT AVG(3), MIN(3), MAX(3), STDDEV(3) FROM sales_train; -- 10. Col3 stats
SELECT 1, SUM(3) OVER (ORDER BY 1) FROM sales_train LIMIT 10; -- 11. Running total
SELECT *, ROW_NUMBER() OVER (ORDER BY 3 DESC) FROM sales_train LIMIT 10; -- 12. Rank values
SELECT 1, AVG(3) FROM sales_train GROUP BY 1 HAVING AVG(3) > (SELECT AVG(3) FROM sales_train); -- 13. Above avg groups
SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY 3 DESC) rn FROM sales_train) WHERE rn <= 3; -- 14. Top 3 per group
SELECT 'Total Rows' as m, COUNT(*) as v FROM sales_train UNION ALL SELECT 'Avg Col3', AVG(3) FROM sales_train; -- 15. Summary stats
