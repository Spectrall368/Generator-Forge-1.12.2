{
	Entity _ent = ${input$entity};
	Scoreboard _sc = _ent.world.getScoreboard();
	ScoreObjective _so = _sc.getObjective(${input$score});
	if (_so == null)
		_so = _sc.addScoreObjective("${input$score}", ScoreCriteria.DUMMY);
	_sc.getOrCreateScore(_ent.getScoreboardName(), _so).setScorePoints(${opt.toInt(input$value)});
}