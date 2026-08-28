if(world instanceof WorldServer) {
	Entity _entityToSpawn = ${input$projectile?replace("projectileLevel", "world")};
	_entityToSpawn.setPosition(${input$x}, ${input$y}, ${input$z});
	if (_entityToSpawn instanceof IProjectile)
	    ((IProjectile) _entityToSpawn).shoot(${input$dx}, ${input$dy}, ${input$dz}, ${opt.toFloat(input$speed)}, ${opt.toFloat(input$inaccuracy)});
	((WorldServer) world).spawnEntity(_entityToSpawn);
}
