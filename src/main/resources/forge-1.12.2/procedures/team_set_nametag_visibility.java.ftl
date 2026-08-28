<@head>
	ScorePlayerTeam _pt = world.getScoreboard().getTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setNameTagVisibility(Team.EnumVisible.${field$visibility});
<@tail>
	}
</@tail>