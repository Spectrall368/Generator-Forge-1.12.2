<@head>
	ScorePlayerTeam _pt = world.getScoreboard().getTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setAllowFriendlyFire(${input$condition});
<@tail>
	}
</@tail>