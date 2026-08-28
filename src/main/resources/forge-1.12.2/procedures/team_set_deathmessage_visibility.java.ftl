<@head>
	ScorePlayerTeam _pt = world.getScoreboard().getTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setDeathMessageVisibility(Team.EnumVisible.${field$visibility});
<@tail>
	}
</@tail>