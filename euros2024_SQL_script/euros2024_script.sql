/* Three common table expressions (CTE) are used to create temporary calculations which will help with calculating the amount of goals that each team scored within the tournament along with the amounts of goals conceded. 
Since these teams in the table are under the columns "home_team" or "away_team" using CTE it can help categorize them into just teams. Within the last CTE called 'Combined Stats' the UNION ALL clause combines 
all the data even if there are duplicates of the teams which contain different amounts of goals scored and conceded. The last query will help clean and get the data that is needed. The aggregate function SUM along with the 
GROUP BY clause is used to categorize each team into one row of data and take the sum of goals scored and goals conceded. Once the query is run it is then noticed there are no duplicate teams and each team has its total goals
scored along with goals conceded. */
-- Used to create the euros_goals_scored and euros_goals_scored sheets in Tableau--
WITH HomeStats AS (
SELECT 
	home_team AS team,
	home_goals AS goals_scored,
	away_goals AS goals_conceded
FROM euros2024_matches
),
AwayStats AS (
SELECT 
	away_team AS team,
    away_goals AS goals_scored,
    home_goals AS goals_conceded
FROM euros2024_matches
),

CombinedStats AS (
	SELECT * FROM HomeStats
    UNION ALL
    SELECT * FROM AwayStats
)
SELECT 
	team,
    SUM(goals_scored) AS total_goals_scored,
    SUM(goals_conceded) AS total_goals_conceded,
    (SUM(goals_scored) - SUM(goals_conceded)) AS goal_difference 
FROM CombinedStats
GROUP BY team
ORDER BY total_goals_scored DESC


/*The following CTE was used to gather the overall total of each stat such as goals scored, yellow cards, red cards, big chances missed, and fouls committed. Since the teams are either in the column "home_team" or "away_team" 
The CTE is used to gather the SUM of each stat whether it's in the home or away column. Then the following query afterwards is used to combine the stat for home and away into just one row to get the overall total. For example, in the CTE
there are two rows created separately for the yellow card the home team received and the yellow cards the away team received. Then in the following query, both the home team's yellow cards and the away team's yellow cards are combined into one
row of data to get the overall yellow cards given in the tournament. */
-- Used to create the tournament_data sheet in tableau--

WITH tournament_calculation AS (
SELECT 
    SUM(home_goals) AS total_home_goals,
    SUM(away_goals) AS total_away_goals,
    SUM(home_yellow_cards) AS total_home_yellow_cards,
    SUM(away_yellow_cars) AS total_away_yellow_cards,
    SUM(home_red_cards) AS total_home_red_cards,
    SUM(away_red_cars) AS total_away_red_cards
    SUM(home_big_chances_missed) AS total_home_big_chances_missed,
    SUM(away_big_chances_missed) AS total_away_big_chances_missed,
    SUM(home_fouls_committed) AS total_home_fouls_committed,
    SUM(away_fouls_commited) AS total_away_fouls_committed
FROM euros2024_matches
)
SELECT
	total_home_goals + total_away_goals AS total_goals,
    total_home_yellow_cards + total_away_yellow_cards AS total_yellow_cards,
    total_home_red_cards + total_away_red_cards AS total_red_cards,
    total_home_big_chances_missed + total_away_big_chances_missed AS total_big_chances_missed,
    total_home_fouls_committed + total_away_fouls_committed AS total_fouls_committed
FROM tournament_calculation

