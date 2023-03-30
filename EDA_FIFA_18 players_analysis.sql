SELECT * FROM FIFA_18;

--How many football players are there in FIFA organization?
SELECT COUNT(*) FROM FIFA_18;

--How many nationalities are there?
SELECT COUNT (DISTINCT(NATIONALITY))AS "NUMBER OF NATIONS" FROM FIFA_18;

--How many players from each country - i.e., frequency of nationality?
SELECT COUNT(ID) AS "FREQUENCY_OF_NATION", NATIONALITY FROM FIFA_18 
GROUP BY NATIONALITY
ORDER BY FREQUENCY_OF_NATION DESC;

--TOP 5 NATION FREQUENCY
SELECT * FROM(
SELECT COUNT(ID) AS "FREQUENCY_OF_NATION", NATIONALITY FROM FIFA_18 
GROUP BY NATIONALITY
ORDER BY FREQUENCY_OF_NATION DESC ) WHERE ROWNUM <=5;

--What is the highest amount of wage paid to the player?
SELECT MAX(WAGE) AS "HIGHEST_WAGE" FROM FIFA_18;

--Which player is getting paid highest and from which country?
SELECT NAME, NATIONALITY FROM FIFA_18 WHERE WAGE=(SELECT MAX(WAGE) AS "HIGHEST_WAGE" FROM FIFA_18);

--What is the minimum wage paid?
SELECT MIN(WAGE) AS "MINIMUM_WAGE" FROM FIFA_18;

--Which player has got overall highest rating and from which club?
SELECT NAME, OVERALL, CLUB FROM FIFA_18 WHERE OVERALL= (SELECT MAX(OVERALL) FROM FIFA_18);

--Which are top-3 clubs based on the overall rating?
SELECT * FROM
(
SELECT CLUB,OVERALL, DENSE_RANK() OVER (ORDER BY OVERALL DESC)AS RANK FROM FIFA_18
)
WHERE RANK<=3;

--Who are the players registered at ‘Paris Saint-Germain’ club?
SELECT NAME ,CLUB FROM FIFA_18 WHERE CLUB='Paris Saint-Germain';

--Who are players with preffered position as RE, LW, GK?
SELECT NAME, CLUB,PREFERRED_POSITIONS FROM FIFA_18 WHERE PREFERRED_POSITIONS IN ('RW', 'LW', 'GK');

--Players with age greater than 30?
SELECT NAME, CLUB, AGE FROM FIFA_18 WHERE AGE>30;

