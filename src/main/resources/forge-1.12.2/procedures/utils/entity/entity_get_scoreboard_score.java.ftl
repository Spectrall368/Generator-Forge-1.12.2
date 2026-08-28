private static int getEntityScore(String score, Entity entity) {
	Scoreboard scoreboard = entity.world.getScoreboard();
	ScoreObjective scoreboardObjective = scoreboard.getObjective(score);
	if (scoreboardObjective != null)
		return scoreboard.getOrCreateScore(entity.getScoreboardName(), scoreboardObjective).getScorePoints();
	return 0;
}