{
	Entity _entityTeam = ${input$entity};
	ScorePlayerTeam _pt = _entityTeam.world.getScoreboard().getTeam(${input$name});
	if (_pt != null)
		_entityTeam.world.getScoreboard().removePlayerFromTeam(_entityTeam.getCachedUniqueIdString(), _pt);
}