{
	Entity _entityTeam = ${input$entity};
	ScorePlayerTeam _pt = _entityTeam.world.getScoreboard().getTeam(${input$name});
	if (_pt != null) {
		if (_entityTeam instanceof EntityPlayer)
			_entityTeam.world.getScoreboard().addPlayerToTeam(((EntityPlayer) _entityTeam).getGameProfile().getName(), _pt);
		else
			_entityTeam.world.getScoreboard().addPlayerToTeam(_entityTeam.getCachedUniqueIdString(), _pt);
	}
}