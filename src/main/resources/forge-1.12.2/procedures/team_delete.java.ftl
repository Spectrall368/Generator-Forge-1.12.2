{
    ScorePlayerTeam _pt = world.getScoreboard().getTeam(${input$name});
        if (_pt != null)
            world.getScoreboard().removeTeam(_pt);
}