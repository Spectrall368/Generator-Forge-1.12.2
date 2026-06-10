private static int getEntityScore(String score, Entity entity) {
    if(entity instanceof EntityPlayer) {
        Scoreboard scoreboard = entity.world.getScoreboard();
        ScoreObjective scoreboardObjective = scoreboard.getObjective(score);
        if (scoreboardObjective != null)
            return scoreboard.getOrCreateScore(((EntityPlayer) entity).getGameProfile().getName(), scoreboardObjective).getScorePoints();
    }

	return 0;
}